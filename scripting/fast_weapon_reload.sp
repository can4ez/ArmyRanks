#pragma semicolon 1

#include <sourcemod>
#include <sdktools_functions>

public Plugin:myinfo = 
{
	name	= "Fast Weapon Reload",
	author	= "wS (World-Source.Ru)",
	version = "1.1"
};

public OnPluginStart()
{
	HookEvent("weapon_reload", weapon_reload);
}

public weapon_reload(Handle:event, const String:name[], bool:silent)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (GetPlayerWeaponSlot(client, 2) > 0)
	{
		SetEntPropFloat(client, Prop_Send, "m_flNextAttack", GetGameTime());
		ClientCommand(client, "lastinv");
		CreateTimer(0.01, LastInv_Timer, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:LastInv_Timer(Handle:timer, any:client)
{
	if (IsClientInGame(client)) ClientCommand(client, "lastinv");
	return Plugin_Stop;
}