#include <army_ranks>
#include <sdktools>

#define HE 	 0
#define FLASH 	 1
#define SMOKE 	 2

new iHe[MAXPLAYERS + 1], iFlash[MAXPLAYERS + 1], iSmoke[MAXPLAYERS + 1];
new String:Buffer[100];

public Plugin:myinfo = 
{
	name = "[ ARMY ] Гранаты/Grenade", 
	author = "sahapro33", 
	description = "", 
	version = "1.4"
}

new bool:g_bActive_He = false;
new bool:g_bActive_Flash = false;
new bool:g_bActive_Smoke = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
}
public OnMapStart()
{
	g_bActive_He = (Army_GetMapSettings("He") == 1);
	g_bActive_Flash = (Army_GetMapSettings("Flash") == 1);
	g_bActive_Smoke = (Army_GetMapSettings("Smoke") == 1);
}

bool:GetGrenade(client, id = 3)
{
	switch (id)
	{
		case 0:
		{
			if (!g_bActive_He)return false;
			iHe[client] = Army_GetNumAtributes(client, "He", 0);
			if (iHe[client] > 0)return true;
		}
		case 1:
		{
			if (!g_bActive_Flash)return false;
			iFlash[client] = Army_GetNumAtributes(client, "Flash", 0);
			if (iFlash[client] > 0)return true;
		}
		case 2:
		{
			if (!g_bActive_Smoke)return false;
			iSmoke[client] = Army_GetNumAtributes(client, "Smoke", 0);
			if (iSmoke[client] > 0)return true;
		}
	}
	return false;
}
public ARMY_PlayerSpawn(client)
{
	if (GetGrenade(client, HE))
	{
		GivePlayerItem(client, "weapon_hegrenade");
		SetEntProp(client, Prop_Send, "m_iAmmo", iHe[client], 4, 11);
	}
	if (GetGrenade(client, FLASH))
	{
		GivePlayerItem(client, "weapon_flashbang");
		SetEntProp(client, Prop_Send, "m_iAmmo", iFlash[client], 4, 12);
	}
	if (GetGrenade(client, SMOKE))
	{
		GivePlayerItem(client, "weapon_smokegrenade");
		SetEntProp(client, Prop_Send, "m_iAmmo", iSmoke[client], 4, 13);
	}
}
public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (GetGrenade(client, HE))
	{
		// FormatEx(Buffer,sizeof(Buffer),"Осколочная: %d",iHe[client]);
		FormatEx(Buffer, sizeof(Buffer), "%t: %d", "HE", iHe[client]);
		Army_RegisterItem(client, "He", Buffer);
	}
	if (GetGrenade(client, FLASH))
	{
		FormatEx(Buffer, sizeof(Buffer), "%t: %d", "FLASH", iFlash[client]);
		Army_RegisterItem(client, "Flash", Buffer);
	}
	if (GetGrenade(client, SMOKE))
	{
		FormatEx(Buffer, sizeof(Buffer), "%t: %d", "SMOKE", iSmoke[client]);
		Army_RegisterItem(client, "Smoke", Buffer);
	}
}
public ARMY_ArmyUp(client)
{
	if (GetGrenade(client, HE))
	{
		// FormatEx(Buffer,sizeof(Buffer),"Осколочная: %d",iHe[client]);
		FormatEx(Buffer, sizeof(Buffer), "%t: %d", "HE", iHe[client]);
		Army_RegisterItem(client, "He", Buffer);
	}
	if (GetGrenade(client, FLASH))
	{
		FormatEx(Buffer, sizeof(Buffer), "%t: %d", "FLASH", iFlash[client]);
		Army_RegisterItem(client, "Flash", Buffer);
	}
	if (GetGrenade(client, SMOKE))
	{
		FormatEx(Buffer, sizeof(Buffer), "%t: %d", "SMOKE", iSmoke[client]);
		Army_RegisterItem(client, "Smoke", Buffer);
	}
} 