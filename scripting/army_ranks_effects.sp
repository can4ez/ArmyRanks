#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <army_ranks>

public Plugin:myinfo = 
{
    name = "[ ARMY ] Effects",
    author = "sahapro33",
    description = "",
    version = "1.1"
}

new Handle:rankup_effect;
new Handle:reset_effect;
new Handle:setkills_or_setdeaths_effect;

public OnPluginStart()
{
    rankup_effect        = CreateConVar("rankup_effect", "1",    "Включить эффект при получении звания?");
    reset_effect        = CreateConVar("reset_effect", "1",    "Включить эффект при обнулении?");
    setkills_or_setdeaths_effect        = CreateConVar("setkills_or_setdeaths_effect", "1",    "Включить эффект при установки убийств или смертей (через админку)?");
}

public ARMY_ArmyUp(client,const String:sNewRank[],mode)
{
    if(client>0 && client<=MaxClients && IsClientConnected(client) && IsClientInGame(client))
    {
        if(mode==MODE_RANK_UP)
		{            
			if(GetConVarBool(rankup_effect))
			{
				decl Float:p[3];
				GetClientAbsOrigin(client, p);
				SpotLight3(client, p);
			}
		}
		else if(mode==MODE_RANK_RESET)
		{
			if(GetConVarBool(reset_effect))
			{
				decl Float:p[3];
				GetClientAbsOrigin(client, p);
				new entity = CreateEntityByName("info_particle_system", -1);
				if (entity < 1)
				{
					LogError("Can't create 'info_particle_system'");
					return;
				}
				DispatchKeyValue(entity, "effect_name", "env_fire_large");
				DispatchKeyValueVector(entity, "origin", p);
				DispatchSpawn(entity);
				SetVariantString("!activator");
				AcceptEntityInput(entity, "SetParent", client);
				ActivateEntity(entity);
				AcceptEntityInput(entity, "Start");
				SetVariantString("OnUser1 !self:kill::10.5:1");
				AcceptEntityInput(entity, "AddOutput");
				AcceptEntityInput(entity, "FireUser1");
			}
		}
		else if(mode==MODE_SET_KILLS || mode==MODE_SET_DEATHS)
		{
			if(GetConVarBool(setkills_or_setdeaths_effect))
			{
				decl Float:p[3];
				GetClientAbsOrigin(client, p);
				new entity = CreateEntityByName("env_spark", -1);
				if (entity < 1)
				{
					LogError("Can't create 'env_spark'");
					return;
				}
				p[2] += 45.0;
				DispatchKeyValueVector(entity, "origin", p);
				DispatchKeyValue(entity, "Magnitude", "8");
				DispatchKeyValue(entity, "MaxDelay", "3");
				DispatchKeyValue(entity, "TrailLength", "2");
				DispatchSpawn(entity);
				AcceptEntityInput(entity, "StartSpark");
				SetVariantString("OnUser1 !self:kill::0.3:1");
				AcceptEntityInput(entity, "AddOutput");
				AcceptEntityInput(entity, "FireUser1");
				return;
			}
		}
    }
}

SpotLight3(client, Float:center[3])
{
	decl Float:p1[3];
	decl Float:p2[3];
	decl Float:p3[3];
	if (Get3Coords(center, p1, p2, p3, 50.0))
	{
		new entity = CreateEntityByName("func_rotating", -1);
		decl String:RotatorName[28];
		Format(RotatorName, 25, "rttr%d", entity);
		DispatchKeyValue(entity, "targetname", RotatorName);
		DispatchKeyValueVector(entity, "origin", center);
		DispatchKeyValue(entity, "spawnflags", "64");
		DispatchKeyValue(entity, "friction", "20");
		SetEntPropFloat(entity, Prop_Data, "m_flMaxSpeed", 150.0, 0);
		DispatchKeyValue(entity, "dmg", "0");
		DispatchKeyValue(entity, "solid", "0");
		DispatchSpawn(entity);
		SetVariantString("OnUser1 !self:kill::10.5:1");
		AcceptEntityInput(entity, "AddOutput");
		AcceptEntityInput(entity, "FireUser1");
		SpotLight3Go(p1, RotatorName);
		SpotLight3Go(p2, RotatorName);
		SpotLight3Go(p3, RotatorName);
		SetVariantString("!activator");
		AcceptEntityInput(entity, "SetParent", client, entity);
		AcceptEntityInput(entity, "Start");
	}
	return;
}

SpotLight3Go(Float:p[3], String:RotatorName[])
{
	new entity = CreateEntityByName("point_spotlight", -1);
	if (entity < 1)
	{
		LogError("Can't create point_spotlight");
		return 0;
	}
	DispatchKeyValue(entity, "spawnflags", "2");
	DispatchKeyValueVector(entity, "origin", p);
	DispatchKeyValue(entity, "SpotlightLength", "150");
	DispatchKeyValue(entity, "SpotlightWidth", "25");
	DispatchKeyValue(entity, "rendermode", "5");
	new String:sRGB[10];
	FormatEx(sRGB,sizeof(sRGB),"%d %d %d",GetRandomInt(0,255),GetRandomInt(0,255),GetRandomInt(0,255));
	DispatchKeyValue(entity, "rendercolor", sRGB);
	DispatchKeyValue(entity, "renderamt", "255");
	DispatchKeyValue(entity, "scale", "5");
	DispatchKeyValue(entity, "angles", "-90 0 0");
	DispatchSpawn(entity);
	SetVariantString(RotatorName);
	AcceptEntityInput(entity, "SetParent");
	AcceptEntityInput(entity, "LightOn");
	SetVariantString("OnUser1 !self:LightOff::9.9:1");
	AcceptEntityInput(entity, "AddOutput");
	SetVariantString("OnUser1 !self:kill::10.0:1");
	AcceptEntityInput(entity, "AddOutput");
	AcceptEntityInput(entity, "FireUser1");
	return entity;
}

bool:Get3Coords(Float:center[3], Float:p1[3], Float:p2[3], Float:p3[3], Float:dist)
{
	new entity = CreateEntityByName("prop_dynamic_override", -1);
	if (entity < 1)
	{
		LogError("CreateEntityByName error: prop_dynamic_override");
		return false;
	}
	DispatchKeyValueVector(entity, "origin", center);
	//SetEntityModel(entity, "models/props/cs_office/vending_machine.mdl");
	DispatchKeyValue(entity, "solid", "0");
	DispatchSpawn(entity);
	Get3Coords_p(entity, p1, dist);
	Get3Coords_p(entity, p2, dist);
	Get3Coords_p(entity, p3, dist);
	AcceptEntityInput(entity, "Kill");
	return true;
}

Get3Coords_p(entity, Float:pos[3], Float:dist)
{
	decl Float:a[3];
	GetEntPropVector(entity, PropType:0, "m_angRotation", a, 0);
	a[1] += 120.0;
	TeleportEntity(entity, NULL_VECTOR, a, NULL_VECTOR);
	decl Float:p[3];
	GetEntPropVector(entity, PropType:1, "m_vecAbsOrigin", p, 0);
	decl Float:direction[3];
	a[0] = 0.0;
	a[2] = 0.0;
	GetAngleVectors(a, direction, NULL_VECTOR, NULL_VECTOR);
	p[0] = p[0] + direction[0] * dist;
	p[1] = p[1] + direction[1] * dist;
	pos[0] = p[0];
	pos[1] = p[1];
	pos[2] = p[2];
	return;
}