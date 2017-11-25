#pragma semicolon 1
#include <sourcemod>
#undef REQUIRE_PLUGIN 
#include <adminmenu> 

#include "include/colors.inc"

new String:PLUGIN_VERSION[56] =  "2.0.3PR";

public Plugin:myinfo =
{
	name 		= "[ ARMY ] Core",
	author 		= "sahapro33",
	description = "",
	version 	= PLUGIN_VERSION,
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