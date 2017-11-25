#include <army_ranks>

new iHp[MAXPLAYERS+1];

public Plugin:myinfo = 
{
    name = "[ ARMY ] Здоровье/Health",
    author = "sahapro33",
    description = "",
    version = "1.3"
}
public ARMY_OnLoad() LoadTranslations("army_ranks/modules.phrases.txt");
public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	if((iHp[client]=Army_GetNumAtributes(client,"Hp",100))>0&&iHp[client]!=100)
	{
		decl String:Buffer[100];
		FormatEx(Buffer,sizeof(Buffer),"%t: %d","HP",iHp[client]);
		Army_RegisterItem(client,"Hp",Buffer);
	}
}

public ARMY_ArmyUp(client)
{
	if((iHp[client]=Army_GetNumAtributes(client,"Hp",100))>0&&iHp[client]!=100)
	{
		decl String:Buffer[100];
		FormatEx(Buffer,sizeof(Buffer),"%t: %d","HP",iHp[client]);
		Army_RegisterItem(client,"Hp",Buffer);
	}
}

public ARMY_PlayerSpawn(client)
{
	if((iHp[client]=Army_GetNumAtributes(client,"Hp",100))>0&&iHp[client]!=100) SetEntityHealth(client,iHp[client]);
}