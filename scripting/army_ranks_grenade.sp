#include <army_ranks>
#include <sdktools>

#define HE 	 0
#define FLASH 	 1
#define SMOKE 	 2

new iHe[MAXPLAYERS+1],iFlash[MAXPLAYERS+1],iSmoke[MAXPLAYERS+1];
new String:Buffer[100];

public Plugin:myinfo = 
{
    name = "[ ARMY ] Гранаты/Grenade",
    author = "sahapro33",
    description = "",
    version = "1.3"
}
public ARMY_OnLoad() LoadTranslations("army_ranks/modules.phrases.txt");

bool:GetGrenade(client,id=3)
{
	switch ( id )
	{
		case 0:
		{
			iHe[client] = Army_GetNumAtributes(client,"He",0); 
			if(iHe[client]>0) return true;
		}
		case 1: 
		{
			iFlash[client] = Army_GetNumAtributes(client,"Flash",0); 
			if(iFlash[client]>0) return true;
		}
		case 2: 
		{
			iSmoke[client] = Army_GetNumAtributes(client,"Smoke",0);
			if(iSmoke[client]>0) return true;
		}
	}
	return false;
}
public ARMY_PlayerSpawn(client)
{	
	if(GetGrenade(client,HE))
	{
		GivePlayerItem(client, "weapon_hegrenade");
		SetEntProp(client, Prop_Send, "m_iAmmo", iHe[client], 4, 11);
	}
	if(GetGrenade(client,FLASH))
	{
		GivePlayerItem(client, "weapon_flashbang");
		SetEntProp(client, Prop_Send, "m_iAmmo", iFlash[client], 4, 12);
	}
	if(GetGrenade(client,SMOKE))
	{
		GivePlayerItem(client, "weapon_smokegrenade");
		SetEntProp(client, Prop_Send, "m_iAmmo", iSmoke[client], 4, 13);
	}
}
public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	if(GetGrenade(client,HE))
	{
		// FormatEx(Buffer,sizeof(Buffer),"Осколочная: %d",iHe[client]);
		FormatEx(Buffer,sizeof(Buffer),"%t: %d","HE",iHe[client]);
		Army_RegisterItem(client,"He",Buffer);
	}
	if(GetGrenade(client,FLASH))
	{
		FormatEx(Buffer,sizeof(Buffer),"%t: %d","FLASH",iFlash[client]);
		Army_RegisterItem(client,"Flash",Buffer);
	}
	if(GetGrenade(client,SMOKE))
	{
		FormatEx(Buffer,sizeof(Buffer),"%t: %d","SMOKE",iSmoke[client]);
		Army_RegisterItem(client,"Smoke",Buffer);
	}
}
public ARMY_ArmyUp(client)
{
	if(GetGrenade(client,HE))
	{
		// FormatEx(Buffer,sizeof(Buffer),"Осколочная: %d",iHe[client]);
		FormatEx(Buffer,sizeof(Buffer),"%t: %d","HE",iHe[client]);
		Army_RegisterItem(client,"He",Buffer);
	}
	if(GetGrenade(client,FLASH))
	{
		FormatEx(Buffer,sizeof(Buffer),"%t: %d","FLASH",iFlash[client]);
		Army_RegisterItem(client,"Flash",Buffer);
	}
	if(GetGrenade(client,SMOKE))
	{
		FormatEx(Buffer,sizeof(Buffer),"%t: %d","SMOKE",iSmoke[client]);
		Army_RegisterItem(client,"Smoke",Buffer);
	}
}