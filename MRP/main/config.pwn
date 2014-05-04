/*

        The MIT License (MIT) - Modified

        Copyright (c) 2014 Zachary Griffeth

        Permission is hereby granted, free of charge, to any person obtaining a copy of
        this script and associated documentation files (the "Script"), to deal in
        the Script without restriction, including without limitation the rights to
        use, copy, modify, merge, publish, distribute, and/or sublicense copies of
        the Script, and to permit persons to whom the Script is furnished to do so,
        subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Script.

        You may not sell this Script for profit or gain, nor claim the Script as your own work.

        THE SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
        FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
        COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
        IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
        CONNECTION WITH THE SCRIPT OR THE USE OR OTHER DEALINGS IN THE SCRIPT.
*/

// DEFINITIONS //
#define SQL_SERVER 	"host"
#define SQL_USER	"user"
#define SQL_DB		"mrp"
#define SQL_PASS	""
#define SQL_DEBUG	1 // 0 - disable , 1 - enable MySQL debug.
/* Max Sizes */
#define MAX_INT    11
#define MAX_STRING 1024

// OTHER //
native WP_Hash(buffer[], len, const str[]);
#define SendClientMessageEx va_SendClientMessage
#define GetState(%0) PlayerInfo[%0][pState]
#define SetState(%0,%1) PlayerInfo[%0][pState]=%1
#define IsPressed(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define IsHolding(%0) ((newkeys & (%0)) == (%0))

/* Formula by Shane */
#define CalcExp(%0) ((50 * (%0) * (%0) * (%0) - 150 * (%0) * (%0) + 600 * (%0)) / 5)

#define GetAdminName(%0) PlayerInfo[%0][pAdminName]

#define SetPlayerInteriorEx(%0,%1) \
	PlayerInfo[%0][pInt]=%1; SetPlayerInterior(%0, %1)

#define SetPlayerVirtualWorldEx(%0,%1) \
	PlayerInfo[%0][pVW]=%1; SetPlayerVirtualWorld(%0, %1)

// FORWARDS //
forward BanCheck(playerid);
forward KickDelay(playerid);
forward CheckAccount(playerid);
forward RegisterAccount(playerid);
forward LoginAccount(playerid);
forward SaveUserAccount(playerid, stage);
forward EventHandler(playerid, event);
forward ClearChat(playerid);
forward LoadATMs();
forward OnSaveATM(i);
forward LoadDoors();
forward OnSaveDoor(i);
forward Freeze_Handler(playerid, type);
forward ACMenu_Handler(playerid);
forward OnUpdateAdminName(playerid);
forward LoadTrees();
forward LookupAccount(playerid);
forward LoadHelpInfos();
forward CallShowAgain(playerid, text[], time);
forward p_AchievementHandler(playerid, type);
forward LoadTowers();
forward LoadHouses();

forward FinishQuery();
public FinishQuery() return 1;

//forward Float:GetDistanceBetweenPoints(Float:x, Float:y, Float:z, Float:xa, Float:ya, Float:za);

// SERVER_CONFIG //
// new server_config_pass;
// It is now the GVar 'serv_conf_pass'

// DIALOGS // 

#define DIALOG_BLANK            1337

#define	DIALOG_LOGIN			0
#define	DIALOG_REGISTER			1 
#define DIALOG_ACCOUNT			2
#define DIALOG_CREATION_ONE		10
#define DIALOG_CREATION_TWO		11
#define DIALOG_CREATION_SKIN	12
#define DIALOG_ACMENU_LOGIN		20
#define DIALOG_ACMENU_MAIN		21
#define DIALOG_ACMENU_PASS		22
#define DIALOG_ATM				30
#define DIALOG_ATM_WITHDRAW		31
#define DIALOG_ATM_DEPOSIT		32
#define DIALOG_ATM_BALANCE		33
#define DIALOG_ADMIN_NAME		40
#define DIALOG_JOIN_JOB			50
#define DIALOG_LOAD_TRUCK       51
#define DIALOG_TRUCKER_JOB      52
#define DIALOG_ACCENT           60
#define DIALOG_ACCENT_INPUT     61
#define DIALOG_FIND_NPC         70
#define DIALOG_FIND_JOB         71

// EVENTS //
#define EVENT_CREATION_CLASS 	1
#define EVENT_CREATION_SEX		2
#define EVENT_CREATION_SKIN		3

// STATES //
#define STATE_ALIVE				1
#define STATE_INJURED			2
#define STATE_DEAD				3

// PROPERTIES //
#define MAX_MIDS				200
#define MAX_ATMS				50
#define MAX_DOORS				250 
#define MAX_TREES				25
#define MAX_INFOS               35
#define MAX_TOWERS              15
#define MAX_HOUSES              500

// TYPES // 
#define TYPE_DOOR				1
#define TYPE_GARAGE				2
#define TYPE_HOUSE				3
#define TYPE_BUSINESS			4
#define TYPE_BANK				5

// JOB TYPES //
#define JOB_LUMBER				1
#define JOB_MINER				2
#define P_JOB_TRUCKER           3

// ADMIN DEFINES //
#define STAFF_ADMIN				1
#define STAFF_SADMIN			2
#define STAFF_LADMIN			3
#define STAFF_HADMIN			1337 // l33t admins (term of leet, as in elite.)

// ACHIEVEMENTS //
#define A_RISKTAKER             0
#define A_RICH                  1
#define A_FIRSTCAR              2
#define A_BIZMAN                3
#define A_FAMILYMAN             4
#define A_FACTION               5
#define A_MEETANDGREET          6