public OnClientDisconnect(iClient)
{
	Call_StartForward(OnPlayerDisconnect);
	Call_PushCell(iClient);
	Call_PushString(g_sRank[iClient]);
	Call_PushCell(g_iKills[iClient]);
	Call_PushCell(g_iDeaths[iClient]);
	Call_Finish();
	if ( g_bLoaded[iClient] )
	{
		SaveClient(iClient);
		g_bLoaded[iClient] = false;
	}
}

SaveClient(iClient)
{
	if ( g_bLoaded[iClient] )
	{
		decl String:sQuery[256], String:sName[MAX_NAME_LENGTH*2+1];
		GetClientName(iClient, sQuery, sizeof(sQuery));
		SQL_EscapeString(g_hSQLdb, sQuery, sName, sizeof(sName));
		Format(sQuery, sizeof(sQuery), "UPDATE `army_ranks` SET `kills` = %d, `deaths` = %d, `name` = '%s', `irank` = '%d' WHERE `auth` = '%s'", g_iKills[iClient], g_iDeaths[iClient], sName, (g_iRank[iClient]< GetArraySize(g_hArray_iKills))?g_iRank[iClient]:g_iRank[iClient]-1, g_sAuth[iClient]);
		SQL_TQuery(g_hSQLdb, SQLT_OnClientDisconnect, sQuery);
	}
}

public SQLT_OnClientDisconnect(Handle:hOwner, Handle:hQuery, const String:sError[], any:iUserId)
{
	if ( !hQuery )
	{
		LogError("SQLT_OnClientDisconnect: %s", sError);
	}
}
