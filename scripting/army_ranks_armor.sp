#include <army_ranks>
#include <sdktools_functions>

new iArmor[MAXPLAYERS+1];

public Plugin:myinfo = 
{
    name = "[ ARMY ] Броня/Armor",
    author = "sahapro33",
    description = "",
    version = "1.4"
}

new bool:g_bActive = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
	g_bActive = (Army_GetMapSettings("Armor") == 1);
}
public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	if(g_bActive && (iArmor[client] = Army_GetNumAtributes(client,"Armor",-1)) > 0)
	{
		decl String:Buffer[100];
		// FormatEx(Buffer,sizeof(Buffer),"Броня+Шлем: %d",iArmor[client]);
		FormatEx(Buffer,sizeof(Buffer),"%T: %d","ARMOR",client,iArmor[client]);
		Army_RegisterItem(client,"Armor",Buffer);
	}
}

public ARMY_ArmyUp(client)
{
	if(g_bActive && (iArmor[client] = Army_GetNumAtributes(client,"Armor",-1)) > 0)
	{
		decl String:Buffer[100];
		// FormatEx(Buffer,sizeof(Buffer),"Броня+Шлем: %d",iArmor[client]);
		FormatEx(Buffer,sizeof(Buffer),"%T: %d","ARMOR",client,iArmor[client]);
		Army_RegisterItem(client,"Armor",Buffer);
	}
}

public ARMY_PlayerSpawn(client)
{
	if(g_bActive && (iArmor[client]=Army_GetNumAtributes(client,"Armor",0))>0)
	{
		GivePlayerItem(client,"item_assaultsuit");
		SetEntProp(client, Prop_Data, "m_ArmorValue", iArmor[client]);
	}
}