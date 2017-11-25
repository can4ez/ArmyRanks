#include <army_ranks>
#include <basecomm>

#define MORE_COLORS
#if defined MORE_COLORS
 #include <morecolors>
#else
 #include <colors>
#endif

new	String: PrefixColor[MAXPLAYERS+1][20],
	String: NameColor[MAXPLAYERS+1][20],
	String: TextColor[MAXPLAYERS+1][20],
	String: DeathColor[MAXPLAYERS+1][20],
	String: SpecColor[MAXPLAYERS+1][20],
	String:	g_sRank[MAXPLAYERS+1][36],
	g_iLastSay[MAXPLAYERS+1];
	
public Plugin:myinfo = 
{
    name = "[ ARMY ] Чат/Chat",
    author = "sahapro33",
    description = "",
    version = "1.1 BaseComm"
}

public OnPluginStart()
{	
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say_Team, "say_team");
	AddCommandListener(CommandBack, "jointeam");
}
public Action:CommandBack(client, const String:command[], args) GetChatColor(client);
public ARMY_PlayerSpawn(client) GetChatColor(client);
public ARMY_ArmyUp(client) GetChatColor(client);
public OnClientPutInServer(client) g_iLastSay[client] = 0;

public Action:Command_Say_Team(client, const String:command[], argc)
{
	if ( 0 < client <= MaxClients && IsClientInGame(client) && !BaseComm_IsClientGagged(client))
	{
		new iTime = GetTime();
		if ( g_iLastSay[client] > iTime )
		{
			return Plugin_Handled;
		}
		g_iLastSay[client] = iTime +2;
		decl String:sName[64], String:sMessage[256];
		GetClientName(client, sName, sizeof(sName) - 1);
		GetCmdArgString(sMessage, sizeof(sMessage) - 1);
		StripQuotes(sMessage);
		if(!Army_GetStringRank(client,g_sRank[client])) SetFailState("Error");
		
		Format(sMessage, 500, "{green}(Team) {slategrey}[%s%s{slategrey}] %s%s{default}: %s%s",PrefixColor[client],g_sRank[client],NameColor[client],sName,TextColor[client],sMessage);
		
		for (new i = 1; i<MaxClients; i++)
		{
			if (IsClientInGame(i)&&GetClientTeam(client)==GetClientTeam(i))
			{
				CPrintToChatEx(i,client,sMessage);
			}
		}
		return Plugin_Handled;
	}
	return Plugin_Continue;
}
public Action:Command_Say(client, const String:command[], argc)
{
	if (0 < client <= MaxClients && IsClientInGame(client) && !BaseComm_IsClientGagged(client))
	{
		new iTime = GetTime();
		if ( g_iLastSay[client] > iTime )
		{
			return Plugin_Handled;
		}
		decl String:sName[64], String:sMessage[500];
		GetClientName(client, sName, sizeof(sName) - 1);
		GetCmdArgString(sMessage, sizeof(sMessage) - 1);
		StripQuotes(sMessage);
		if(!Army_GetStringRank(client,g_sRank[client])) SetFailState("Error");
		if ( IsPlayerAlive(client) )
		{			
			Format(sMessage, 500, "{slategrey}[%s%s{slategrey}] %s%s{default}: %s%s",PrefixColor[client],g_sRank[client],NameColor[client],sName,TextColor[client],sMessage);
			CPrintToChatAllEx(client,sMessage);
		}
		else
		{
			if ( GetClientTeam(client) > 1  )
			{
				Format(sMessage, 500, "%s*УБИТ* {slategrey}[%s%s{slategrey}] %s%s{default}: %s%s",DeathColor[client],PrefixColor[client],g_sRank[client],NameColor[client],sName,TextColor[client],sMessage);
				CPrintToChatAllEx(client,sMessage);
			}
			else
			{
				Format(sMessage, 500, "%s*СПЕК* {slategrey}[%s%s{slategrey}] %s%s{default}: %s%s",SpecColor[client],PrefixColor[client],g_sRank[client],NameColor[client],sName,TextColor[client],sMessage);
				CPrintToChatAllEx(client,sMessage);		
			}
		}
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

GetChatColor(client)
{
	if(!Army_GetStringAtributes(client,"PrefixColor","{green}",PrefixColor[client]))SetFailState("Error");
	if(!Army_GetStringAtributes(client,"NameColor","{teamcolor}",NameColor[client]))SetFailState("Error");
	if(!Army_GetStringAtributes(client,"TextColor","{default}",TextColor[client]))SetFailState("Error");
	if(!Army_GetStringAtributes(client,"DeathColor","{default}",DeathColor[client]))SetFailState("Error");
	if(!Army_GetStringAtributes(client,"SpecColor","{default}",SpecColor[client]))SetFailState("Error");
}