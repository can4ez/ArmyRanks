public OnConfigsExecuted()
{
	decl String:sBuffer[256];
	if ( SQL_CheckConfig("army_ranks") )
	{
		SQL_TConnect(SQLT_OnConnect, "army_ranks");
	}
	else
	{
		PrintToServer("warning: section 'army_ranks' in databases.cfg not presented");
		g_hSQLdb = SQLite_UseDatabase("army_ranks", sBuffer, sizeof(sBuffer));
		CreateTables();
	}
	
	BuildPath(Path_SM, sBuffer, sizeof(sBuffer), "configs/army/army_ranks.txt");
	hKv = CreateKeyValues("army_ranks");
	if ( !FileToKeyValues(hKv, sBuffer) || !KvGotoFirstSubKey(hKv) )
	{
		LogError("file '%s' empty or not found", sBuffer);
		SetFailState("file '%s' empty or not found", sBuffer);
	}
	
	
	if(g_hArray_sRanks!=INVALID_HANDLE)
	{
		ClearArray(g_hArray_sRanks);
		g_hArray_sRanks = INVALID_HANDLE;
		g_hArray_sRanks = CreateArray(64);
	}
	if(g_hArray_iKills!=INVALID_HANDLE)
	{
		ClearArray(g_hArray_iKills);
		g_hArray_iKills = INVALID_HANDLE;
		g_hArray_iKills = CreateArray();
	}
	decl iBuffer;
	do
	{
		KvGetSectionName(hKv, sBuffer, sizeof(sBuffer));
		PushArrayString(g_hArray_sRanks, sBuffer);
		iBuffer = KvGetNum(hKv, "kills");
		PushArrayCell(g_hArray_iKills, iBuffer);
	} while ( KvGotoNextKey(hKv) );
	g_iTotalRanks = GetArraySize(g_hArray_iKills);
	
	// KvRewind(hKv);
	// g_iRankType = KvGetNum(hKv,"Rank_Type",0); // 0 - Использовать данные из своей базы | 1 - RankMe | 2 - GameMe
	
	KvRewind(hKv);
	g_bAdminPanel = bool:KvGetNum(hKv, "sm_admin", 0);
	LogMessage("g_bAdminPanel: %d | %d",g_bAdminPanel,KvGetNum(hKv, "sm_admin", 0));
		
	g_bAdminPanel2 = bool:KvGetNum(hKv, "sm_army", 0);
	
	if(KvGetNum(hKv,"LogEnadled",0)) g_bLogs = true;
	else g_bLogs = false;
	
	if(KvGetNum(hKv,"Welcome",0)) g_bWelcomePanel = true;
	else g_bWelcomePanel = false;

	
	if(g_bLogs)
		CreateDir("addons/sourcemod/logs/army_ranks/");
		
		
	KvRewind(hKv);
	KvGetString(hKv,"Command_army",sBuffer,sizeof(sBuffer),"sm_army");
	RegConsoleCmd(sBuffer, 	Command_Army);
	
	KvRewind(hKv);
	KvGetString(hKv,"Command_top",sBuffer,sizeof(sBuffer),"atop");
	RegConsoleCmd(sBuffer, 	Command_Top);
	strcopy(g_sTopCommand,sizeof(g_sTopCommand),sBuffer);
	// g_sTopCommand[0] = sBuffer[0];
	
	KvRewind(hKv);
	KvGetString(hKv,"Command_admin",sBuffer,sizeof(sBuffer),"sm_armyadmin");
	RegAdminCmd(sBuffer, ArmyAdmin, ADMFLAG_ROOT);
	
	KvRewind(hKv);
	g_LockTeam = KvGetNum(hKv,"lock_team",0);

	KvRewind(hKv);
	g_WelcomePanelTime = KvGetNum(hKv,"Welcome_Panel_Time",0);
	
	OpenSortMenuFile();
}

public SQLT_OnConnect(Handle:hOwner, Handle:hQuery, const String:sError[], any:nol)
{
	if ( !hQuery )
	{
		LogError("SQLT_OnConnect: %s", sError);
		SetFailState("SQLT_OnConnect: %s", sError);
	}
	
	g_hSQLdb = hQuery;
	CreateTables();
}

CreateTables()
{
	SQL_LockDatabase(g_hSQLdb);
	SQL_FastQuery(g_hSQLdb, "CREATE TABLE IF NOT EXISTS `army_ranks` (`auth` TEXT(32), `name` TEXT(32), `kills` INT, `deaths` INT, `irank` INT);");
	SQL_UnlockDatabase(g_hSQLdb);
	
	g_iTotalPlayers = 0;
	//decl String:sQuery[256];
	//Format(sQuery, sizeof(sQuery), "SELECT COUNT(*) FROM `army_ranks`");
	SQL_TQuery(g_hSQLdb, SQLT_OnGetTotal, "SELECT COUNT(*) FROM `army_ranks`");
	
	for ( new i = 1; i <= MaxClients; ++i )
	{
		if ( IsClientInGame(i) )
		{
			OnClientPutInServer(i);
		}
	}
}

public SQLT_OnGetTotal(Handle:hOwner, Handle:hQuery, const String:sError[], any:nol)
{
	if ( !hQuery )
	{
		LogError("SQLT_OnGetTotal: %s", sError);
		SetFailState("SQLT_OnGetTotal: %s", sError);
	}
	
	if ( SQL_FetchRow(hQuery) )
	{
		g_iTotalPlayers = SQL_FetchInt(hQuery, 0);
	}
}
OpenSortMenuFile()
{	
	decl String:sItemInfo[256];
	new Handle:hFile = OpenFile("addons/sourcemod/configs/army/Sort_Menu.ini", "r");
	if (hFile)
	{
		ClearArray(g_hArraySortMenu);
		while (!IsEndOfFile(hFile) && ReadFileLine(hFile, sItemInfo, 256))
		{
			TrimString(sItemInfo);
			if(sItemInfo[0]!='\0')
			{
				if(sItemInfo[0]!='/'&& sItemInfo[1]!='/')PushArrayString(g_hArraySortMenu,sItemInfo);
			}
		}
		CloseHandle(hFile);
	}	
}