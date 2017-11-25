#if defined _colors_sahapro33_included
 #endinput
#endif
#define _colors_sahapro33_included

#define MAX_MESSAGE_LENGTH 250
#define CLEAR_ANY_COLORS 0

/* ****************************************************
** 					[ CS:S v34 ]					 **
**************************************************** */
static const String:CTag[][] = {
		"{default}", 		"{green}", 
		"{lightgreen}",		"{red}", 
		"{blue}", 			"{olive}"	};
static const String:CTagCode[][] = {
		"\x01", 			"\x04", 
		"\x03", 			"\x03", 
		"\x03", 			"\x05"		};
/* **************************************************** */


/* ****************************************************
** 					[ CS:GO ]						 **
**************************************************** */

static const String:color_t[][] = {
		"{default}", 		"{red}", 
		"{lightpurple}", 	"{green}", 
		"{lime}", 			"{lightgreen}", 
		"{lightred}", 		"{gray}", 
		"{lightolive}", 	"{olive}", 
		"{lightblue}", 		"{blue}", 
		"{purple}"				};
static const String:color_c[][] = {
		"\x01", 			"\x02", 
		"\x03", 			"\x04", 
		"\x05", 			"\x06", 
		"\x07", 			"\x08", 
		"\x09", 			"\x10", 
		"\x0B", 			"\x0C", 
		"\x0E"					};
/* **************************************************** */


/* ****************************************************
** 					[ CS:S ]						 **
**************************************************** */

static const String:CColor[][] = {
	"{aliceblue}",			"{allies}", 
	"{ancient}", 			"{antiquewhite}", 
	"{aqua}", 				"{aquamarine}", 
	"{arcana}", 			"{axis}", 
	"{azure}", 				"{beige}", 
	"{bisque}", 			"{black}", 
	"{blanchedalmond}", 	"{blue}", 
	"{blueviolet}", 		"{brown}", 
	"{burlywood}", 			"{cadetblue}", 
	"{chartreuse}", 		"{chocolate}", 
	"{collectors}",			"{common}", 
	"{community}", 			"{coral}", 
	"{cornflowerblue}", 	"{cornsilk}", 
	"{corrupted}", 			"{crimson}", 
	"{cyan}", 				"{darkblue}", 
	"{darkcyan}", 			"{darkgray}", 
	"{darkgoldenrod}", 		"{darkgrey}", 
	"{darkgreen}", 			"{darkkhaki}", 
	"{darkmagenta}", 		"{darkolivegreen}", 
	"{darkorange}", 		"{darkorchid}", 
	"{darkred}", 			"{darksalmon}", 
	"{darkseagreen}", 		"{darkslateblue}", 
	"{darkslategray}", 		"{darkslategrey}", 
	"{darkturquoise}", 		"{darkviolet}", 
	"{deeppink}", 			"{deepskyblue}", 
	"{dimgray}", 			"{dimgrey}",
	"{dodgerblue}", 		"{exalted}", 
	"{firebrick}", 			"{floralwhite}", 
	"{forestgreen}", 		"{frozen}", 
	"{fuchsia}", 			"{fullblue}", 
	"{fullred}", 			"{gainsboro}", 
	"{genuine}", 			"{ghostwhite}", 
	"{gold}", 				"{goldenrod}", 
	"{gray}", 				"{grey}", 
	"{green}", 				"{greenyellow}", 
	"{haunted}", 			"{honeydew}", 
	"{hotpink}", 			"{immortal}", 
	"{indianred}", 			"{indigo}", 
	"{ivory}", 				"{khaki}", 
	"{lavender}", 			"{lavenderblush}", 
	"{lawngreen}", 			"{legendary}", 
	"{lemonchiffon}", 		"{lightblue}", 
	"{lightcoral}", 		"{lightcyan}", 
	"{lightgoldenrodyellow}", "{lightgray}", 
	"{lightgrey}", 			"{lightgreen}", 
	"{lightpink}", 			"{lightsalmon}", 
	"{lightseagreen}", 		"{lightskyblue}", 
	"{lightslategray}", 	"{lightslategrey}", 
	"{lightsteelblue}", 	"{lightyellow}", 
	"{lime}", 				"{limegreen}", 
	"{linen}", 				"{magenta}", 
	"{maroon}", 			"{mediumaquamarine}", 
	"{mediumblue}", 		"{mediumorchid}", 
	"{mediumpurple}", 		"{mediumseagreen}", 
	"{mediumslateblue}", 	"{mediumspringgreen}", 
	"{mediumturquoise}", 	"{mediumvioletred}", 
	"{midnightblue}", 		"{mintcream}", 
	"{mistyrose}", 			"{moccasin}", 
	"{mythical}", 			"{navajowhite}", 
	"{navy}", 				"{normal}", 
	"{oldlace}", 			"{olive}", 
	"{olivedrab}", 			"{orange}", 
	"{orangered}", 			"{orchid}", 
	"{palegoldenrod}", 		"{palegreen}", 
	"{paleturquoise}", 		"{palevioletred}", 
	"{papayawhip}", 		"{peachpuff}", 
	"{peru}", 				"{pink}", 
	"{plum}", 				"{powderblue}", 
	"{purple}", 			"{rare}", 
	"{red}", 				"{rosybrown}", 
	"{royalblue}", 			"{saddlebrown}", 
	"{salmon}", 			"{sandybrown}", 
	"{seagreen}", 			"{seashell}", 
	"{selfmade}", 			"{sienna}", 
	"{silver}", 			"{skyblue}", 
	"{slateblue}", 			"{slategray}", 
	"{slategrey}", 			"{snow}", 
	"{springgreen}", 		"{steelblue}", 
	"{strange}", 			"{tan}", 
	"{teal}", 				"{thistle}", 
	"{tomato}", 			"{turquoise}", 
	"{uncommon}", 			"{unique}", 
	"{unusual}", 			"{valve}", 
	"{vintage}", 			"{violet}", 
	"{wheat}", 				"{white}", 
	"{whitesmoke}", 		"{yellow}", 
	"{yellowgreen}"						};
static const CColorCode[] = {
	0xF0F8FF, 0x4D7942, // same as Allies team in DoD:S
	0xEB4B4B, // same as Ancient item rarity in Dota 2
	0xFAEBD7, 0x00FFFF, 0x7FFFD4, 0xADE55C, // same as Arcana item rarity in Dota 2
	0xFF4040, // same as Axis team in DoD:S
	0x007FFF, 0xF5F5DC, 0xFFE4C4, 0x000000, 0xFFEBCD, 0x99CCFF, // same as BLU/Counter-Terrorist team color
	0x8A2BE2, 0xA52A2A, 0xDEB887, 0x5F9EA0, 0x7FFF00, 0xD2691E, 0xAA0000, // same as Collector's item quality in TF2
	0xB0C3D9, // same as Common item rarity in Dota 2
	0x70B04A, // same as Community item quality in TF2
	0xFF7F50, 0x6495ED, 0xFFF8DC, 0xA32C2E, // same as Corrupted item quality in Dota 2
	0xDC143C, 0x00FFFF, 0x00008B, 0x008B8B, 0xB8860B, 0xA9A9A9, 0xA9A9A9, 0x006400, 0xBDB76B, 0x8B008B, 0x556B2F, 0xFF8C00, 0x9932CC, 0x8B0000, 0xE9967A, 0x8FBC8F, 0x483D8B, 0x2F4F4F, 0x2F4F4F, 0x00CED1, 0x9400D3, 0xFF1493, 0x00BFFF, 0x696969, 0x696969, 0x1E90FF, 0xCCCCCD, // same as Exalted item quality in Dota 2
	0xB22222, 0xFFFAF0, 0x228B22, 0x4983B3, // same as Frozen item quality in Dota 2
	0xFF00FF, 0x0000FF, 0xFF0000, 0xDCDCDC, 0x4D7455, // same as Genuine item quality in TF2
	0xF8F8FF, 0xFFD700, 0xDAA520, 0xCCCCCC, // same as spectator team color
	0xCCCCCC, 0x3EFF3E, 0xADFF2F, 0x38F3AB, // same as Haunted item quality in TF2
	0xF0FFF0, 0xFF69B4, 0xE4AE33, // same as Immortal item rarity in Dota 2
	0xCD5C5C, 0x4B0082, 0xFFFFF0, 0xF0E68C, 0xE6E6FA, 0xFFF0F5, 0x7CFC00, 0xD32CE6, // same as Legendary item rarity in Dota 2
	0xFFFACD, 0xADD8E6, 0xF08080, 0xE0FFFF, 0xFAFAD2, 0xD3D3D3, 0xD3D3D3, 0x99FF99, 0xFFB6C1, 0xFFA07A, 0x20B2AA, 0x87CEFA, 0x778899, 0x778899, 0xB0C4DE, 0xFFFFE0, 0x00FF00, 0x32CD32, 0xFAF0E6, 0xFF00FF, 0x800000, 0x66CDAA, 0x0000CD, 0xBA55D3, 0x9370D8, 0x3CB371, 0x7B68EE, 0x00FA9A, 0x48D1CC, 0xC71585, 0x191970, 0xF5FFFA, 0xFFE4E1, 0xFFE4B5, 0x8847FF, // same as Mythical item rarity in Dota 2
	0xFFDEAD, 0x000080, 0xB2B2B2, // same as Normal item quality in TF2
	0xFDF5E6, 0x9EC34F, 0x6B8E23, 0xFFA500, 0xFF4500, 0xDA70D6, 0xEEE8AA, 0x98FB98, 0xAFEEEE, 0xD87093, 0xFFEFD5, 0xFFDAB9, 0xCD853F, 0xFFC0CB, 0xDDA0DD, 0xB0E0E6, 0x800080, 0x4B69FF, // same as Rare item rarity in Dota 2
	0xFF4040, // same as RED/Terrorist team color
	0xBC8F8F, 0x4169E1, 0x8B4513, 0xFA8072, 0xF4A460, 0x2E8B57, 0xFFF5EE, 0x70B04A, // same as Self-Made item quality in TF2
	0xA0522D, 0xC0C0C0, 0x87CEEB, 0x6A5ACD, 0x708090, 0x708090, 0xFFFAFA, 0x00FF7F, 0x4682B4, 0xCF6A32, // same as Strange item quality in TF2
	0xD2B48C, 0x008080, 0xD8BFD8, 0xFF6347, 0x40E0D0, 0xB0C3D9, // same as Uncommon item rarity in Dota 2
	0xFFD700, // same as Unique item quality in TF2
	0x8650AC, // same as Unusual item quality in TF2
	0xA50F79, // same as Valve item quality in TF2
	0x476291, // same as Vintage item quality in TF2
	0xEE82EE, 0xF5DEB3, 0xFFFFFF, 0xF5F5F5, 0xFFFF00, 0x9ACD32};
/* **************************************************** */

/*

	Engine_Unknown			= Не определено
	Engine_SourceSDK2006	= CS:S v34
	Engine_SourceSDK2007 	
	Engine_CSGO				= CS:GO
	Engine_CSS				= CS:S STEAM
*/
new EngineVersion:g_ColorsGame = Engine_Unknown;

stock Color_PrintToChatEx(client, auth, const String:message[], any:...)
{
	new a = strlen(message)+190, l;
	decl String:b[a];
	l = ReplaceString(b, VFormat(b, a, message, 3), "\n", "~", false);
	
	Color_GetGame();
	ReplaceColorSay(b,a);
	
	if(l)
	{
		decl String:s[l+1][192];
		for (new m = ExplodeString(b, "~", s, l, 192), p; p < m; p++)
		{
			// PrintToChat(client, " %s", s[p]);
			CSayText2(client,client,s[p]);
		}
	}
	else CSayText2(client,client,b); // PrintToChat(client, " %s", b);
}
stock Color_PrintToChatAllEx(client, auth, const String:message[], any:...)
{
	new a = strlen(message)+190, l;
	decl String:b[a];
	l = ReplaceString(b, VFormat(b, a, message, 3), "\n", "~", false);
	Format(b,a,"\x01%s",b);
	
	Color_GetGame();
	ReplaceColorSay(b,a);
	for(new i = 1; i < MaxClients; i++)
	{
	
		if(l)
		{
			decl String:s[l+1][192];
			for (new m = ExplodeString(b, "~", s, l, 192), p; p < m; p++)
			{
				// PrintToChat(client, " %s", s[p]);
				CSayText2(client,client,s[p]);
			}
		}
		else CSayText2(client,client,b); // PrintToChat(client, " %s", b);
	}
}
stock Color_PrintToChat(client, const String:message[], any:...)
{
	new a = strlen(message)+190, l;
	decl String:b[a];
	l = ReplaceString(b, VFormat(b, a, message, 3), "\n", "~", false);
	
	Color_GetGame();
	ReplaceColorSay(b,a);
	
	if(l)
	{
		decl String:s[l+1][192];
		for (new m = ExplodeString(b, "~", s, l, 192), p; p < m; p++)
		{
			PrintToChat(client, " \x01%s", s[p]);
		}
	}
	else  PrintToChat(client, " \x01%s", b);
}

stock Color_PrintToChatAll(const String:message[], any:...)
{
	new a = strlen(message)+190, l;
	decl String:b[a];
	l = ReplaceString(b, VFormat(b, a, message, 2), "\n", "~", false);
	
	Color_GetGame();
	ReplaceColorSay(b,a);
	
	if(l)
	{
		decl String:s[l+1][192];
		for (new m = ExplodeString(b, "~", s, l, 192), p; p < m; p++) 
		{
			PrintToChatAll(" \x01%s", s[p]);
		}
	}
	else  PrintToChatAll(" \x01%s", b);
}

stock Color_PrintHintText(client, const String:message[], any:...)
{
	new size = strlen(message)+190;  
	decl String:text[size];
	VFormat(text, size, message, 3);
	
	Color_GetGame();
	
	if(g_ColorsGame == Engine_CSGO)
	{
		if(ReplaceString(text, size, "{{", "<font color='") 
		   && ReplaceString(text, size, "}}", "</font>")) 
		{
			ReplaceString(text, size, "==", "'>");
		}
	}
	PrintHintText(client, text);
}

stock Color_PrintHintTextToAll(const String:message[], any:...)
{
	new size = strlen(message)+190;  
	decl String:text[size];
	VFormat(text, size, message, 2);
	
	Color_GetGame();
	if(g_ColorsGame == Engine_CSGO)
	{
		if(ReplaceString(text, size, "{{", "<font color='")
		&& ReplaceString(text, size, "}}", "</font>")) 
		{
			ReplaceString(text, size, "==", "'>");
		}
	}
	else
	{
		if(ReplaceString(text, size, "{{", "")
		&& ReplaceString(text, size, "}}", "")) 
		{
			ReplaceString(text, size, "==", "");
		}
		
	}
	PrintHintTextToAll(text);
}

stock CSayText2(client, author, const String:szMessage[])
{
	new Handle:bf = StartMessageOne("SayText2", client, USERMSG_RELIABLE|USERMSG_BLOCKHOOKS);

	if(g_ColorsGame == Engine_CSGO)
	{
		PbSetInt(bf, "ent_idx", author);
		PbSetBool(bf, "chat", true);

		PbSetString(bf, "msg_name", szMessage);
		PbAddString(bf, "params", "");
		PbAddString(bf, "params", "");
		PbAddString(bf, "params", "");
		PbAddString(bf, "params", "");
	}
	else
	{
		BfWriteByte(bf, author);
		BfWriteByte(bf, true);
		BfWriteString(bf, szMessage);
	}
	EndMessage();
}

/* Other */

stock Color_GetGame()
{
	if(g_ColorsGame==Engine_Unknown)
	{
		g_ColorsGame = GetEngineVersion();
	}
}

stock ReplaceColorSay(String:text[], maxlength)
{
	ReplaceString(text, maxlength, "{teamcolor}", "\x03");
	switch(g_ColorsGame)
	{
		case Engine_CSGO:
		{
			for(new i=0; i < sizeof(color_t); i++)
			{
				ReplaceString(text, maxlength, color_t[i], color_c[i]);
			}
			#if CLEAR_ANY_COLORS == 1
			for(new i=0; i < sizeof(CTag); i++)
			{
				ReplaceString(text, maxlength, CTag[i], "");
			}
			for(new i=0; i < sizeof(CColor); i++)
			{
				ReplaceString(text, maxlength, CColor[i], "");
			}
			#endif
		}
		case Engine_SourceSDK2006:
		{
			for(new i=0; i < sizeof(CTag); i++)
			{
				ReplaceString(text, maxlength, CTag[i], CTagCode[i]);
			}
			#if CLEAR_ANY_COLORS == 1
			for(new i=0; i < sizeof(color_t); i++)
			{
				ReplaceString(text, maxlength, color_t[i], "");
			}
			for(new i=0; i < sizeof(CColor); i++)
			{
				ReplaceString(text, maxlength, CColor[i], "");
			}
			#endif
		}
		case Engine_CSS:
		{
			ReplaceString(text, maxlength, "{default}", "\x01");
			decl String:buff[32];
			for(new i=0; i < sizeof(CColor); i++)
			{
				FormatEx(buff, sizeof(buff), "\x07%06X", CColorCode[i]);
				ReplaceString(text, maxlength, CColor[i], buff);
			}
			#if CLEAR_ANY_COLORS == 1
			for(new i=0; i < sizeof(color_t); i++)
			{
				ReplaceString(text, maxlength, color_t[i], "");
			}
			for(new i=0; i < sizeof(CTag); i++)
			{
				ReplaceString(text, maxlength, CTag[i], "");
			}
			#endif
		}
		#if CLEAR_ANY_COLORS == 1
		default:
		{
			for(new i=0; i < sizeof(color_t); i++)
			{
				ReplaceString(text, maxlength, color_t[i], "");
			}
			for(new i=0; i < sizeof(CTag); i++)
			{
				ReplaceString(text, maxlength, CTag[i], "");
			}
			for(new i=0; i < sizeof(CColor); i++)
			{
				ReplaceString(text, maxlength, CColor[i], "");
			}
		}
		#endif
	}
}