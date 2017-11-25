#pragma semicolon 1
#include <sourcemod>
#undef REQUIRE_PLUGIN 
#include <adminmenu> 

#include "include/colors.inc"

public Plugin:myinfo =
{
	name 		= "[ ARMY ] Core 2.0.4PR",
	author 		= "sahapro33",
	description = "",
	version 	= __DATE__,
	url 		= ""
}

#include "include/army_ranks.inc"

#include "army/vars.sp"
#include "army/events/Admin.sp"
#include "army/api.sp"

#include "army/events/OnPluginStart.sp"
#include "army/events/OnConfigsExecuted.sp"
#include "army/events/OnClientPutInServer.sp"
#include "army/events/OnClientDisconnect.sp"