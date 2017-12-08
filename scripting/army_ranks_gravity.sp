#include <army_ranks>

new Float:fGravity[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
	name = "[ ARMY ] Гравитация/Gravity", 
	author = "sahapro33", 
	description = "", 
	version = "1.4"
}

new bool:g_bActive = false;
public ARMY_OnLoad()
{
	LoadTranslations("army_ranks/modules.phrases.txt");
	g_bActive = (Army_GetMapSettings("Gravity") == 1);
}
public ARMY_ArmyUp(client)
{
	if (g_bActive && (fGravity[client] = Army_GetFloatAtributes(client, "Gravity", "1.0")) > 0.0 && fGravity[client] != 1.0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer, sizeof(Buffer), "%t: %0.1f", "GRAVITY", fGravity[client]);
		Army_RegisterItem(client, "Gravity", Buffer);
	}
}
public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (g_bActive && (fGravity[client] = Army_GetFloatAtributes(client, "Gravity", "1.0")) > 0.0 && fGravity[client] != 1.0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer, sizeof(Buffer), "%t: %0.1f", "GRAVITY", fGravity[client]);
		Army_RegisterItem(client, "Gravity", Buffer);
	}
}

public ARMY_PlayerSpawn(client)
{
	if (!g_bActive)return;
	
	if ((fGravity[client] = Army_GetFloatAtributes(client, "Gravity", "1.0")) > 0.0 && fGravity[client] != 1.0)SetEntityGravity(client, fGravity[client]);
	else SetEntityGravity(client, 1.0);
} 