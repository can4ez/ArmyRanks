#include <army_ranks>
#include <scp>
#include <basecomm>

new	String: PrefixColor[MAXPLAYERS+1][32],
	String: NameColor[MAXPLAYERS+1][32],
	String: TextColor[MAXPLAYERS+1][32],
	String:	g_sRank[MAXPLAYERS+1][32];
	
public Plugin:myinfo = 
{
    name = "[ ARMY ] Chat (Simple Chat Processor)",
    author = "KOROVKA",
    description = "",
    version = "1.1 BaseComm"
}

public OnPluginStart()
{
	if(FindPluginByFile("simple-chatprocessor.smx") == INVALID_HANDLE)
	{
		LogError("Simple Chat Processor isn't installed or failed to load. (http://forums.alliedmods.net/showthread.php?t=198501)");
		return;
	}
	
	AddCommandListener(CommandBack, "jointeam");
}

public Action:CommandBack(client, const String:command[], args) GetChatColor(client);
public ARMY_PlayerSpawn(client) GetChatColor(client);
public ARMY_ArmyUp(client) GetChatColor(client);

GetChatColor(client)
{
	if(!Army_GetStringAtributes(client, "PrefixColor", "", PrefixColor[client])) SetFailState("Error");
	if(!Army_GetStringAtributes(client, "NameColor", "", NameColor[client])) SetFailState("Error");
	if(!Army_GetStringAtributes(client, "TextColor", "", TextColor[client])) SetFailState("Error");
}

public Action:OnChatMessage(&client, Handle:recipients, String:name[], String:message[])
{
	if(!BaseComm_IsClientGagged(client))
	{
		if(!Army_GetStringRank(client, g_sRank[client])) SetFailState("Error");
		Format(name, MAXLENGTH_NAME, "%s%s[%s] %s%s%s", (strlen(PrefixColor[client]) > 1) ? "\x07":"\x01", PrefixColor[client], g_sRank[client], (strlen(NameColor[client]) > 1) ? "\x07":"\x01", NameColor[client], name);
		Format(message, MAXLENGTH_MESSAGE, "%s%s%s", (strlen(TextColor[client]) > 1) ? "\x07":"\x01",  TextColor[client], message);
		return Plugin_Handled;		
	}
	return Plugin_Changed;
}