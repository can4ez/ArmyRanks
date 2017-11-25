public Action:ArmyAdmin(client,arg)
{
	decl String:buffer[256], Handle:g_RanksMenu;
	SetGlobalTransTarget(client);
	g_RanksMenu = CreateMenu(Handle_ArmyAdmin);
	//Format(buffer, sizeof(buffer), "%t", "admin_menu_title");
	SetMenuTitle(g_RanksMenu, "%t", "admin_menu_title");
	
	Format(buffer, sizeof(buffer), "%t", "set_rank_item");
	AddMenuItem(g_RanksMenu, "setrank", buffer);
	
	Format(buffer, sizeof(buffer), "%t", "set_kills_item");
	AddMenuItem(g_RanksMenu, "kills", buffer);
	
	Format(buffer, sizeof(buffer), "%t", "set_deaths_item");
	AddMenuItem(g_RanksMenu, "death", buffer);

	Format(buffer, sizeof(buffer), "%t", "reset_player_item");
	AddMenuItem(g_RanksMenu, "ResetPlayer", buffer);

	DisplayMenu(g_RanksMenu, client, MENU_TIME_FOREVER);
	return Plugin_Handled;
}
public Handle_ArmyAdmin(Handle:hMenu, MenuAction:action, client, param2)
{
	if(action == MenuAction_Select)
	{
		decl String:info[256];
		GetMenuItem(hMenu,param2,info,sizeof(info));
		
		switch(param2)
		{
			case 0: Army_SetRank(client,0);
			case 1: Army_Death(client);
			case 2: Army_Kill(client);
			case 3: Army_Reset(client);
		}
	}
}
Army_Reset(client)
{
	new Handle:menu = CreateMenu(Handle_ResetM); 
	SetMenuExitBackButton(menu,true);
	SetMenuTitle(menu, "Выберите Игрока:\n \n"); 
	decl String:userid[24], String:name[MAX_NAME_LENGTH]; 
	for (new i = 1; i <= MaxClients; i++) 
	{ 
		if (IsClientInGame(i)) 
		{ 
			GetClientName(i, name, 32);
			IntToString(i,userid,sizeof(userid));
			AddMenuItem(menu, userid, name); 
		} 
	} 
	DisplayMenu(menu, client, 0); 
}
public Handle_ResetM(Handle:hMenu, MenuAction:action, client, iSlot)
{
	if(action == MenuAction_Select)
	{
		decl String:info[10];
		decl String:buffer[26];
		GetMenuItem(hMenu,iSlot,info,sizeof(info));
		if(StringToInt(info)>0)
		{
			new Handle:ResetMenu = CreateMenu(Reset);
			new target = StringToInt(info);
			
			SetMenuTitle(ResetMenu, "%T","reset_player_title",client,target);
			
			Format(buffer, sizeof(buffer), "%T","yes",client);
			//Format(buffer, sizeof(buffer),"%d", target);
			AddMenuItem(ResetMenu, info,buffer);
			
			Format(info, sizeof(info), "%T","no",client);
			AddMenuItem(ResetMenu, info,info);
			
			DisplayMenu(ResetMenu, client, MENU_TIME_FOREVER);
		}
	}
	if ( action == MenuAction_Cancel )
	{
		if ( iSlot == MenuCancel_ExitBack )
		{
			ArmyAdmin(client,0);
		}
	}
}
public Reset(Handle:hMenu, MenuAction:action, client, iSlot)
{
	if(action == MenuAction_Select)
	{
		decl String:buffer[256];
		GetMenuItem(hMenu,iSlot,buffer[0],sizeof(buffer[]));
		//ExplodeString(buffer[0],"|",buffer,3,100);
		if(iSlot==0)
		{ 
			new target = StringToInt(buffer);			
			g_iKills[target] = 0; 
			g_iDeaths[target] = 0;
			g_iRank[target] = 0;
			g_iNextRankKills[target] = GetArrayCell(g_hArray_iKills, g_iRank[target]+1);
			GetArrayString(g_hArray_sRanks, g_iRank[target], g_sRank[target], sizeof(g_sRank[]));
				
			if(!(g_hArrayInfoMenu[target] == INVALID_HANDLE))ClearTrie(g_hArrayInfoMenu[target]);
			g_hArrayInfoMenu[target] = INVALID_HANDLE;
			g_hArrayInfoMenu[target] = CreateTrie();

			Call_StartForward(OnPlayerArmyUp); 
			Call_PushCell(target);
			Call_PushString(g_sRank[target]);
			Call_PushCell(MODE_RANK_RESET);
			Call_Finish();

			//decl String:buffer[256];
			Format(buffer, sizeof(buffer), "%T","player_reset_admin",target,client);
			CPrintToChatEx(target,target, buffer);
			Format(buffer, sizeof(buffer), "%T","player_is_reset",client,target);
			CPrintToChatEx(client,client, buffer);
			SaveClient(target); 
			ArmyAdmin(client,0);
			if(g_bLogs)LogToFile(LOG_ADMIN_RESETPLAYER,"Админ %N обнулил игрока %N",client,target);
		}
		else if(iSlot==1) Army_Reset(client);
	}
}
public Action:Army_SetRank(client,arg)
{
	decl String:sBuffer[256];
	//Format(sBuffer, sizeof(sBuffer), "%T\n", "available_ranks_title",client);
	decl String:Buffer[15];
	//decl iBuffer;
	new Handle:g_RanksMenu = CreateMenu(Handle_ArmySetRank);
	SetMenuExitBackButton(g_RanksMenu,true);
	SetMenuTitle(g_RanksMenu, "%T\n", "available_ranks_title",client);
	new i=0;
	for(i=0;i<g_iTotalRanks;i++)
	{
		GetArrayString(g_hArray_sRanks,i,sBuffer,sizeof(sBuffer));
		//iBuffer = GetArrayCell(g_hArray_iKills,i);
		Format(sBuffer, sizeof(sBuffer), "[%s]",sBuffer);
		FormatEx(Buffer,sizeof(Buffer), "%d",i/*,iBuffer*/);
		AddMenuItem(g_RanksMenu, Buffer, sBuffer);
	}
	DisplayMenu(g_RanksMenu, client, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public Handle_ArmySetRank(Handle:hMenu, MenuAction:action, client, param2)
{
	if(action == MenuAction_Select)
	{
		new String:info[25];
		GetMenuItem(hMenu,param2,info,sizeof(info));

		new Handle:menu = CreateMenu(HandleArmySetRank); 
		SetMenuExitBackButton(menu,true);
		SetMenuTitle(menu, "Выберите Игрока:\n \n"); 
		decl String:userid[24], String:name[MAX_NAME_LENGTH]; 
		for (new i = 1; i <= MaxClients; i++) 
		{ 
			if (IsClientInGame(i)) 
			{ 
				//IntToString(GetClientUserId(i), userid, 15); 
				Format(userid, sizeof(userid), "%d|%s",GetClientUserId(i),info);
				GetClientName(i, name, 32); 
				AddMenuItem(menu, userid, name); 
			} 
		} 
		DisplayMenu(menu, client, 0); 
	}
	else if ( action == MenuAction_Cancel )
	{
		if ( param2 == MenuCancel_ExitBack )
		{
			ArmyAdmin(client,0);
		}
	}
}
public HandleArmySetRank(Handle:hMenu, MenuAction:action, client, param2)
{
	if ( action == MenuAction_Cancel )
	{
		if ( param2 == MenuCancel_ExitBack )
		{
			Army_SetRank(client,0);
		}
	}
	if (action == MenuAction_End) 
	{ 
		CloseHandle(hMenu); 
		return; 
	} 
	if (action != MenuAction_Select) return; 
	decl String:info[2][25]; 
	GetMenuItem(hMenu, param2, info[0], 15); 
	ExplodeString(info[0],"|",info,2,25);
	new target = GetClientOfUserId(StringToInt(info[0])); 
	if (target > 0) 
	{ 
		g_iRank[target] = (GetArraySize(g_hArray_sRanks)==StringToInt(info[1]))?GetArraySize(g_hArray_sRanks)-1:StringToInt(info[1]);
		if(g_iRank[target] < GetArraySize(g_hArray_iKills)-1) g_iNextRankKills[target] = GetArrayCell(g_hArray_iKills, g_iRank[target]+1);
		GetArrayString(g_hArray_sRanks, g_iRank[target], g_sRank[target], sizeof(g_sRank[]));
		CPrintToChatEx(client,client, "{green}[{teamcolor}-ARMY-{green}] {default}Игроку {green}%N{default}, установлен звание {green}[%s]{default}!",target,g_sRank[target]); 
		if(target!=client)CPrintToChatEx(target, target, "{green}[{teamcolor}-ARMY-{green}] {default}Админ {green}%N{default}, установил вам звание {green}[%s]{default}!",client,g_sRank[target]); 
		SaveClient(target);
		ClearTrie(g_hArrayInfoMenu[target]);
		
		Call_StartForward(OnPlayerArmyUp); 
		Call_PushCell(target);
		Call_PushString(g_sRank[target]);
		Call_PushCell(MODE_RANK_UP);
		Call_Finish();
		if(g_bLogs)LogToFile(LOG_ADMIN_SET_RANK,"Админ %N устновил игроку %N звание [%s]",client,target,g_sRank[target]);
	} 
	else CPrintToChatEx(client,client, "Игрок не найден (вышел с сервера)");
	ArmyAdmin(client,0);
}


public Army_Death(client)
{
	// decl String:sBuffer[256];
	// Format(sBuffer, sizeof(sBuffer), "%T\n\n", "AdminMenu Death Title",client);
	new Handle:menu = CreateMenu(Handle_ArmyDeath);
	SetMenuTitle(menu, "%T\n\n", "admin_menu_death_title",client);
	SetMenuExitBackButton(menu,true);
	AddMenuItem(menu, "+1000", "+1000",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "+100", "+100",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "+10", "+10",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "0", "0",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "-10", "-10",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "-100", "-100",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "-1000", "-1000",ITEMDRAW_DEFAULT);

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public Handle_ArmyDeath(Handle:hMenu, MenuAction:action, client, param2)
{
	if(action == MenuAction_Select)
	{
		new String:info[25];
		GetMenuItem(hMenu,param2,info,sizeof(info));
		
		new Handle:menu = CreateMenu(SetDeath); 
		SetMenuExitBackButton(menu,true);
		SetMenuTitle(menu, "Выберите Игрока:\n \n"); 
		decl String:userid[24], String:name[MAX_NAME_LENGTH]; 
		for (new i = 1; i <= MaxClients; i++) 
		{ 
			if (IsClientInGame(i)) 
			{ 
				//IntToString(GetClientUserId(i), userid, 15); 
				Format(userid, sizeof(userid), "%d|%s",GetClientUserId(i),info);
				GetClientName(i, name, 32); 
				AddMenuItem(menu, userid, name); 
			} 
		} 
		DisplayMenu(menu, client, 0); 
	}
	else if ( action == MenuAction_Cancel )
	{
		if ( param2 == MenuCancel_ExitBack )
		{
			ArmyAdmin(client,0);
		}
	}
}

/******************************************************************/

public Army_Kill(client)
{
	// decl String:sBuffer[256];
	// Format(sBuffer, sizeof(sBuffer), "%T\n\n", "admin_menu_kill_title",client);
	new Handle:menu = CreateMenu(Handle_ArmyKill);
	SetMenuTitle(menu, "%T\n\n", "admin_menu_kill_title",client);
	SetMenuExitBackButton(menu, true);
	AddMenuItem(menu, "+1000", "+1000",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "+100", "+100",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "+10", "+10",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "0", "0",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "-10", "-10",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "-100", "-100",ITEMDRAW_DEFAULT);
	AddMenuItem(menu, "-1000", "-1000",ITEMDRAW_DEFAULT);

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public Handle_ArmyKill(Handle:hMenu, MenuAction:action, client, param2)
{
	if(action == MenuAction_Select)
	{
		new String:info[25];
		GetMenuItem(hMenu,param2,info,sizeof(info));

		new Handle:menu = CreateMenu(SetKill); 
		SetMenuExitBackButton(menu,true);
		SetMenuTitle(menu, "Выберите Игрока:\n \n"); 
		decl String:userid[24], String:name[MAX_NAME_LENGTH]; 
		for (new i = 1; i <= MaxClients; i++) 
		{ 
			if (IsClientInGame(i)) 
			{ 
				//IntToString(GetClientUserId(i), userid, 15); 
				Format(userid, sizeof(userid), "%d|%s",GetClientUserId(i),info);
				GetClientName(i, name, 32); 
				AddMenuItem(menu, userid, name); 
			} 
		} 
		DisplayMenu(menu, client, 0); 
	}
	else if ( action == MenuAction_Cancel )
	{
		if ( param2 == MenuCancel_ExitBack )
		{
			ArmyAdmin(client,0);
		}
	}
}
public SetKill(Handle:hMenu, MenuAction:action, client, param2)
{
	if ( action == MenuAction_Cancel )
	{
		if ( param2 == MenuCancel_ExitBack )
		{
			Army_Kill(client);
		}
	}
	if (action == MenuAction_End) 
	{ 
		CloseHandle(hMenu); 
		return; 
	} 
	if (action != MenuAction_Select) return; 
	decl String:info[2][25]; 
	GetMenuItem(hMenu, param2, info[0], 15); 
	ExplodeString(info[0],"|",info,2,25);
	new target = GetClientOfUserId(StringToInt(info[0])); 
	if (target > 0) 
	{ 
		if(StringToInt(info[1])==0) g_iKills[target] = StringToInt(info[1]);
		else if(!StrEqual(info[1][0],"+")) g_iKills[target] += StringToInt(info[1]);
		else if(!StrEqual(info[1][0],"-")) g_iKills[target] -= StringToInt(info[1]);
		
		CPrintToChatEx(client,client, "{green}[{teamcolor}-ARMY-{green}] {default}Игроку {green}%N{default}, установлены убийства {green}[ %s ]{default}!",target,info[1]); 
		if(target!=client)CPrintToChatEx(target, target, "{green}[{teamcolor}-ARMY-{green}] {default}Админ {green}%N{default}, установил ваши убийства {green}[ %s ]{default}!",client,info[1]); 
		
		Call_StartForward(OnPlayerArmyUp); 
		Call_PushCell(target);
		Call_PushString(g_sRank[target]);
		Call_PushCell(MODE_SET_KILLS);
		Call_Finish();
		
		SaveClient(target);
		
		if(g_bLogs)LogToFile(LOG_ADMIN_SET_KILLS,"Админ %N установил игроку %N [%d] убийств ",client,target,g_iKills[target]);
	} 
	else CPrintToChatEx(client,client, "Игрок не найден (вышел с сервера)");
	ArmyAdmin(client,0);
}
public SetDeath(Handle:hMenu, MenuAction:action, client, param2)
{
	if ( action == MenuAction_Cancel )
	{
		if ( param2 == MenuCancel_ExitBack )
		{
			Army_Death(client);
		}
	}
	if (action == MenuAction_End) 
	{ 
		CloseHandle(hMenu); 
		return; 
	} 
	if (action != MenuAction_Select) return; 
	decl String:info[2][25]; 
	GetMenuItem(hMenu, param2, info[0], 15); 
	ExplodeString(info[0],"|",info,2,25);
	new target = GetClientOfUserId(StringToInt(info[0])); 
	if (target > 0) 
	{ 
		if(StringToInt(info[1])==0) g_iDeaths[target] = StringToInt(info[1]);
		else if(!StrEqual(info[1][0],"+")) g_iDeaths[target] += StringToInt(info[1]);
		else if(!StrEqual(info[1][0],"-")) g_iDeaths[target] -= StringToInt(info[1]);

		CPrintToChatEx(client,client, "{green}[{teamcolor}-ARMY-{green}] {default}Игроку {green}%N{default}, установлены смерти {green}[ %s ]{default}!",target,info[1]); 
		if(target!=client)CPrintToChatEx(target, target, "{green}[{teamcolor}-ARMY-{green}] {default}Админ {green}%N{default}, установил ваши смерти {green}[ %s ]{default}!",client,info[1]); 
		
		SaveClient(target);
				
		Call_StartForward(OnPlayerArmyUp); 
		Call_PushCell(target);
		Call_PushString(g_sRank[target]);
		Call_PushCell(MODE_SET_DEATHS);
		Call_Finish();
		
		if(g_bLogs)LogToFile(LOG_ADMIN_SET_DEATHS,"Админ %N изменил смерти игрока %N на [%d]",client,target,g_iDeaths[target]);
	} 
	else CPrintToChatEx(client,client, "Игрок не найден (вышел с сервера)");
	ArmyAdmin(client,0);
}
/******************************************************************/

public Action:SetDeaths(client,arg)
{
	if(arg<3) 
	{
		ReplyToCommand(client, "army_deaths <#userid> <set/=/take/-/add/+> <amount>");
		return Plugin_Handled;
	}
	else
	{
		new String:sBuffer[3][64];
		GetCmdArg(1, sBuffer[0], 100);
		GetCmdArg(2, sBuffer[1], 100);
		GetCmdArg(3, sBuffer[2], 100);
		new iclient = GetClientOfUserId(StringToInt(sBuffer[0]));
		if(StrEqual(sBuffer[1],"set")||StrEqual(sBuffer[1],"="))
		{
			g_iDeaths[iclient] = StringToInt(sBuffer[2]);
			if(iclient)CPrintToChatEx(iclient, iclient, "{green}[{teamcolor}-ARMY-{green}] {default}Ваши {green}смерти{default} установлены {green}[ {default}%d {green}]{default}!",StringToInt(sBuffer[2]));
			if(g_bLogs)LogToFile(LOG_ADMIN_SET_DEATHS,"Админ %N установил игроку %N [%d] смертей",client,iclient,g_iDeaths[iclient]);
		}
		else if(StrEqual(sBuffer[1],"add")||StrEqual(sBuffer[1],"+"))
		{
			g_iDeaths[iclient] += StringToInt(sBuffer[2]);
			if(iclient)CPrintToChatEx(iclient, iclient, "{green}[{teamcolor}-ARMY-{green}] {default}Вам добавлено {green}[ {default}%d {green}]{default} смертей!",StringToInt(sBuffer[2]));
			if(g_bLogs)LogToFile(LOG_ADMIN_SET_DEATHS,"Админ %N добавил игроку %N [%s] смертей (Стало: %d)",client,iclient,sBuffer[2],g_iDeaths[iclient]);
		}
		else if(StrEqual(sBuffer[1],"take")||StrEqual(sBuffer[1],"-"))
		{
			g_iDeaths[iclient] -= StringToInt(sBuffer[2]);
			if(iclient)CPrintToChatEx(iclient, iclient, "{green}[{teamcolor}-ARMY-{green}] {default}У вас забрали {green}[ {default}%d {green}]{default} сертей!",StringToInt(sBuffer[2]));
			if(g_bLogs)LogToFile(LOG_ADMIN_SET_DEATHS,"Админ %N забрал у игрока %N [%s] смертей (Стало: %d)",client,iclient,sBuffer[2],g_iDeaths[iclient]);
		}
			
		SaveClient(iclient);
		return Plugin_Handled;
	}
}

public Action:SetKills(client,arg)
{
	if(arg<3)
	{
		ReplyToCommand(client, "army_kills <#userid> <set/=/take/-/add/+> <amount>");
		return Plugin_Handled;
	}
	else
	{
		new String:sBuffer[3][64];
		GetCmdArg(1, sBuffer[0], 100);
		GetCmdArg(2, sBuffer[1], 100);
		GetCmdArg(3, sBuffer[2], 100);
		new iclient = GetClientOfUserId(StringToInt(sBuffer[0]));
		if(StrEqual(sBuffer[1],"set")||StrEqual(sBuffer[1],"="))
		{
			g_iKills[iclient] = StringToInt(sBuffer[2]);
			if(iclient)CPrintToChatEx(iclient, iclient, "{green}[{teamcolor}-ARMY-{green}] {default}Ваши {green}убийства{default} установлены {green}[ {default}%d {green}]!",StringToInt(sBuffer[2]));
			if(g_bLogs)LogToFile(LOG_ADMIN_SET_DEATHS,"Админ %N установил игроку %N [%d] убийств",client,iclient,g_iKills[iclient]);
		}
		else if(StrEqual(sBuffer[1],"add")||StrEqual(sBuffer[1],"+"))
		{
			g_iKills[iclient] += StringToInt(sBuffer[2]);
			if(iclient)CPrintToChatEx(iclient, iclient, "{green}[{teamcolor}-ARMY-{green}] {default}Вам добавлено {green}[ {green}%d {green}]{default} убийств!",StringToInt(sBuffer[2]));
			if(g_bLogs)LogToFile(LOG_ADMIN_SET_DEATHS,"Админ %N добавил игроку %N [%s] убийств (Стало: %d)",client,iclient,sBuffer[2],g_iKills[iclient]);
		}
		else if(StrEqual(sBuffer[1],"take")||StrEqual(sBuffer[1],"-"))
		{
			g_iKills[iclient] -= StringToInt(sBuffer[2]);
			if(iclient)CPrintToChatEx(iclient, iclient, "{green}[{teamcolor}-ARMY-{green}] {default}У вас забрали {green}[ {default}%d {green}]{default} убийств!",StringToInt(sBuffer[2]));
			if(g_bLogs)LogToFile(LOG_ADMIN_SET_DEATHS,"Админ %N забрал у игрока %N [%s] убийств (Стало: %d)",client,iclient,sBuffer[2],g_iKills[iclient]);
		}
			
		SaveClient(iclient);
		return Plugin_Handled;
	}
}
bool:CheckAdminAccess(client,admflagarg) 
{
	if(!client)
		return true;
	
	new AdminId:adminId = GetUserAdmin(client);
	if(adminId == INVALID_ADMIN_ID)
	{
		// CReplyToCommand(client, "%T", "No Access", client);
		return false;
	}
	
	new count = GetAdminFlags(adminId, Access_Effective);
	if(!(count & admflagarg))
	{
		return false;
	}
	
	return true;
}
/*-------------------------------------------*/
new Handle:hAdminMenu = INVALID_HANDLE;
CreateAdminMenu()
{
    new Handle:topmenu;
    if(LibraryExists("adminmenu") && ((topmenu=GetAdminTopMenu())!=INVALID_HANDLE))
    {
        OnAdminMenuReady(topmenu);
    }	
}

public OnLibraryRemoved(const String:name[])
{
    if(StrEqual(name,"adminmenu"))
    {
        hAdminMenu = INVALID_HANDLE;
    }
}

public OnAdminMenuReady(Handle:topmenu)
{
    // Block us from being called twice
    if(topmenu == hAdminMenu)
    {
        return;
    }
    hAdminMenu = topmenu;
    
    // Now add stuff to the menu: My very own category *yay*
    new TopMenuObject:admin_category;
	admin_category = AddToTopMenu(
        hAdminMenu,						    // Menu
        "army_admin",					    // Name
        TopMenuObject_Category,			    // Type
        Handle_Admin,				    // Callback
        INVALID_TOPMENUOBJECT,			    // Parent
        "",					                // cmdName
        ADMFLAG_ROOT	                // Admin flag
        );

    if(admin_category == INVALID_TOPMENUOBJECT)
    {
        // Error... lame...
        return;
    }
}

public Handle_Admin(Handle:topmenu, TopMenuAction:action, TopMenuObject:object_id, client, String:buffer[], maxlength)
{
	switch(action)
    {
        case TopMenuAction_DisplayTitle:
            Format(buffer, maxlength, "Админка ARMY", client);
        case TopMenuAction_DisplayOption:
            Format(buffer, maxlength, "Админка ARMY", client);
    }
}