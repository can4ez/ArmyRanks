#pragma semicolon 1
#include <sourcemod>
#include <adminmenu>

#include <colors>
// #include <gameme>

#define PLUGIN_VERSION "2.0.2 Alpha Test"

public Plugin:myinfo =
{
	name 		= "[ ARMY ] Core",
	author 		= "sahapro33",
	description = "",
	version 	= PLUGIN_VERSION,
	url 		= ""
}

#include "include/rankme.inc"
#include "include/army_ranks.inc"

#include "army/vars.sp"
#include "army/events/Admin.sp"
#include "army/api.sp"

#include "army/events/OnPluginStart.sp"
#include "army/events/OnConfigsExecuted.sp"
#include "army/events/OnClientPutInServer.sp"
#include "army/events/OnClientDisconnect.sp"