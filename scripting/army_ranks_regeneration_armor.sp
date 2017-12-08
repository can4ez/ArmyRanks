#include <army_ranks>

new iRegenArmor[MAXPLAYERS + 1];
new g_iArmor[MAXPLAYERS + 1];

new Float:fRegenArmor_Timer[MAXPLAYERS + 1];
new Float:fDelayRegenArmor[MAXPLAYERS + 1];

new Handle:g_Timer[MAXPLAYERS + 1];
new Handle:g_DelayTimer[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
	name = "[ ARMY ] Регенерация Брони/Regeneration Armor", 
	author = "sahapro33", 
	description = "", 
	version = "1.4"
}

new bool:g_bActive = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
	g_bActive = (Army_GetMapSettings("RegenArmor") == 1);
}
public OnPluginStart()
{
	HookEvent("player_hurt", player_hurt);
}

public OnClientDisconnect(client)
{
	if (g_Timer[client] != INVALID_HANDLE)
	{
		KillTimer(g_Timer[client]);
		g_Timer[client] = INVALID_HANDLE;
	}
	iRegenArmor[client] = 0;
}

public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (g_bActive && (iRegenArmor[client] = Army_GetNumAtributes(client, "RegenArmor", 0)) > 0)
	{
		if ((fRegenArmor_Timer[client] = Army_GetFloatAtributes(client, "IntervalRegenArmor", "0.0")) > 0.0)
		{
			decl String:Buffer[100];
			FormatEx(Buffer, sizeof(Buffer), "%t", "RARMOR");
			Army_RegisterItem(client, "RegenArmor", Buffer);
		}
	}
}

public ARMY_ArmyUp(client)
{
	if (g_bActive && (iRegenArmor[client] = Army_GetNumAtributes(client, "RegenArmor", 0)) > 0)
	{
		if ((fRegenArmor_Timer[client] = Army_GetFloatAtributes(client, "IntervalRegenArmor", "0.0")) > 0.0)
		{
			decl String:Buffer[100];
			FormatEx(Buffer, sizeof(Buffer), "%t", "RARMOR");
			Army_RegisterItem(client, "RegenArmor", Buffer);
		}
	}
}

public ARMY_PlayerSpawn(client)
{
	if (g_Timer[client] != INVALID_HANDLE)
	{
		KillTimer(g_Timer[client]);
		g_Timer[client] = INVALID_HANDLE;
	}
	if (g_DelayTimer[client] != INVALID_HANDLE)
	{
		KillTimer(g_DelayTimer[client]);
		g_DelayTimer[client] = INVALID_HANDLE;
	}
	if (!g_bActive)return;
	fRegenArmor_Timer[client] = Army_GetFloatAtributes(client, "IntervalRegenArmor", "0.0");
	fDelayRegenArmor[client] = Army_GetFloatAtributes(client, "DelayRegenArmor", "0.0");
	iRegenArmor[client] = Army_GetNumAtributes(client, "RegenArmor", 0);
	
	g_iArmor[client] = Army_GetNumAtributes(client, "Armor", 100);
}
public player_hurt(Handle:event, const String:name[], bool:silent)
{
	if (!g_bActive)return;
	
	if (GetEventInt(event, "dmg_armor") < 1)
		return;
	
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (g_Timer[client] != INVALID_HANDLE)
	{
		KillTimer(g_Timer[client]);
		g_Timer[client] = INVALID_HANDLE;
	}
	if (g_DelayTimer[client] != INVALID_HANDLE)
	{
		KillTimer(g_DelayTimer[client]);
		g_DelayTimer[client] = INVALID_HANDLE;
	}
	
	if (fRegenArmor_Timer[client] > 0.0 && iRegenArmor[client] > 0)
	{
		if (fDelayRegenArmor[client] > 0.0)g_DelayTimer[client] = CreateTimer(fDelayRegenArmor[client], DelayRegen, client);
		else g_Timer[client] = CreateTimer(fRegenArmor_Timer[client], Regen, client, TIMER_REPEAT);
	}
}

public Action:DelayRegen(Handle:timer, any:client)
{
	if (g_bActive && 0 < client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
	{
		g_Timer[client] = CreateTimer(fRegenArmor_Timer[client], Regen, client, TIMER_REPEAT);
	}
	g_DelayTimer[client] = INVALID_HANDLE;
	return Plugin_Stop;
}

public Action:Regen(Handle:timer, any:client)
{
	if (g_bActive && IsPlayerAlive(client))
	{
		new Armor = GetEntProp(client, Prop_Send, "m_ArmorValue");
		if (Armor < g_iArmor[client])
		{
			Armor += iRegenArmor[client];
			if (Armor > g_iArmor[client])Armor = g_iArmor[client];
			SetEntProp(client, Prop_Send, "m_ArmorValue", Armor);
			if (Armor < g_iArmor[client])return Plugin_Continue;
		}
	}
	g_Timer[client] = INVALID_HANDLE;
	return Plugin_Stop;
} 