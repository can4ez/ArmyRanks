#include <army_ranks>
#include <cstrike>

new	String: ClanTag[MAXPLAYERS+1];

public Plugin:myinfo = 
{
    name = "[ ARMY ] КланТэг/ClanTag",
    author = "sahapro33",
    description = "",
    version = "1.1"
}

public OnPluginStart()
{	
	AddCommandListener(CommandBack, "jointeam");
	LoadTranslations("army_ranks/modules.phrases.txt");
}

public Action:CommandBack(client, const String:command[], args) SetClanTag(client);
public ARMY_PlayerSpawn(client) SetClanTag(client);
public ARMY_ArmyUp(client)
{
	if(Army_GetStringAtributes(client,"ClanTag","",ClanTag[client])&&ClanTag[client])
	{
		decl String:Buffer[50];
		FormatEx(Buffer,sizeof(Buffer),"%t: %s","TAG",ClanTag[client]);
		Army_RegisterItem(client,"ClanTag",Buffer);
		SetClanTag(client);
	}
}

SetClanTag(client)
{
	if(Army_GetStringAtributes(client,"ClanTag","",ClanTag[client]))CS_SetClientClanTag(client,ClanTag[client]);
}

public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	if(Army_GetStringAtributes(client,"ClanTag","",ClanTag[client])&&ClanTag[client])
	{
		decl String:Buffer[50];
		FormatEx(Buffer,sizeof(Buffer),"%t: %s","TAG",ClanTag[client]);
		Army_RegisterItem(client,"ClanTag",Buffer);
	}
}
