public OnAllPluginsLoaded()
{
	CreateAdminMenu();
	Call_StartForward(OnArmyLoad); 
	Call_Finish();
}

public OnPluginStart()
{
	Format(PLUGIN_VERSION,sizeof(PLUGIN_VERSION),"%s%s",PLUGIN_VERSION,__DATE__);
	
	g_hArray_sRanks = CreateArray(ByteCountToCells(64));
	g_hArray_iKills = CreateArray();
	g_hArraySortMenu = CreateArray(ByteCountToCells(64));
	
	HookEvent("player_death", 	Ev_PlayerDeath);
	HookEvent("player_spawn", 	Ev_PlayerSpawn);
		
	RegAdminCmd("army_deaths", SetDeaths, ADMFLAG_ROOT);
	RegAdminCmd("army_kills", SetKills, ADMFLAG_ROOT);
	RegAdminCmd("army_setrank", Army_SetRank, ADMFLAG_ROOT);
	
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say_team");
	
	LoadTranslations("army_ranks/chat.phrases.txt");
	LoadTranslations("army_ranks/adminmenu.phrases.txt");
	LoadTranslations("army_ranks/menu.phrases.txt");
}

public Action:Command_Top(iClient, iArgc)
{
	if ( iClient )
	{
		g_iTemp[iClient] = 0;
		SendTopPanel(iClient);
	}
	else
	{
		PrintToServer("[ArmyR] client-side only");
	}
	
	return Plugin_Handled;
}

public Action:Command_Army(iClient, iArgc)
{
	if ( iClient )
	{
		decl String:sBuffer[256];
		if ( g_bLoaded[iClient] )
		{
			if(g_LockTeam != GetClientTeam(iClient) || g_LockTeam == 0)
			{
				new Handle:g_hMainMenu;
				g_hMainMenu = CreateMenu(Handle_MainMenu);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "main_menu_title",iClient);
				SetMenuTitle(g_hMainMenu, sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "my_rank_item",iClient);
				AddMenuItem(g_hMainMenu, "myrank", sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "next_rank_item",iClient);
				AddMenuItem(g_hMainMenu, "nextrank", sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "available_ranks_item",iClient);
				AddMenuItem(g_hMainMenu, "ranks", sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "top_item",iClient);
				AddMenuItem(g_hMainMenu, "top", 	sBuffer);
				
				Format(sBuffer, sizeof(sBuffer), "%T", "total_players_item",iClient);
				AddMenuItem(g_hMainMenu, "total", sBuffer);

				Format(sBuffer, sizeof(sBuffer), "%T", "reset_rank_item",iClient);
				AddMenuItem(g_hMainMenu, "reset", sBuffer);	

				if(g_bAdminPanel2 && CheckAdminAccess(iClient,ADMFLAG_ROOT))
				{
					Format(sBuffer, sizeof(sBuffer), "%T", "admin_menu_item",iClient);
					AddMenuItem(g_hMainMenu, "adminmenu", sBuffer);
				}
				
				DisplayMenu(g_hMainMenu, iClient, MENU_TIME_FOREVER);
			}
			else
			{
				Format(sBuffer, sizeof(sBuffer), "%T", "team_lock",iClient);
				Color_PrintToChatEx(iClient,iClient, sBuffer);
			}
		}
		else
		{
			Format(sBuffer, sizeof(sBuffer), "%T", "player_is_not_loaded",iClient);
			Color_PrintToChatEx(iClient,iClient, sBuffer);
		}
	}
	else
	{
		PrintToServer("[ArmyR] client-side only");
	}
	
	return Plugin_Handled;
}

// public Action:Command_Rank(iClient, iArgc)
// {
	// if ( iClient )
	// {
		// if ( g_bLoaded[iClient] )
		// {
			// decl String:sQuery[256];
			// KvRewind(hKv);
			// g_iRankType = KvGetNum(hKv,"RankType",1);
			// switch(g_iRankType)
			// {
				// case 0: Format(sQuery, sizeof(sQuery), "SELECT `kills` AS rankn FROM `army_ranks` WHERE (`kills` > 0 AND `deaths` > 0) AND `kills` < (SELECT `kills` FROM `army_ranks` WHERE auth = '%s' LIMIT 1) AND `auth` != '%s' ORDER BY rankn ASC", g_sAuth[iClient], g_sAuth[iClient]);
				// case 1: Format(sQuery, sizeof(sQuery), "SELECT `irank` AS rankn FROM `army_ranks` WHERE (`kills` > 0 AND `deaths` > 0) AND `irank` < (SELECT `irank` FROM `army_ranks` WHERE auth = '%s' LIMIT 1) AND `auth` != '%s' ORDER BY rankn ASC", g_sAuth[iClient], g_sAuth[iClient]);
				// case 2: Format(sQuery, sizeof(sQuery), "SELECT `auth`, `kills`, `deaths`,`irank` FROM `army_ranks` WHERE (`deaths` > 0) ORDER by (`kills`/`deaths`) DESC");
			// }
			// SQL_TQuery(g_hSQLdb, SQLT_ShowRank, sQuery, GetClientUserId(iClient));
		// }
		// else
		// {
			// decl String:sBuffer[256];
			// Format(sBuffer, sizeof(sBuffer), "%T", "player_is_not_loaded",iClient);
			// Color_PrintToChatEx(iClient,iClient, sBuffer);
		// }
	// }
	// else
	// {
		// PrintToServer("[ArmyR] client-side only");
	// }
	// return Plugin_Handled;
// }

// public SQLT_ShowRank(Handle:hOwner, Handle:hQuery, const String:sError[], any:iUserId)
// {
	// new iClient = GetClientOfUserId(iUserId);
	// if ( !iClient )
	// {
		// return;
	// }
	
	// if ( !hQuery )
	// {
		// LogError("SQLT_ShowRank: %s", sError);
	// }
	
	// if ( SQL_HasResultSet(hQuery) )
	// {
		// decl String:sBuffer[256];
		// Format(sBuffer, sizeof(sBuffer), "%T","show_rank1",iClient,g_sRank[iClient],SQL_GetRowCount(hQuery)+1,g_iTotalPlayers);
		// Color_PrintToChatEx(iClient,iClient, sBuffer);
		// Format(sBuffer, sizeof(sBuffer), "%T","show_rank2",iClient,g_iKills[iClient],g_iDeaths[iClient],g_iKills[iClient]);
		// Color_PrintToChatEx(iClient,iClient, sBuffer);
	// }
// }
MyRank(iClient)
{
	decl String:info[256];
	new Handle:hPanel = CreatePanel();
	Format(info, sizeof(info), "%T","my_rank_title",iClient);
	SetPanelTitle(hPanel, info);
	GetClientName(iClient, info, sizeof(info));

	Format(info, sizeof(info), "%T","my_rank_menu",iClient,info,g_sRank[iClient],g_iKills[iClient],g_iDeaths[iClient]);	

	iParts = ReplaceString(info, sizeof(info), "\\n", "\n-");
	if(iParts > 0)
	{
		decl String:sParts[iParts+1][1000], i;
		iParts = ExplodeString(info, "\n-", sParts, iParts+1, 1000);
		for(i = 0; i < iParts; ++i)
		{
			DrawPanelText(hPanel,sParts[i]);
		}
	}
	else 
	{
		DrawPanelText(hPanel, info);
	}
	Format(info, sizeof(info), "%T","feature_item",iClient);

	DrawPanelText(hPanel, "---------------------------");
	DrawPanelItem(hPanel, info);
	DrawPanelText(hPanel, "---------------------------\n\n");
	DrawPanelText(hPanel, " ");
	SetPanelCurrentKey(hPanel, 8);
	DrawPanelItem(hPanel, "Назад");
	DrawPanelText(hPanel, " ");
	SetPanelCurrentKey(hPanel, 10);
	DrawPanelItem(hPanel, "Выход");
	SendPanelToClient(hPanel, iClient, Handle_MyRankPanel, MENU_TIME_FOREVER);
	CloseHandle(hPanel);
}
public Handle_MainMenu(Handle:hMenu, MenuAction:action, iClient, iSlot)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			decl String:info[256];
			GetMenuItem(hMenu,iSlot,info,sizeof(info));
			SetGlobalTransTarget(iClient);
			if (StrEqual(info,"myrank"))
			{
				MyRank(iClient);
			}
			else if (StrEqual(info,"nextrank"))
			{
				decl String:sName[76];
				if(g_iRank[iClient] < GetArraySize(g_hArray_iKills)-1)
					GetArrayString(g_hArray_sRanks, g_iRank[iClient]+1, sName, sizeof(sName));
				new Handle:hPanel = CreatePanel();
				
				Format(info, sizeof(info), "%T","next_rank_title",iClient);
				SetPanelTitle(hPanel, info);
				
				if(g_iRank[iClient] < GetArraySize(g_hArray_iKills)-1)
					Format(info, sizeof(info), "%T","next_rank_menu",iClient,sName,g_iNextRankKills[iClient],g_iKills[iClient]);
				else
					Format(info, sizeof(info), "%T","next_rank_menu_max",iClient);
				
				iParts = ReplaceString(info, sizeof(info), "\\n", "\n-");
				if(iParts > 0)
				{
					decl String:sParts[iParts+1][1000], i;
					iParts = ExplodeString(info, "\n-", sParts, iParts+1, 1000);
					for(i = 0; i < iParts; ++i)
					{
						DrawPanelText(hPanel,sParts[i]);
					}
				}
				else 
				{
					DrawPanelText(hPanel, info);
				}
				SetPanelCurrentKey(hPanel, 8);
				DrawPanelItem(hPanel, "Назад");
				DrawPanelText(hPanel, " ");
				SetPanelCurrentKey(hPanel, 10);
				DrawPanelItem(hPanel, "Выход");
				SendPanelToClient(hPanel, iClient, Handle_BackToMainMenu, MENU_TIME_FOREVER);
				CloseHandle(hPanel);
			}
			
			else if (StrEqual(info,"top"))
			{
				g_iTemp[iClient] = 0;
				SendTopPanel(iClient);
			}
			
			else if (StrEqual(info,"ranks"))
			{
				decl String:Buffer[10];
				decl iBuffer;
				new Handle:g_hRanksMenu = CreateMenu(Handle_BackToMainMenu);
				Format(info, sizeof(info), "%T", "available_ranks_title",iClient);
				SetMenuTitle(g_hRanksMenu, info);
				SetMenuExitBackButton(g_hRanksMenu,true);
				
				//decl String:s_Buffer[2][256];
				
				for(new i=0;i<g_iTotalRanks;i++)
				{
					GetArrayString(g_hArray_sRanks,i,info,sizeof(info));
					iBuffer = GetArrayCell(g_hArray_iKills,i);
					if(StrEqual(info, g_sRank[iClient], true)) Format(info, sizeof(info), "%T","available_rank_use",iClient,info);
					else if(iBuffer<=g_iKills[iClient]) Format(info, sizeof(info), "%T","available_rank_achieved",iClient,info);
					else Format(info, sizeof(info), "%T","available_rank",iClient,info, iBuffer);
					IntToString(iBuffer,Buffer,sizeof(Buffer));
					AddMenuItem(g_hRanksMenu, Buffer, info,ITEMDRAW_DISABLED);
				}
				DisplayMenu(g_hRanksMenu, iClient, MENU_TIME_FOREVER);
			}			
			else if (StrEqual(info,"total"))
			{
				decl String:sQuery[256];
				Format(sQuery, sizeof(sQuery), "SELECT `name` FROM `army_ranks` LIMIT %d, 1", g_iTotalPlayers-1);
				SQL_TQuery(g_hSQLdb, SQLT_OnTotalDisplay, sQuery, GetClientUserId(iClient));
			}
			else if (StrEqual(info,"reset"))
			{
				new Handle:ResetMenu = CreateMenu(Handle_ResetMenu);
				Format(info, sizeof(info), "%T","reset_menu_title",iClient);
				SetMenuTitle(ResetMenu, info);
				Format(info, sizeof(info), "%T","yes",iClient);
				AddMenuItem(ResetMenu, "yes",info);
				Format(info, sizeof(info), "%T","no",iClient);
				AddMenuItem(ResetMenu, "no",info);
				DisplayMenu(ResetMenu, iClient, MENU_TIME_FOREVER);
			}
			else if (StrEqual(info,"adminmenu"))
			{
				ArmyAdmin(iClient,0);
			}
		}
		case MenuAction_End: CloseHandle(hMenu);
	}
}
public Handle_ResetMenu(Handle:hMenu, MenuAction:action, iClient, iSlot)
{
	if(action == MenuAction_Select)
	{
		if( iClient > 0)
		{
			decl String:info[4];
			GetMenuItem(hMenu,iSlot,info,sizeof(info));
			if(!strcmp(info,"yes",true))
			{ 
				g_iKills[iClient] = 0; 
				g_iDeaths[iClient] = 0;
				g_iRank[iClient] = 0;
				g_iNextRankKills[iClient] = GetArrayCell(g_hArray_iKills, g_iRank[iClient]+1);
				GetArrayString(g_hArray_sRanks, g_iRank[iClient], g_sRank[iClient], sizeof(g_sRank[]));
				
				if(g_hArrayInfoMenu[iClient] != INVALID_HANDLE){
					ClearTrie(g_hArrayInfoMenu[iClient]);
					CloseHandle(g_hArrayInfoMenu[iClient]);
				}
				g_hArrayInfoMenu[iClient] = INVALID_HANDLE;
				g_hArrayInfoMenu[iClient] = CreateTrie();

				Call_StartForward(OnPlayerArmyUp); 
				Call_PushCell(iClient);
				Call_PushString(g_sRank[iClient]);
				Call_PushCell(MODE_RANK_RESET);
				Call_Finish();
				
				decl String:buffer[256];
				Format(buffer, sizeof(buffer), "%T","player_reset",iClient);
				Color_PrintToChatEx(iClient,iClient, buffer);
				if(g_bLogs)LogToFile(LOG_RESETPLAYER,"Игрок %N обнулил звание",iClient);
				SaveClient(iClient); 
			}
			if(!strcmp(info,"no",true)) Command_Army(iClient, 0);
		}
	}
	if ( action == MenuAction_Cancel ) Command_Army(iClient, 0);
}
public SQLT_OnTotalDisplay(Handle:hOwner, Handle:hQuery, const String:sError[], any:iUserId)
{
	new iClient = GetClientOfUserId(iUserId);
	if ( !iClient )
	{
		return;
	}
	
	if ( !hQuery )
	{
		LogError("SQLT_OnTotalDisplay: %s", sError);
	}
	
	if ( SQL_FetchRow(hQuery) )
	{
		new Handle:hTopPanel = CreatePanel();
		decl String:sBuffer[256];
		Format(sBuffer, sizeof(sBuffer), "%T", "total_playes_title",iClient);
		SetPanelTitle(hTopPanel, sBuffer);
		
		SQL_FetchString(hQuery, 0, sBuffer, sizeof(sBuffer));
		Format(sBuffer, sizeof(sBuffer), "%T","total_players_menu",iClient,g_iTotalPlayers,sBuffer);
		
		iParts = ReplaceString(sBuffer, sizeof(sBuffer), "\\n", "\n-");
		if(iParts > 0)
		{
			decl String:sParts[iParts+1][1000], i;
			iParts = ExplodeString(sBuffer, "\n-", sParts, iParts+1, 1000);
			for(i = 0; i < iParts; ++i)
			{
				DrawPanelText(hTopPanel,sParts[i]);
			}
		}
		else 
		{
			DrawPanelText(hTopPanel, sBuffer);
		}
		SetPanelCurrentKey(hTopPanel, 8);
		DrawPanelItem(hTopPanel, "Назад");
		DrawPanelText(hTopPanel, " ");
		SetPanelCurrentKey(hTopPanel, 10);
		DrawPanelItem(hTopPanel, "Выход");
		SendPanelToClient(hTopPanel, iClient, Handle_BackToMainMenu, MENU_TIME_FOREVER);
		CloseHandle(hTopPanel);
	}
}

SendTopPanel(iClient)
{
	decl String:sQuery[256];
	KvRewind(hKv);
	g_iTopType = KvGetNum(hKv,"TopType",1);
	switch(g_iTopType)
	{
		case 0: Format(sQuery, sizeof(sQuery), "SELECT `name`, `kills`,`irank`,`deaths`,(kills/deaths) FROM `army_ranks` ORDER BY 2 DESC LIMIT %d, 7;", g_iTemp[iClient]*7);
		case 1: Format(sQuery, sizeof(sQuery), "SELECT `name`, `kills`,`irank`,`deaths`,(kills/deaths) FROM `army_ranks` ORDER BY 3 DESC LIMIT %d, 7;", g_iTemp[iClient]*7);
		case 2: Format(sQuery, sizeof(sQuery), "SELECT `name`, `kills`,`irank`,`deaths`,(kills/deaths) FROM `army_ranks` ORDER BY 5 DESC LIMIT %d, 7;", g_iTemp[iClient]*7);
	}	
	SQL_TQuery(g_hSQLdb, SQLT_OnTopDisplay, sQuery, GetClientUserId(iClient));
}

public SQLT_OnTopDisplay(Handle:hOwner, Handle:hQuery, const String:sError[], any:iUserId)
{
	new iClient = GetClientOfUserId(iUserId);
	if ( !iClient )
	{
		return;
	}
	
	if ( !hQuery )
	{
		LogError("SQLT_OnTopDisplay: %s", sError);
	}
	
	new Handle:hTopPanel = CreatePanel(), iCount = 0;
	
	decl String:sBuffer[256];
	decl String:Name[256];
	Format(sBuffer, sizeof(sBuffer), "%T", "top_title",iClient);
	SetPanelTitle(hTopPanel, sBuffer);
	
	decl String:sRank[32], iRank, iKills,iDeath,Float:KshareD;
	while ( SQL_FetchRow(hQuery) )
	{
		SQL_FetchString(hQuery, 0, Name, sizeof(Name));
		iKills = SQL_FetchInt(hQuery, 1);
		iRank  = SQL_FetchInt(hQuery, 2);
		iDeath  = SQL_FetchInt(hQuery, 3);
		KshareD  = SQL_FetchFloat(hQuery, 4);
		if(iRank < GetArraySize(g_hArray_iKills))
			GetArrayString(g_hArray_sRanks, iRank, sRank, sizeof(sRank));
		else
		{
			GetArrayString(g_hArray_sRanks, GetArraySize(g_hArray_sRanks)-1, sRank, sizeof(sRank));
		}
		Format(sBuffer, sizeof(sBuffer), "%T", "top_menu",iClient, g_iTemp[iClient]*7 + iCount + 1, Name, sRank, KshareD,iKills,iDeath);
		DrawPanelText(hTopPanel, sBuffer);
		
		iCount++;
	}
	DrawPanelText(hTopPanel, " ");
	SetPanelCurrentKey(hTopPanel, 8);
	DrawPanelItem(hTopPanel, "Назад");
	if(iCount>=7)
	{
		SetPanelCurrentKey(hTopPanel, 9);
		DrawPanelItem(hTopPanel, "Далее");
	}
	else DrawPanelText(hTopPanel, " ");
	SetPanelCurrentKey(hTopPanel, 10);
	DrawPanelItem(hTopPanel, "Выход");
	SendPanelToClient(hTopPanel,iClient,Handle_TopMenu,MENU_TIME_FOREVER);
	CloseHandle(hTopPanel);
}

public Handle_TopMenu(Handle:hMenu, MenuAction:action, iClient, iSlot)
{
	if(action == MenuAction_Select)
	{
		if ( iSlot == 8 )
		{
			if(g_iTemp[iClient]<=0)
			{
				Command_Army(iClient, 0); 
				g_iTemp[iClient] = 0;
				ClientCmd(iClient,"play buttons/combine_button7.wav");
			}
			else 
			{
				g_iTemp[iClient]--; 
				SendTopPanel(iClient);
				ClientCmd(iClient,"play buttons/combine_button7.wav");
			}
		}
		else if ( iSlot == 9 )
		{
			g_iTemp[iClient]++;
			SendTopPanel(iClient);
			ClientCmd(iClient,"play buttons/combine_button7.wav");
		}
		else if ( iSlot == 10 )
		{
			ClientCmd(iClient,"play buttons/combine_button7.wav");
		}
	}
}

public Handle_MyRankPanel(Handle:hMenu, MenuAction:action, iClient, iSlot)
{
	if(action == MenuAction_Select)
	{
		ClientCmd(iClient,"play buttons/button14.wav");
		if ( iSlot == 1 )
		{
			if(g_hArraySortMenu == INVALID_HANDLE){if(g_bLogs)LogToFile("addons/sourcemod/logs/Army_Core.log","g_hArraySortMenu = INVALID_HANDLE"); return;}
			if(g_hArrayInfoMenu[iClient] == INVALID_HANDLE){if(g_bLogs)LogToFile("addons/sourcemod/logs/Army_Core.log","g_hArrayInfoMenu[%N] == INVALID_HANDLE",iClient);return;}
			// if(g_RankInfoPanel != INVALID_HANDLE){if(g_bLogs)LogToFile("addons/sourcemod/logs/Army_Core.log","g_RankInfoPanel != INVALID_HANDLE");return;}
			
			new ASM_Size = GetArraySize(g_hArraySortMenu);
			decl String:buffer[256];
			new Handle:RankInfoPanel = CreatePanel();
			new count = 0;
			for(new i = 0; i < ASM_Size; i++)
			{
				if(GetArrayString(g_hArraySortMenu,i,buffer,256))
				{
					TrimString(buffer);
					if(GetTrieString(g_hArrayInfoMenu[iClient],buffer,buffer,256))
					{
						DrawPanelText(RankInfoPanel,buffer);
						count++;
					}
				}
			}
			Format(buffer,sizeof(buffer),"%T","no_feature_item",iClient);
			if(count == 0)DrawPanelText(RankInfoPanel,buffer);
			decl String:sBuffer[256];
			Format(sBuffer, sizeof(sBuffer), ".:: Функции звания ::.\n-----------------------------------\n\n");

			SetPanelTitle(RankInfoPanel, sBuffer);
					
			Call_StartForward(OnCreateRankInfo); 
			Call_PushCell(iClient); 
			Call_PushCell(RankInfoPanel); 
			Call_Finish();
			
			DrawPanelText(RankInfoPanel,"-----------------------------------");
			DrawPanelText(RankInfoPanel," ");
			SetPanelCurrentKey(RankInfoPanel, 8);
			DrawPanelItem(RankInfoPanel, "Назад");
			DrawPanelText(RankInfoPanel, " ");
			SetPanelCurrentKey(RankInfoPanel, 10);
			DrawPanelItem(RankInfoPanel, "Выход");
			
			SendPanelToClient(RankInfoPanel, iClient, Handle_RankInfo, MENU_TIME_FOREVER);		
			CloseHandle(RankInfoPanel);
			RankInfoPanel = INVALID_HANDLE;
		}
		else if ( iSlot == 8 )
		{
			Command_Army(iClient, 0);
			ClientCmd(iClient,"play buttons/combine_button7.wav");
		}
		else if ( action == MenuAction_Cancel && iSlot == MenuCancel_ExitBack )
		{
			Command_Army(iClient, 0);
			ClientCmd(iClient,"play buttons/combine_button7.wav");
		}
	}
	//else CloseHandle(hMenu);
}

public Handle_RankInfo(Handle:hMenu, MenuAction:action, iClient, iSlot)
{
	if ( iSlot == 8 ){
		MyRank(iClient); 
		ClientCmd(iClient,"play buttons/combine_button7.wav");}
	else
	{
		ClientCmd(iClient,"play buttons/combine_button7.wav");
		Call_StartForward(OnPressItemInRankInfo); 
		Call_PushCell(iClient); 
		Call_PushCell(iSlot); 
		Call_Finish();
	}
}

public Handle_BackToMainMenu(Handle:hMenu, MenuAction:action, iClient, iSlot)
{
	if ( iSlot == 8 ) Command_Army(iClient, 0);ClientCmd(iClient,"play buttons/combine_button7.wav");
	if ( action == MenuAction_Cancel )
	{
		if ( iSlot == MenuCancel_ExitBack )
		{
			Command_Army(iClient, 0);ClientCmd(iClient,"play buttons/combine_button7.wav");
		}
		else ClientCmd(iClient,"play buttons/combine_button7.wav");
	}
}

public Ev_PlayerDeath(Handle:hEvent, const String:sEvName[], bool:bDontBroadcast)
{	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	new iAttker = GetClientOfUserId(GetEventInt(hEvent, "attacker"));
	if(!iClient || !iAttker) return;
	
	new Cteam	=	GetClientTeam(iClient),
		Ateam	=	GetClientTeam(iAttker);
		
	//new bool:headshot = GetEventBool(hEvent, "headshot");
	// if( g_LockTeam == 0 || g_LockTeam == Cteam )
	// if( g_LockTeam == 0 || g_LockTeam == Ateam )

	// PrintToChatAll("Lock: %d | CTeam: %d | ATeam: %d",g_LockTeam,Cteam,Ateam);
	if ( iClient && iAttker && iClient != iAttker && Cteam != Ateam)
	{
		if( g_LockTeam == 0 || g_LockTeam != Cteam )
		{
			g_iDeaths[iClient]++;
			SaveClient(iClient);
		}
		if(g_LockTeam == 0 || g_LockTeam != Ateam)
		{
			g_iKills[iAttker] += 1;
			SaveClient(iAttker);
			if ( g_iKills[iAttker] >= g_iNextRankKills[iAttker] && g_iRank[iAttker]<g_iTotalRanks)
			{
				++g_iRank[iAttker];
				if ( g_iRank[iClient] == g_iTotalRanks )
				{
					g_iRank[iClient] -= 1;
				}
			}
			if(g_iRank[iAttker]<g_iTotalRanks)
			{
				decl String:sBuffer[256];
				Format(sBuffer, sizeof(sBuffer), "%s",g_sRank[iAttker]);
			
				GetArrayString(g_hArray_sRanks, g_iRank[iAttker], g_sRank[iAttker], sizeof(g_sRank[]));
					
				if(!StrEqual(sBuffer[0],g_sRank[iAttker],true))
				{
					g_iNextRankKills[iAttker] = GetArrayCell(g_hArray_iKills, g_iRank[iAttker]+1);
					if(!IsFakeClient(iAttker))
					{
						Format(sBuffer, sizeof(sBuffer), "%T","rank_up",iAttker,g_sRank[iAttker]);
						Color_PrintToChatEx(iAttker, iAttker,sBuffer);
						if(g_hArrayInfoMenu[iAttker]!=INVALID_HANDLE)
						{
							// if(IsValidHandle(g_hArrayInfoMenu[iAttker])) 
							ClearTrie(g_hArrayInfoMenu[iAttker]);
							CloseHandle(g_hArrayInfoMenu[iAttker]);
							g_hArrayInfoMenu[iAttker] = INVALID_HANDLE;
							g_hArrayInfoMenu[iAttker] = CreateTrie();
						}
						else g_hArrayInfoMenu[iAttker] = CreateTrie();
						Call_StartForward(OnPlayerArmyUp); 
						Call_PushCell(iAttker);
						Call_PushString(g_sRank[iAttker]);
						Call_PushCell(MODE_RANK_UP);
						Call_Finish();
						if(g_bLogs)LogToFile(LOG_RANK_PLAYER_UP,"Игрок %N получил новый ранг [%s]",iAttker,g_sRank[iAttker]);
					}
				}
			}
		}
	}
	
	Call_StartForward(OnPlayerDeath); 
	Call_PushCell(iClient); 
	Call_PushCell(iAttker); 
	Call_Finish();
}

public Action:Command_Say(client, const String:command[], argc)
{
	if (0 < client <= MaxClients && IsClientInGame(client) )
	{
		decl String:sMessage[500];
		GetCmdArgString(sMessage, sizeof(sMessage) - 1);
		StripQuotes(sMessage);
		
		// if ( StrEqual(sMessage, "rank") )
		// {
			// Command_Rank(client, 0);
			// return Plugin_Handled;
		// }
		// else 
		if ( StrEqual(sMessage, g_sTopCommand) )
		{
			Command_Top(client, 0);
			return Plugin_Handled;
		}
	}
	
	return Plugin_Continue;
}

public Ev_PlayerSpawn(Handle:hEvent, const String:sEvName[], bool:bDontBroadcast)
{
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if ( iClient && g_bLoaded[iClient] )
	{
		
		decl String:sBuffer[256];
		decl String:sNextRank[32*2];
		new count = g_iNextRankKills[iClient] - g_iKills[iClient];
		
		if(g_iRank[iClient] < GetArraySize(g_hArray_iKills)-1)
		{
			GetArrayString(g_hArray_sRanks, g_iRank[iClient]+1, sNextRank, sizeof(sNextRank));
			FormatEx(sBuffer, sizeof(sBuffer), "%T","round_start_msg",iClient,count, sNextRank);
			Color_PrintToChatEx(iClient,iClient,sBuffer);
		}
		else{
			FormatEx(sBuffer, sizeof(sBuffer), "%T","round_start_msg_player_full",iClient,g_sRank[iClient]);
			Color_PrintToChatEx(iClient,iClient,sBuffer);
		}

		Call_StartForward(OnPlayerSpawn); 
		Call_PushCell(iClient); 
		Call_Finish();
	}
}
/*
SendInfoRankPanel(iClient)
{
	if(g_hArraySortMenu == INVALID_HANDLE)
	{
		if(g_bLogs)LogToFile("addons/sourcemod/logs/Army_Core.log","g_hArraySortMenu = INVALID_HANDLE"); 
		return;
	}
	if(g_hArrayInfoMenu[iClient] == INVALID_HANDLE)
	{
		if(g_bLogs)LogToFile("addons/sourcemod/logs/Army_Core.log","g_hArrayInfoMenu[%N] == INVALID_HANDLE",iClient); 
		return;
	}
	if(g_RankInfoPanel != INVALID_HANDLE)
	{
		if(g_bLogs)LogToFile("addons/sourcemod/logs/Army_Core.log","g_RankInfoPanel != INVALID_HANDLE"); 
		return;
	}
	new ASM_Size = GetArraySize(g_hArraySortMenu);
	decl String:buffer[256];
	g_RankInfoPanel = CreatePanel();
	new count = 0;
	for(new i = 0; i < ASM_Size; i++)
	{
		if(GetArrayString(g_hArraySortMenu,i,buffer,256))
		{
			TrimString(buffer);
			if(GetTrieString(g_hArrayInfoMenu[iClient],buffer,buffer,256))
			{
				DrawPanelText(g_RankInfoPanel,buffer);
				count++;
			}
		}
	}
	Format(buffer,sizeof(buffer),"%T","no_feature_item",iClient);
	if(count == 0)DrawPanelText(g_RankInfoPanel,buffer);
	
}
*/
ClientCmd(client,const String:dir[])
{
	if(0 < client <= MaxClients && IsClientInGame(client)) ClientCommand(client,dir);
}