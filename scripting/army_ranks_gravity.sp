#include <army_ranks>

new Float:fGravity[MAXPLAYERS+1];

public Plugin:myinfo = 
{
    name = "[ ARMY ] Гравитация/Gravity",
    author = "sahapro33",
    description = "",
    version = "1.3"
}
public ARMY_OnLoad() LoadTranslations("army_ranks/modules.phrases.txt");

public ARMY_ArmyUp(client)
{
	if((fGravity[client]=Army_GetFloatAtributes(client,"Gravity","1.0"))>0.0&&fGravity[client]!=1.0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer,sizeof(Buffer),"%t: %0.1f","GRAVITY",fGravity[client]);
		Army_RegisterItem(client,"Gravity",Buffer);
	}
}
public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	if((fGravity[client]=Army_GetFloatAtributes(client,"Gravity","1.0"))>0.0&&fGravity[client]!=1.0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer,sizeof(Buffer),"%t: %0.1f","GRAVITY",fGravity[client]);
		Army_RegisterItem(client,"Gravity",Buffer);
	}
}

public ARMY_PlayerSpawn(client)
{
	if((fGravity[client]=Army_GetFloatAtributes(client,"Gravity","1.0"))>0.0&&fGravity[client]!=1.0) SetEntityGravity(client,fGravity[client]);
	else SetEntityGravity(client,1.0);
}