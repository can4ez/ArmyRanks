new Handle: hKv,
	Handle:	g_hMainMenu,
	Handle:	g_hSQLdb,
	Handle:	g_hArray_sRanks,
	Handle:	g_hArray_iKills,
	Handle: g_RankInfoPanel,
	
	Handle: OnArmyLoad,
	
	Handle: OnPlayerConnect,
	Handle: OnPlayerDisconnect,
	
	Handle: OnPlayerArmyUp,
	Handle: OnPlayerSpawn,
	Handle: OnPlayerDeath,
	
	Handle: OnCreateRankInfo,
	Handle: OnPressItemInRankInfo,
	
	Handle: g_hArrayInfoMenu[MAXPLAYERS+1],
	Handle: g_hArraySortMenu,

	String:	g_sAuth[MAXPLAYERS+1][32],
	String:	g_sRank[MAXPLAYERS+1][36],
	bool:	g_bLoaded[MAXPLAYERS+1],
	
	bool:	g_bLogs = false,
			g_WelcomePanelTime = 5,
	 		g_iKills[MAXPLAYERS+1],
			g_iDeaths[MAXPLAYERS+1],
			g_iRank[MAXPLAYERS+1],
			g_iNextRankKills[MAXPLAYERS+1],
			g_iTemp[MAXPLAYERS+1],
			g_iTotalRanks,
			g_iTotalPlayers,
			iParts,
	String:	g_sTopCommand[] = "atop",
			g_LockTeam = 0,
			g_iTopType/*,
			g_iRankType = 0*/;