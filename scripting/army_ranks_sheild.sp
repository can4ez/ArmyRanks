#include <army_ranks>
#include <sdkhooks>

new Float:fSheild[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
	name = "[ ARMY ]  Изменение урона/amage Change", 
	author = "sahapro33", 
	description = "", 
	version = "1.4"
}

new bool:g_bActive = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
	g_bActive = (Army_GetMapSettings("Sheild") == 1);
}

public ARMY_PlayerDisconnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	SDKUnhook(client, SDKHook_OnTakeDamage, SDKHookCB:OnTakeDamage);
}
public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	SDKHook(client, SDKHook_OnTakeDamage, SDKHookCB:OnTakeDamage);
	if (!g_bActive)return;
	decl String:Buffer[100];
	fSheild[client] = Army_GetFloatAtributes(client, "Sheild", "1.0");
	if (fSheild[client] < 1.0)
	{
		FormatEx(Buffer, sizeof(Buffer), "%t: %0.1f", "SHEILD", fSheild[client]);
		Army_RegisterItem(client, "Sheild", Buffer);
	}
}
public ARMY_ArmyUp(client)
{
	if (!g_bActive)return;
	decl String:Buffer[100];
	fSheild[client] = Army_GetFloatAtributes(client, "Sheild", "1.0");
	if (fSheild[client] < 1.0)
	{
		FormatEx(Buffer, sizeof(Buffer), "%t: %0.1f", "SHEILD", fSheild[client]);
		Army_RegisterItem(client, "Sheild", Buffer);
	}
}
public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype, &weapon, Float:damageForce[3], Float:damagePosition[3], damagecustom)
{
	if (g_bActive && victim && attacker)
	{
		if (fSheild[victim] < 1.0 && victim != attacker && GetClientTeam(victim) != GetClientTeam(attacker))
		{
			damage = damage * fSheild[victim];
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
} 