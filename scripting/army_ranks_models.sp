#include <army_ranks>
#include <sdktools_stringtables>
#include <sdktools_functions>

public Plugin:myinfo = 
{
    name = "[ ARMY ] Модель/Model",
    author = "sahapro33",
    description = "",
    version = "1.1"
}

new bool:g_bActive_Model_CT = false;
new bool:g_bActive_Model_T = false;
public ARMY_OnLoad()
{
}
public OnMapStart()
{
	g_bActive_Model_CT = (Army_GetMapSettings("Model_CT") == 1);
	g_bActive_Model_T = (Army_GetMapSettings("Model_T") == 1);
}

public ARMY_ArmyUp(client)
{
	decl String:Model[256];
	if(g_bActive_Model_CT && Army_GetStringAtributes(client,"Model_CT","",Model))
	{
		if (StrContains(Model,"models/",true)!=-1)
		{
			FormatEx(Model,sizeof(Model),"Модель CT");
			Army_RegisterItem(client,"Model_CT",Model);
		}
	}
	if(g_bActive_Model_T && Army_GetStringAtributes(client,"Model_T","0",Model))
	{
		if (StrContains(Model,"models/",true)!=-1)
		{
			FormatEx(Model,sizeof(Model),"Модель T");
			Army_RegisterItem(client,"Model_T",Model);
		}
	}
}
public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	decl String:Model[256];
	if(g_bActive_Model_CT && Army_GetStringAtributes(client,"Model_CT","0",Model))
	{
		if(StrContains(Model,"models/",true)!=-1)
		{
			FormatEx(Model,sizeof(Model),"Модель CT");
			Army_RegisterItem(client,"Model_CT",Model);
		}
	}
	if(g_bActive_Model_T && Army_GetStringAtributes(client,"Model_T","0",Model))
	{
		if(StrContains(Model,"models/",true)!=-1)
		{
			FormatEx(Model,sizeof(Model),"Модель T");
			Army_RegisterItem(client,"Model_T",Model);
		}
	}
}
public ARMY_PlayerSpawn(client)
{
	SetModel(client);
}
public OnConfigsExecuted()
{
	new Handle:hKv = Army_GetKv();
	KvRewind(hKv);
	if (KvGotoFirstSubKey(hKv))
	{
		decl String:buffer[256];
		do
		{
			KvGetString(hKv,"Model_T",buffer,256);
			if(buffer[0] && FileExists(buffer))
			{
				PrecacheModel(buffer);
			}
			KvGetString(hKv,"Model_CT",buffer,256);
			if(buffer[0] && FileExists(buffer))
			{
				PrecacheModel(buffer);
			}
		} while ( KvGotoNextKey(hKv) );
	}
}

SetModel(client)
{
	decl String:Model[256];
	switch(GetClientTeam(client))
	{
		case 2:
		{
			if (!g_bActive_Model_T)return;
			if(!Army_GetStringAtributes(client,"Model_T","",Model))
			{
				if(StrContains(Model,"models/",true)==-1)return;
			}
		}
		case 3:
		{
			if (!g_bActive_Model_CT)return;
			if(!Army_GetStringAtributes(client,"Model_CT","",Model))
			{
				if(StrContains(Model,"models/",true)==-1)return;
			}
		}
		default: return;
	}
	if(Model[0])
	{
		SetEntityModel(client,Model);
	}
}