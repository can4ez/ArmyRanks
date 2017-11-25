/* Используется при передачи события ARMY_ArmyUp(client,const String:sNewRank[],mode)
 * В качестве 3-его аргумента
 */
#define MODE_RANK_RESET		0
#define MODE_RANK_UP 		1
#define MODE_SET_KILLS 		2
#define MODE_SET_DEATHS 	3

/* Пути для .log файлов */
#define LOG_ADMIN_SET_RANK 		"addons/sourcemod/logs/army_ranks/Admin_SetRank.log"
#define LOG_ADMIN_SET_DEATHS 	"addons/sourcemod/logs/army_ranks/Admin_SetDeaths.log"
#define LOG_ADMIN_SET_KILLS 	"addons/sourcemod/logs/army_ranks/Admin_SetKills.log"
#define LOG_ADMIN_RESETPLAYER 	"addons/sourcemod/logs/army_ranks/Admin_ResetPlayer.log"

#define LOG_RESETPLAYER 		"addons/sourcemod/logs/army_ranks/Player_Reset.log"
#define LOG_RANK_PLAYER_UP		"addons/sourcemod/logs/army_ranks/Player_RankUp.log"

forward ARMY_OnLoad();

/* Игрок подключился на сервер.
 *
 * @param Индекс клиента
 * @param Ранг игрока в виде строки
 * @param Убийства игрока
 * @param Смерти игрока 
 */
forward ARMY_PlayerConnect(client,g_sRank[],g_iKills[],g_iDeaths[]);

/* Игрок отключился от сервер.
 *
 * @param Индекс клиента
 * @param Ранг игрока в виде строки
 * @param Убийства игрока
 * @param Смерти игрока 
 */
forward ARMY_PlayerDisconnect(client,g_sRank[],g_iKills[],g_iDeaths[]);

/* Срабатывает при получении игроком нового ранга
 *
 * @param Индекс игрока
 * @param Новый ранг игрока
 * @param
 */
forward ARMY_ArmyUp(client,const String:sNewRank[],mode);

/* Срабатывает при возрождении игрока */
forward ARMY_PlayerSpawn(client);

/* Срабатывает при смерти игрока */
forward ARMY_PlayerDeath(client,attaker);

/* Игрок зашёл в панель информации а своём ранге 
 * @param Индекс игрока
 * @param Handle панели 
*/
forward ARMY_CreateRankInfo(client,Handle:g_RankInfoPanel);

/* Срабатывает при нажатии на пункт в меню информации о ващем ранге */
forward ARMY_PressItemInRankInfo(client,iItemId);

/* Получаем намор ранга у игрока
 *
 * @param Индекс игрока
 * 
 * @return Номер ранга игрока
 */
native Army_GetRank(client);

/* Получаем ранг игрока в виде строки
 *
 * @param Индекс игрока
 * @param Буфер звания
 *
 * @return Возвращает true в случаи успаха, false в противном случаи 
 */
native bool:Army_GetStringRank(client,const String:buffer[]);

/*
 * @return Возвращает Handle глобального KV (KeyValue)
 */
native Handle:Army_GetKv();

/*
 * Получаем номер разрушоной команды.
 */
native Army_GetLockTeam();

native Army_GetClientKills(client);
native Army_GetClientDeaths(client);
native bool:Army_GetClientStringNextRank(client,const String:buffer[],maxlen=128);
native Army_GetClientNextRankKills(client);

native bool:Army_GetStringAtributes(client,const String:key[],const String:defvalue[],String:buffer[],maxlen = 256);
native Army_GetNumAtributes(client,const String:key[],defvalue);
native Float:Army_GetFloatAtributes(client,const String:key[],const String:defvalue[]);
native bool:Army_GetColorAtributes(client,const String:key[],color[4]);

native Army_RegisterItemMenu_RankInfo(const String:sRankAtribute[], activate = 0); // 0 - Text | 1 - Item

native bool:Army_RegisterItem(client,const String:key[],const String:value[]);