#include <army_ranks>

new Handle:Hud[MAXPLAYERS + 1] = INVALID_HANDLE;
new String:sRank[MAXPLAYERS + 1][256];
new String:sNextRank[MAXPLAYERS + 1][256];
new Kills[MAXPLAYERS + 1] = -1;
new Deaths[MAXPLAYERS + 1] = -1;
new NextRankKills[MAXPLAYERS + 1] = -1;

public Plugin:myinfo = 
{
	name = "[ ARMY ] Hud info", 
	author = "sahapro33", 
	description = "", 
	version = "1.1"
}
public OnPluginStart()
{
	RegConsoleCmd("sm_hud", cmd);
}
new bool:b_e[66];
public Action:cmd(cl, argcc)
{
	b_e[cl] = !b_e[cl];
	return Plugin_Handled;
}
public ARMY_PlayerConnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (IsClientInGame(client) && !IsFakeClient(client))
	{
		if (Hud[client] == INVALID_HANDLE)
		{
			Hud[client] = CreateTimer(1.0, HudStart, client, TIMER_REPEAT);
		}
	}
}
public ARMY_PlayerDisconnect(client, g_sRank[], g_iKills[], g_iDeaths[])
{
	if (Hud[client] != INVALID_HANDLE)
	{
		KillTimer(Hud[client]);
		Hud[client] = INVALID_HANDLE;
	}
	sRank[client] = "";
	Kills[client] = -1;
	Deaths[client] = -1;
	sNextRank[client] = "";
	NextRankKills[client] = -1;
}

public Action:HudStart(Handle:timer, any:client)
{
	if (b_e[client] && IsClientInGame(client) && !IsFakeClient(client))
	{
		if (IsPlayerAlive(client))
		{
			decl String:Message[256];
			
			if (!Army_GetStringRank(client, sRank[client]))
			{
				return Plugin_Stop;
			}
			if ((Kills[client] = Army_GetClientKills(client)) == -1)return Plugin_Stop;
			if ((Deaths[client] = Army_GetClientDeaths(client)) == -1)return Plugin_Stop;
			NextRankKills[client] = Army_GetClientNextRankKills(client);
			new Handle:hBuffer = StartMessageOne("KeyHintText", client);
			BfWriteByte(hBuffer, 1);
			if (Army_GetClientStringNextRank(client, sNextRank[client], sizeof(sNextRank[])))
			{
				Format(Message, sizeof(Message), "Ваше звание - %s\n\nУбийств -  %d \nСмертей -  %d \n\nСледующее звание - %s\nТребуется убийств -  %d ", 
					sRank[client], 
					Kills[client], 
					Deaths[client], 
					sNextRank[client], 
					NextRankKills[client] - Kills[client]);
				BfWriteString(hBuffer, Message);
				EndMessage();
			}
			else
			{
				Format(Message, sizeof(Message), "Ваше звание - %s\n\nУбийств -  %d\nСмертей -  %d\n\nУбрать с экрана sm_hud", 
					sRank[client], 
					Kills[client], 
					Deaths[client]);
				BfWriteString(hBuffer, Message);
				EndMessage();
			}
		}
	}
	else return Plugin_Stop;
	return Plugin_Continue;
} 