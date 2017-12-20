#include <army_ranks>

new Bhop[MAXPLAYERS + 1], LongJump[MAXPLAYERS + 1];

new VelocityOffset_0 = -1, 
VelocityOffset_1 = -1, 
BaseVelocityOffset = -1;

public Plugin:myinfo = 
{
	name = "[ ARMY ] Распрыг & Длинный прыжок / Bhop & Long Jump", 
	author = "KOROVKA, R1KO, sahapro33", 
	description = "", 
	version = "1.4"
}

new bool:g_bActive_Bhop = false;
new bool:g_bActive_LongJump = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
}
public OnMapStart()
{
	g_bActive_Bhop = (Army_GetMapSettings("Bhop") == 1);
	g_bActive_LongJump = (Army_GetMapSettings("LongJump") == 1);
}

public OnPluginStart()
{
	VelocityOffset_0 = GetSendPropOffset("CBasePlayer", "m_vecVelocity[0]");
	VelocityOffset_1 = GetSendPropOffset("CBasePlayer", "m_vecVelocity[1]");
	BaseVelocityOffset = GetSendPropOffset("CBasePlayer", "m_vecBaseVelocity");
	
	HookEvent("player_jump", Event_PlayerJump);
}

public ARMY_PlayerSpawn(client)GetJump(client);
public ARMY_ArmyUp(client)GetJump(client);
public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])GetJump(client);

GetJump(client)
{
	if (g_bActive_Bhop && (Bhop[client] = Army_GetNumAtributes(client, "Bhop", 0)) > 0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer, sizeof(Buffer), "%t", "BHOP");
		Army_RegisterItem(client, "Bhop", Buffer);
	}
	if (g_bActive_LongJump && (LongJump[client] = Army_GetNumAtributes(client, "LongJump", 0)) > 0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer, sizeof(Buffer), "%t", "LJ");
		Army_RegisterItem(client, "LongJump", Buffer);
	}
}

GetSendPropOffset(const String:sNetClass[], const String:sPropertyName[])
{
	new iOffset = FindSendPropOffs(sNetClass, sPropertyName);
	if (iOffset == -1)SetFailState("Fatal Error: Unable to find offset: \"%s::%s\"", sNetClass, sPropertyName);
	
	return iOffset;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if (g_bActive_Bhop && Bhop[client] > 0 && IsPlayerAlive(client))
	{
		if (buttons & IN_JUMP)
		{
			if (!(GetEntityFlags(client) & FL_ONGROUND))
			{
				if (!(GetEntityMoveType(client) & MOVETYPE_LADDER))
				{
					if (GetEntProp(client, Prop_Data, "m_nWaterLevel") <= 1)
					{
						buttons &= ~IN_JUMP;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action:Event_PlayerJump(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_bActive_LongJump)
	{
		new client = GetClientOfUserId(GetEventInt(event, "userid"));
		if (LongJump[client] > 0 && IsPlayerAlive(client))
		{
			decl Float:finalvec[3];
			finalvec[0] = GetEntDataFloat(client, VelocityOffset_0) * 1.2 / 2.0;
			finalvec[1] = GetEntDataFloat(client, VelocityOffset_1) * 1.2 / 2.0;
			finalvec[2] = 0.0;
			SetEntDataVector(client, BaseVelocityOffset, finalvec, true);
		}
	}
} 