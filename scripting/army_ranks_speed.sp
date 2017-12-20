#include <army_ranks>

new Float:fSpeed[MAXPLAYERS+1];

public Plugin:myinfo = 
{
    name = "[ ARMY ] Скорость/Speed",
    author = "sahapro33",
    description = "",
    version = "1.4"
}

new bool:g_bActive = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
}
public OnMapStart()
{
	g_bActive = (Army_GetMapSettings("Speed") == 1);
}
public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	if(g_bActive && (fSpeed[client]=Army_GetFloatAtributes(client,"Speed","1.0"))>0.0 && fSpeed[client]!=1.0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer,sizeof(Buffer),"%t: %0.1f","SPEED", fSpeed[client]);
		Army_RegisterItem(client,"Speed",Buffer);
	}
}

public ARMY_PlayerSpawn(client)
{
	if (!g_bActive)return;
	if((fSpeed[client]=Army_GetFloatAtributes(client,"Speed","1.0"))>0.0&&fSpeed[client]!=1.0) SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", fSpeed[client]);
	else SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
}

public ARMY_ArmyUp(client)
{
	if (!g_bActive)return;
	if((fSpeed[client]=Army_GetFloatAtributes(client,"Speed","1.0"))>0.0&&fSpeed[client]!=1.0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer,sizeof(Buffer),"%t: %0.1f","SPEED", fSpeed[client]);
		Army_RegisterItem(client,"Speed",Buffer);
	}
}