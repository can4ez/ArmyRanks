public OnMapStart()
{
	decl String:CurrentMap[PLATFORM_MAX_PATH];
	GetCurrentMap(CurrentMap, sizeof(CurrentMap));
	
	CreateMapConfig(CurrentMap, sizeof(CurrentMap));
}

CreateMapConfig(String:map[], len)
{
	decl String:path[PLATFORM_MAX_PATH];
	if (StrContains(map, "workshop") != -1)
	{
		path[0] = '\0';
		for (new pos = 9; pos < len; pos++)
		{
			if (!IsCharNumeric(map[pos]))
				continue;
			path[pos - 9] = map[pos];
			path[pos - 8] = '\0';
		}
	}
	else
	{
		strcopy(path, sizeof(path), map);
	}
	BuildPath(Path_SM, path, sizeof(path), "configs/army/maps/%s.ini", path);
	if (!FileExists(path))
	{
		new Handle:kv = CreateKeyValues("map_settings");
		KvSetString(kv, "map", map);
		KvJumpToKey(kv, "settings", true);
		KvSetNum(kv, "Hp", 1);
		KvSetNum(kv, "Armor", 1);
		KvSetNum(kv, "Gravity", 1);
		KvSetNum(kv, "Speed", 1);
		KvSetNum(kv, "RegenHp", 1);
		KvSetNum(kv, "RegenArmor", 1);
		KvSetNum(kv, "He", 1);
		KvSetNum(kv, "Flash", 1);
		KvSetNum(kv, "Smoke", 1);
		KvSetNum(kv, "Weapon", 1);
		KvSetNum(kv, "Bhop", 1);
		KvSetNum(kv, "LongJump", 1);
		KvSetNum(kv, "Model_CT", 1);
		KvSetNum(kv, "Model_T", 1);
		KvSetNum(kv, "Effects", 1);
		KvSetNum(kv, "Sheild", 1);
		KvSetNum(kv, "Damage", 1);
		KvSetNum(kv, "FastReload", 1);
		KvRewind(kv);
		KeyValuesToFile(kv, path);
		CloseHandle(kv);
		kv = INVALID_HANDLE;
		LogMessage("[INFO] Map config file \"%s\" successfully created", map);
	}
	
	if (g_hKvMapSettings)
		CloseHandle(g_hKvMapSettings);
	g_hKvMapSettings = CreateKeyValues("map_settings");
	if (!FileToKeyValues(g_hKvMapSettings, path) || !KvJumpToKey(g_hKvMapSettings, "settings"))
	{
		LogError("file '%s' empty", path);
		SetFailState("file '%s' empty", path);
		return;
	}
} 