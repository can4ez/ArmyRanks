#include <army_ranks>
#include <sdktools>

#define CS_SLOT_PRIMARY		0 /* AWP | Ak47 | AUG ... */
#define CS_SLOT_SECONDARY	1 /* USP | DEAGLE ... */
#define CS_SLOT_KNIFE		2
#define CS_SLOT_C4			4

new Count[MAXPLAYERS+1] = 0;

public Plugin:myinfo = 
{
    name = "[ ARMY ] Оружие/Weapons",
    author = "sahapro33",
    description = "",
    version = "1.3"
}

public ARMY_OnLoad() LoadTranslations("army_ranks/modules.phrases.txt");

public ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[])
{
	if(Army_GetNumAtributes(client,"WeaponCount",-1) > 0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer,sizeof(Buffer),"%t","WEAPON");
		Army_RegisterItem(client,"Weapon",Buffer);
	}
}

public ARMY_ArmyUp(client)
{
	if(Army_GetNumAtributes(client,"WeaponCount",-1) > 0)
	{
		decl String:Buffer[100];
		FormatEx(Buffer,sizeof(Buffer),"%t","WEAPON");
		Army_RegisterItem(client,"Weapon",Buffer);
	}
}

public ARMY_PlayerSpawn(client)
{
	Count[client] = Army_GetNumAtributes(client,"WeaponCount",0);
	if(Count[client]>0)ShowMenu(client);
}
ShowMenu(client)
{
	decl String:buffer[2][256];
	new i = 0;
	new Handle:menu = CreateMenu(Handle_WeaponMenu);
	SetMenuTitle(menu,"[-ARMY-] Оружие\n\n ");
	
	if(Army_GetStringAtributes(client,"WeaponPrimary","0",buffer[0],256))
	{
		if(strcmp(buffer[0],"0") && ExplodeString(buffer[0],":",buffer,2,256)) 
		{
			Format(buffer[0],sizeof(buffer[]),"0|%s",buffer[0]);
			AddMenuItem(menu,buffer[0],buffer[1]); 
			i++;
		}
	}
	
	if(Army_GetStringAtributes(client,"WeaponSecondary","0",buffer[0],256))
	{
		if(strcmp(buffer[0],"0") && ExplodeString(buffer[0],":",buffer,2,256)) 
		{
			Format(buffer[0],sizeof(buffer[]),"1|%s",buffer[0]);
			AddMenuItem(menu,buffer[0],buffer[1]); 
			i++;
		}
	}
	if(i>0)DisplayMenu(menu,client,0);
}
public Handle_WeaponMenu(Handle:menu, MenuAction:action, client, iSlot)
{
	if(action == MenuAction_Select)
	{
		decl String:info[2][256];
		GetMenuItem(menu,iSlot,info[0],sizeof(info[]));
		ExplodeString(info[0],"|",info,sizeof(info),sizeof(info[]));
		
		Format(info[1],sizeof(info[]),"weapon_%s",info[1]);
		
		ChangeWeapon(client, StringToInt(info[0]), info[1])
		Count[client]--;
		if(Count[client]>0)ShowMenu(client);
	}
}
ChangeWeapon(client, slot, String:WP[])
{
	new weaponIdx;
	if ((weaponIdx = GetPlayerWeaponSlot(client, slot)) > 0)
	{
		decl String:classname[20];
		GetEdictClassname(weaponIdx, classname, sizeof(classname));
		if (strcmp(WP, classname) == 0)
		{
			// PrintToChat(client, "У вас уже есть %s",classname);
			GivePlayerItem(client, WP);
		}
		else
		{
			RemovePlayerItem(client, weaponIdx);
			AcceptEntityInput(weaponIdx, "Kill");
			GivePlayerItem(client, WP);
			// PrintToChat(client, "У вас есть %s=нужно %s изменим",classname,WP);
		}
	}
	else
	{
		GivePlayerItem(client, WP);
		// PrintToChat(client, "У вас ничего нет в слоте №%d выдадим %s",slot,WP);
	}
}