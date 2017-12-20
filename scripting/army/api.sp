public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	OnArmyLoad = CreateGlobalForward("ARMY_OnLoad", ET_Hook);
	
	OnPlayerConnect = CreateGlobalForward("ARMY_PlayerConnect", ET_Hook, Param_Cell, Param_String, Param_Cell, Param_Cell);
	OnPlayerDisconnect = CreateGlobalForward("ARMY_PlayerDisconnect", ET_Hook, Param_Cell, Param_String, Param_Cell, Param_Cell);
	
	OnPlayerArmyUp = CreateGlobalForward("ARMY_ArmyUp", ET_Hook, Param_Cell, Param_String, Param_Cell);
	OnPlayerSpawn = CreateGlobalForward("ARMY_PlayerSpawn", ET_Hook, Param_Cell);
	OnPlayerDeath = CreateGlobalForward("ARMY_PlayerDeath", ET_Hook, Param_Cell, Param_Cell);
	
	OnCreateRankInfo = CreateGlobalForward("ARMY_CreateRankInfo", ET_Hook, Param_Cell, Param_Cell);
	OnPressItemInRankInfo = CreateGlobalForward("ARMY_PressItemInRankInfo", ET_Hook, Param_Cell, Param_Cell);
	
	CreateNative("Army_GetRank", Native_GetRank);
	CreateNative("Army_GetStringRank", Native_GetStringRank);
	CreateNative("Army_GetClientKills", Native_GetClientKills);
	CreateNative("Army_GetClientDeaths", Native_GetClientDeaths);
	CreateNative("Army_GetClientStringNextRank", Native_GetClientStringNextRank);
	CreateNative("Army_GetClientNextRankKills", Native_GetClientNextRankKills);
	
	CreateNative("Army_GetStringAtributes", Native_GetStringAtributes);
	CreateNative("Army_GetNumAtributes", Native_GetNumAtributes);
	CreateNative("Army_GetFloatAtributes", Native_GetFloatAtributes);
	CreateNative("Army_GetColorAtributes", Native_GetColorAtributes);
	
	CreateNative("Army_RegisterItem", Native_RegisterItem);
	
	CreateNative("Army_GetKv", Native_GetKv);
	CreateNative("Army_GetLockTeam", Native_GetLockTeam);
	
	CreateNative("Army_GetMapSettings", Native_GetMapSettings);
	
	MarkNativeAsOptional("GetUserMessageType");
	
	return APLRes_Success;
}

public Native_GetRank(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		return g_iRank[client];
	}
	return -1;
}

public Native_GetStringRank(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		SetNativeString(2, g_sRank[client], sizeof(g_sRank[]));
		return true;
	}
	return false;
}

public Native_GetClientKills(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		return g_iKills[client];
	}
	return -1;
}

public Native_GetClientDeaths(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		return g_iDeaths[client];
	}
	return -1;
}

public Native_GetClientStringNextRank(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		new len = GetNativeCell(3);
		decl String:sName[len];
		
		if (g_iRank[client] < GetArraySize(g_hArray_iKills) - 1)
		{
			GetArrayString(g_hArray_sRanks, g_iRank[client] + 1, sName, len);
			SetNativeString(2, sName, len);
			return true;
		}
		else return false;
	}
	return false;
}
public Native_GetClientNextRankKills(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		if (g_iRank[client] < GetArraySize(g_hArray_iKills) - 1)return g_iNextRankKills[client];
		else return -1;
	}
	return -1;
}

public Native_GetStringAtributes(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		KvRewind(hKv);
		if (KvJumpToKey(hKv, g_sRank[client]))
		{
			new maxlen = GetNativeCell(5);
			decl String:defvalue[maxlen];
			decl String:buffer[maxlen];
			
			GetNativeString(2, buffer, maxlen);
			GetNativeString(3, defvalue, maxlen);
			KvGetString(hKv, buffer, buffer, maxlen, defvalue);
			SetNativeString(4, buffer, maxlen);
			return true;
		}
	}
	return false;
}
public Native_GetNumAtributes(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		KvRewind(hKv);
		if (KvJumpToKey(hKv, g_sRank[client]))
		{
			decl String:buffer[255];
			GetNativeString(2, buffer, 255);
			return KvGetNum(hKv, buffer, GetNativeCell(3));
		}
		return -1;
	}
	return -1;
}
public Native_GetFloatAtributes(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		KvRewind(hKv);
		if (KvJumpToKey(hKv, g_sRank[client]))
		{
			decl String:buffer[2][26];
			
			GetNativeString(2, buffer[0], 26);
			GetNativeString(3, buffer[1], 4);
			new Float:fValue = KvGetFloat(hKv, buffer[0], StringToFloat(buffer[1]));
			return _:fValue;
		}
		return _:-1.0;
	}
	return _:-1.0;
}
public Native_GetColorAtributes(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client) && KvJumpToKey(hKv, g_sRank[client]))
	{
		KvRewind(hKv);
		decl String:buffer[26];
		decl color[4];
		
		GetNativeString(2, buffer, 6);
		KvGetColor(hKv, buffer, color[0], color[1], color[2], color[3]);
		SetNativeArray(2, color, 3);
		return true;
	}
	return false;
}

public Native_RegisterItem(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	if (0 < client <= MaxClients && IsClientInGame(client))
	{
		decl String:buffer[2][100];
		if (GetNativeString(3, buffer[1], sizeof(buffer[])) == SP_ERROR_NONE)
		{
			if (GetNativeString(2, buffer[0], sizeof(buffer[])) == SP_ERROR_NONE)
			{
				SetTrieString(g_hArrayInfoMenu[client], buffer[0], buffer[1], true);
				return true;
			}
		}
	}
	return false;
}

public Native_GetKv(Handle:plugin, numParams)
{
	return _:hKv;
}

public Native_GetLockTeam(Handle:plugin, numParams)
{
	return g_LockTeam;
}
public Native_GetMapSettings(Handle:plugin, numParams)
{
	decl String:buffer[100];
	if (GetNativeString(1, buffer, sizeof(buffer)) == SP_ERROR_NONE)
	{
		return KvGetNum(g_hKvMapSettings, buffer, 1);
	}
	return -1;
}

stock bool:CreateDir(const String:Directory[])
{
	if (DirExists(Directory))return true;
	
	new iSize = strlen(Directory) + 1;
	decl String:sDirectory[iSize];
	strcopy(sDirectory, iSize, Directory);
	
	DeleteLastSlash(sDirectory);
	
	new slash = 0;
	new ind = 0;
	
	do
	{
		if (sDirectory[ind] == '/')
		{
			slash++;
		}
		ind++;
	}
	while (ind <= iSize);
	
	decl String:sBuffer[slash + 1][iSize];
	ExplodeString(sDirectory, "/", sBuffer, slash + 1, iSize);
	
	ind = 0;
	
	decl String:buffer[500] = ".";
	for (ind = 0; ind <= slash; ind++)
	{
		Format(buffer, sizeof(buffer), "%s/%s", buffer, sBuffer[ind]);
		if (!DirExists(buffer))
		{
			CreateDirectory(buffer, FPERM_U_READ + FPERM_U_WRITE + FPERM_U_EXEC + 
				FPERM_G_READ + FPERM_G_WRITE + FPERM_G_EXEC + 
				FPERM_O_READ + FPERM_O_WRITE + FPERM_O_EXEC);
			CreateDir(Directory);
		}
	}
	
	return false;
}

stock DeleteLastSlash(String:sDirectory[])
{
	new iSize = strlen(sDirectory);
	if (sDirectory[iSize - 1] == '/')
	{
		iSize--;
		sDirectory[iSize] = '\0';
		return iSize;
	}
	return iSize;
} 