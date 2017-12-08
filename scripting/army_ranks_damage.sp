#include <army_ranks>
#include <sdkhooks>

new Float:fDmg[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
	name = "[ ARMY ]  Изменение урона/Damage Change", 
	author = "sahapro33", 
	description = "", 
	version = "1.4"
}

new bool:g_bActive = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
	g_bActive = (Army_GetMapSettings("Dmg") == 1);
}

public ARMY_PlayerDisconnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (!g_bActive)return;
	SDKUnhook(client, SDKHook_OnTakeDamage, SDKHookCB:OnTakeDamage);
}
public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (!g_bActive)return;
	decl String:Buffer[100];
	fDmg[client] = Army_GetFloatAtributes(client, "Dmg", "1.0");
	if (fDmg[client] > 1.0)
	{
		FormatEx(Buffer, sizeof(Buffer), "%t: %0.1f", "DMG", fDmg[client]);
		Army_RegisterItem(client, "Dmg", Buffer);
	}
	SDKHook(client, SDKHook_OnTakeDamage, SDKHookCB:OnTakeDamage);
}
public ARMY_ArmyUp(client)
{
	if (!g_bActive)return;
	decl String:Buffer[100];
	fDmg[client] = Army_GetFloatAtributes(client, "Dmg", "1.0");
	if (fDmg[client] > 1.0)
	{
		FormatEx(Buffer, sizeof(Buffer), "%t: %0.1f", "DMG", fDmg[client]);
		Army_RegisterItem(client, "Dmg", Buffer);
	}
}
public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype, &weapon, Float:damageForce[3], Float:damagePosition[3], damagecustom)
{
	if (!g_bActive)return Plugin_Continue;
	if (victim && attacker)
	{
		if (fDmg[attacker] > 1.0 && victim != attacker && GetClientTeam(victim) != GetClientTeam(attacker))
		{
			damage = damage * fDmg[attacker];
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
} 