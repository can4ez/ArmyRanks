#include <army_ranks>
#include <sdktools> 

new iFastReload[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
	name = "[ ARMY ] Быстрая перезорядка/FastReload", 
	author = "sahapro33", 
	description = "", 
	version = "1.4"
}

new bool:g_bActive = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
}
public OnPluginStart()
{
	HookEvent("weapon_reload", weapon_reload);
}
public OnMapStart()
{
	g_bActive = (Army_GetMapSettings("FastReload") == 1);
}
public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (g_bActive && (iFastReload[client] = Army_GetNumAtributes(client, "FastReload", 0)) == 0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer, sizeof(Buffer), "%t", "FAST_RELOAD");
		Army_RegisterItem(client, "FastReload", Buffer);
	}
}

public ARMY_PlayerSpawn(client)
{
	if (!g_bActive)return;
	iFastReload[client] = Army_GetNumAtributes(client, "FastReload", 0);
}

public ARMY_ArmyUp(client)
{
	if (!g_bActive)return;	
	if ((iFastReload[client] = Army_GetNumAtributes(client, "FastReload", 0)) == 1)
	{
		decl String:Buffer[100];
		FormatEx(Buffer, sizeof(Buffer), "%t", "FAST_RELOAD");
		Army_RegisterItem(client, "FastReload", Buffer);
	}
}

public weapon_reload(Handle:event, const String:name[], bool:silent)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (iFastReload[client] != 1)return;
	if (GetPlayerWeaponSlot(client, 2) > 0)
	{
		SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GetGameTime());
		ClientCommand(client, "lastinv");
		CreateTimer(0.01, LastInv_Timer, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:LastInv_Timer(Handle:timer, any:client)
{
	if (IsClientInGame(client))ClientCommand(client, "lastinv");
	return Plugin_Stop;
} 