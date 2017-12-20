#include <army_ranks>

new iRegenHp[MAXPLAYERS + 1];
new g_iHealth[MAXPLAYERS + 1];

new Float:fRegenHp_Timer[MAXPLAYERS + 1];
new Float:fDelayRegenHp[MAXPLAYERS + 1];

new Handle:g_Timer[MAXPLAYERS + 1];
new Handle:g_DelayTimer[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
	name = "[ ARMY ] Регенерация Здоровья/Regeneration Health", 
	author = "sahapro33", 
	description = "", 
	version = "1.4"
}
new bool:g_bActive = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
}
public OnMapStart()
{
	g_bActive = (Army_GetMapSettings("RegenHp") == 1);
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
	iRegenHp[client] = 0;
}

public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (g_bActive && (iRegenHp[client] = Army_GetNumAtributes(client, "RegenHp", 0)) > 0)
	{
		if ((fRegenHp_Timer[client] = Army_GetFloatAtributes(client, "IntervalRegenHp", "0.0")) > 0.0)
		{
			decl String:Buffer[100];
			FormatEx(Buffer, sizeof(Buffer), "%t", "RHP");
			Army_RegisterItem(client, "RegenHp", Buffer);
		}
	}
}

public ARMY_ArmyUp(client)
{
	if (g_bActive && (iRegenHp[client] = Army_GetNumAtributes(client, "RegenHp", 0)) > 0)
	{
		if ((fRegenHp_Timer[client] = Army_GetFloatAtributes(client, "IntervalRegenHp", "0.0")) > 0.0)
		{
			decl String:Buffer[100];
			FormatEx(Buffer, sizeof(Buffer), "%t", "RHP");
			Army_RegisterItem(client, "RegenHp", Buffer);
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
	fRegenHp_Timer[client] = Army_GetFloatAtributes(client, "IntervalRegenHp", "0.0");
	fDelayRegenHp[client] = Army_GetFloatAtributes(client, "DelayRegenHp", "0.0");
	iRegenHp[client] = Army_GetNumAtributes(client, "RegenHp", 0);
	g_iHealth[client] = Army_GetNumAtributes(client, "Hp", 100);
}
public player_hurt(Handle:event, const String:name[], bool:silent)
{
	if (!g_bActive)return;
	if (GetEventInt(event, "health") < 1)
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
	
	if (fRegenHp_Timer[client] > 0.0 && iRegenHp[client] > 0)
	{
		if (fDelayRegenHp[client] > 0.0)g_DelayTimer[client] = CreateTimer(fDelayRegenHp[client], DelayRegen, client);
		else g_Timer[client] = CreateTimer(fRegenHp_Timer[client], Regen, client, TIMER_REPEAT);
	}
}

public Action:DelayRegen(Handle:timer, any:client)
{
	if (g_bActive && 0 < client <= MaxClients && IsClientInGame(client) && IsPlayerAlive(client))
	{
		g_Timer[client] = CreateTimer(fRegenHp_Timer[client], Regen, client, TIMER_REPEAT);
	}
	g_DelayTimer[client] = INVALID_HANDLE;
	return Plugin_Stop;
}

public Action:Regen(Handle:timer, any:client)
{
	if (g_bActive && IsPlayerAlive(client))
	{
		new hp = GetEntProp(client, Prop_Send, "m_iHealth");
		if (hp < g_iHealth[client])
		{
			hp += iRegenHp[client];
			if (hp > g_iHealth[client])hp = g_iHealth[client];
			SetEntProp(client, Prop_Send, "m_iHealth", hp);
			if (hp < g_iHealth[client])return Plugin_Continue;
		}
	}
	g_Timer[client] = INVALID_HANDLE;
	return Plugin_Stop;
} 