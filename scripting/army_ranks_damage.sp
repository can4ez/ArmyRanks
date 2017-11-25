#include <army_ranks>
#include <sdkhooks>

new Float:fDmg[MAXPLAYERS+1];

public Plugin:myinfo = 
{
    name = "[ ARMY ]  Изменение урона/amage Change",
    author = "sahapro33",
    description = "",
    version = "1.3"
}
public ARMY_OnLoad() LoadTranslations("army_ranks/modules.phrases.txt");

public ARMY_PlayerDisconnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	SDKUnhook(client, SDKHook_OnTakeDamage, SDKHookCB:OnTakeDamage);
}
public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	decl String:Buffer[100];
	fDmg[client] = Army_GetFloatAtributes(client,"Dmg","1.0");
	if(fDmg[client]>1.0)
	{
		FormatEx(Buffer,sizeof(Buffer),"%t: %0.1f","DMG",fDmg[client]);
		Army_RegisterItem(client,"Dmg",Buffer);
	}
	SDKHook(client, SDKHook_OnTakeDamage, SDKHookCB:OnTakeDamage);
}
public ARMY_ArmyUp(client)
{
	decl String:Buffer[100];
	fDmg[client] = Army_GetFloatAtributes(client,"Dmg","1.0");
	if(fDmg[client]>1.0)
	{
		FormatEx(Buffer,sizeof(Buffer),"%t: %0.1f","DMG",fDmg[client]);
		Army_RegisterItem(client,"Dmg",Buffer);
	}
}
public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype, &weapon,	Float:damageForce[3], Float:damagePosition[3], damagecustom)
{
	if(victim&&attacker)
	{
		if(fDmg[attacker]>1.0&&victim!=attacker && GetClientTeam(victim)!=GetClientTeam(attacker))
		{
			damage = damage*fDmg[attacker];
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}