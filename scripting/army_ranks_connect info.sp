#include <army_ranks>
#include <morecolors>

public Plugin:myinfo = 
{
    name = "[ ARMY ] Connect Info",
    author = "sahapro33",
    description = "",
    version = "1.2"
}
public OnPluginStart()
{
	HookEvent("player_connect",	player_connect,	EventHookMode_Pre);
	HookEvent("player_disconnect",	player_disconnect,	EventHookMode_Pre);
}
public Action:player_connect(Handle:event, const String:name[], bool:silent)
{
	return Plugin_Handled;
}

public Action:player_disconnect(Handle:event, const String:name[], bool:silent)
{
	return Plugin_Handled;
} 

public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	new String:Color[MAXPLAYERS+1];
	Army_GetStringAtributes(client,"PrefixColor","{green}",Color[client]);
	CPrintToChatAllEx(client,"{lime}[+] {gold}%N {default}со званием {slategrey}[%s%s{slategrey}] {default}подключается{lightskyblue}!",client,Color[client],g_sRank/*,Color[client]*/);
}

public ARMY_PlayerDisconnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	new String:Color[MAXPLAYERS+1];
	Army_GetStringAtributes(client,"PrefixColor","{green}",Color[client]);
	if(IsClientInGame(client)) CPrintToChatAllEx(client,"{fullred}[-] {gold}%N {default}со званием {slategrey}[%s%s{slategrey}] {default}отключился{lightskyblue}!",client,Color[client],g_sRank/*,Color[client]*/);
}
