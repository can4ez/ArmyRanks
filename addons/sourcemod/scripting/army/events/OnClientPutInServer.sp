public OnClientPutInServer(iClient)
{
	if ( iClient && IsFakeClient(iClient) || IsClientSourceTV(iClient) )
	{
		return;
	}
	decl String:sQuery[256];
	#if SOURCEMOD_V_MINOR >= 7
		GetClientAuthId(iClient, AuthId_Steam2, g_sAuth[iClient], sizeof(g_sAuth[]));
	#endif
	#if SOURCEMOD_V_MINOR < 7
		GetClientAuthString(iClient, g_sAuth[iClient], sizeof(g_sAuth[]));
	#endif
	Format(sQuery, sizeof(sQuery), "SELECT `kills`, `deaths`,`irank` FROM `army_ranks` WHERE `auth` = '%s' LIMIT 1;", g_sAuth[iClient]);
	SQL_TQuery(g_hSQLdb, SQLT_OnClientPutInServer, sQuery, GetClientUserId(iClient));
}

public SQLT_OnClientPutInServer(Handle:hOwner, Handle:hQuery, const String:sError[], any:iUserId)
{
	new iClient = GetClientOfUserId(iUserId);
	if ( !iClient )
	{
		return;
	}
	
	if ( !hQuery )
	{
		LogError("SQLT_OnClientPutInServer: %s", sError);
		g_bLoaded[iClient] = false;
	}

	decl String:sBuffer[255],String:sName[32], String:sName2[32];
	GetClientName(iClient, sName, sizeof(sName));
	if ( SQL_FetchRow(hQuery) )
	{
		
		// if(g_iRankType==0)
		// {
			g_iKills[iClient] 	= SQL_FetchInt(hQuery, 0);
			g_iDeaths[iClient]  	= SQL_FetchInt(hQuery, 1);
		// }
		// else if(g_iRankType==1)
		// {
			// new stats[STATS_NAMES];
			// RankMe_GetStats(iClient,stats);
			// g_iKills[iClient] 	= stats[KILLS];
			// g_iDeaths[iClient] = stats[DEATHS];
		// }

		g_iRank[iClient] 	= SQL_FetchInt(hQuery, 2);
		
		g_bLoaded[iClient] 	= true;
	}
	else
	{
		decl String:sQuery[256];
		SQL_EscapeString(g_hSQLdb, sName, sName2, sizeof(sName2));
		Format(sQuery, sizeof(sQuery), "INSERT INTO `army_ranks` (`auth`, `name`, `kills`, `deaths`,`irank`) VALUES ('%s', '%s', 0, 0, 0)", g_sAuth[iClient], sName2);
		SQL_TQuery(g_hSQLdb, SQLT_OnInsertClient, sQuery, GetClientUserId(iClient));
		// if(g_iRankType==0)
		// {
			g_iKills[iClient] 	= 0;
			g_iDeaths[iClient] 	= 0;
			g_iRank[iClient]		= 0;
		// }
		// else if(g_iRankType==1)
		// {
			// new stats[STATS_NAMES];
			// RankMe_GetStats(iClient,stats);
			// g_iKills[iClient] = stats[KILLS];
			// g_iDeaths[iClient] = stats[DEATHS];
		// }
	}
	if(g_iRank[iClient] < GetArraySize(g_hArray_iKills))
		GetArrayString(g_hArray_sRanks, g_iRank[iClient], g_sRank[iClient], sizeof(g_sRank[]));
	else 
		GetArrayString(g_hArray_sRanks, g_iRank[iClient]-1, g_sRank[iClient], sizeof(g_sRank[]));
	if(g_iRank[iClient] < GetArraySize(g_hArray_iKills)-1)	
		g_iNextRankKills[iClient] = GetArrayCell(g_hArray_iKills, g_iRank[iClient]+1);
		
	/*Начало приветствия*/
	KvRewind(hKv);
	if(KvGetNum(hKv,"Welcome",1)!=0)
	{
		new Handle:hWelcomePanel = CreatePanel();
				
		Format(sBuffer, sizeof(sBuffer), "%T\n ","welcome_title",iClient);
		SetPanelTitle(hWelcomePanel,sBuffer);
		
		Format(sBuffer, sizeof(sBuffer), "%T","welcome_menu",iClient,sName,g_sRank[iClient],g_iKills[iClient],g_iDeaths[iClient]);
				
		iParts = ReplaceString(sBuffer, sizeof(sBuffer), "\\n", "\n-");
		if(iParts > 0)
		{
			decl String:sParts[iParts+1][1000], i;
			iParts = ExplodeString(sBuffer, "\n-", sParts, iParts+1, 1000);
			for(i = 0; i < iParts; ++i)
			{
				DrawPanelText(hWelcomePanel,sParts[i]);
			}
		}
		else 
		{
			DrawPanelText(hWelcomePanel, sBuffer);
		}
		DrawPanelText(hWelcomePanel, "");
		SetPanelCurrentKey(hWelcomePanel, 10);
		DrawPanelItem(hWelcomePanel, "Выход");
		SendPanelToClient(hWelcomePanel, iClient, Handle_WelcomePanel, 	g_WelcomePanelTime);
		CloseHandle(hWelcomePanel);
		/*Конец кода приветствия*/
	}
	g_hArrayInfoMenu[iClient] = CreateTrie();
	
	ClearTrie(g_hArrayInfoMenu[iClient]);
	Call_StartForward(OnPlayerConnect);
	Call_PushCell(iClient);
	Call_PushString(g_sRank[iClient]);
	Call_PushCell(g_iKills[iClient]);
	Call_PushCell(g_iDeaths[iClient]);
	Call_Finish();
}

public SQLT_OnInsertClient(Handle:hOwner, Handle:hQuery, const String:sError[], any:iUserId)
{
	new iClient = GetClientOfUserId(iUserId);
	if ( !iClient )
	{
		return;
	}
	
	if ( !hQuery )
	{
		LogError("SQLT_OnInsertClient: %s", sError);
		g_bLoaded[iClient] = false;
	}
	g_iTotalPlayers++;
	g_bLoaded[iClient] = true;
}

public Handle_WelcomePanel(Handle:hMenu, MenuAction:action, iClient, iSlot)
{
}