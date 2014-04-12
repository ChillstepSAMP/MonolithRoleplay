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

public OnGameModeInit()
{
	// MYSQL //
	gSQLHandle = mysql_connect( SQL_SERVER, SQL_USER, SQL_DB, SQL_PASS );
	mysql_log();

	// GENERAL //
	SetGameModeText(VERSION);
	AddPlayerClass(299, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	UsePlayerPedAnims();
 	ShowPlayerMarkers(0);
 	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	ShowNameTags(0);

	CreateServerTextDraws();

	for(new i = 0; i < MAX_MIDS; i++)
		ResetMPacket(i);

	OnLoadATMs();
	OnLoadDoors();
	OnLoadTrees(); // -- part of an unfinished job system

	format(query, sizeof(query), "SELECT * FROM `helpinfos`");
	mysql_function_query(gSQLHandle, query, true, "LoadHelpInfos", "");
	format(query, sizeof(query), "SELECT * FROM `cell_towers`");
	mysql_function_query(gSQLHandle, query, false, "LoadTowers", "");

	ConnectNPC("Frank", "npcFrank");
	ConnectNPC("Julio", "npcJulio");
	ConnectNPC("Juan", "npcJuan");
	return 1;
}

public OnGameModeExit()
{
	for(new i = 0; i < MAX_ATMS; i++) {
		if(ATMInfo[i][aPosX] != 0.0 && ATMInfo[i][aPosY] != 0.0 && ATMInfo[i][aPosZ] != 0.0) 
			SaveATM(i);
	}
	for(new i = 0; i < MAX_DOORS; i++) {
		if(DoorInfo[i][dExteriorX] != 0.0 && DoorInfo[i][dExteriorY] != 0.0 && DoorInfo[i][dExteriorZ] != 0.0) 
			SaveDoor(i);
	}
	for(new i = 0; i < MAX_INFOS; i++) {
		if(InfoEnum[i][infoPos][0] != 0.0 && InfoEnum[i][infoPos][0] != 0.0 && InfoEnum[i][infoPos][0] != 0.0)
			SaveHelpInfo(i);
	}
	for(new i = 0; i < MAX_TOWERS; i++) {
		if(TowerInfo[i][tPos][0] != 0.0 && TowerInfo[i][tPos][1] != 0.0 && TowerInfo[i][tPos][2] != 0.0)
			SaveTower(i);
	}
	foreach(Player, i) {
		SendClientMessageEx(i, COLOR_RED, "NOTICE: " COL_YELLOW "Server has shut down.");
		//SetTimerEx("KickDelay", 500, false, "i", i);
	}
	mysql_close(gSQLHandle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	/* Anything needed to be done to an NPC as well, goes up here. else, below. */
	HideAchievementGUIFrame(playerid);
	SetPlayerColor(playerid, 0xFFFFFFFF);
	
	if(IsPlayerNPC(playerid)) return 1;
	
	SetPlayerHealthEx(playerid, 100.0);
	SetPlayerArmourEx(playerid, 0.0);
	ResetPlayer(playerid);
	TogglePlayerControllable(playerid, 0);

	format(query, sizeof(query), "SELECT * FROM `user_bans` WHERE `Username` = '%s' OR `BannedIP` = '%s' LIMIT 1", GetPlayerNameEx(playerid), GetPlayerIpEx(playerid));
	mysql_function_query(gSQLHandle, query, true, "BanCheck", "i", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DestroyDynamic3DTextLabel(PlayerInfo[playerid][nameTag]);

	if(IsPlayerNPC(playerid)) return 1;

	TextDrawDestroy(PlayerInfo[playerid][pTDInfo]);
	
	if(LoginStatus[playerid] != 0) 
		BeginSaveUser(playerid);

	if(PlayerInfo[playerid][pTruck] != INVALID_VEHICLE_ID) {
		DestroyVehicle(PlayerInfo[playerid][pTruck]);
		PlayerInfo[playerid][pTruck] = INVALID_VEHICLE_ID;
	}
	
	LoginStatus[playerid] = 0;

	new string[128];
	switch(reason)
    {
        case 0: format(string, sizeof(string), "*NEAR* %s disconnected from the server. (time out/crash)", GetPlayerNameEx(playerid, 1));
        case 1: format(string, sizeof(string), "*NEAR* %s disconnected from the server. (quit)", GetPlayerNameEx(playerid, 1));
        case 2: format(string, sizeof(string), "*NEAR* %s disconnected from the server. (kicked/banned)", GetPlayerNameEx(playerid, 1));
    }
    ProxDetector(30.0, playerid, string, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW, COLOR_YELLOW);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) {	
		new string[24+6];
		format(string, sizeof(string), "%s (%i)", GetPlayerNameEx(playerid, 1), playerid);
		PlayerInfo[playerid][nameTag] = 
			CreateDynamic3DTextLabel(string, COLOR_WHITE, 2795.61, -2462.44, 13.19+0.1, 10.0, playerid, INVALID_VEHICLE_ID, 0, 0, 0, -1, 10.0);
		if(strcmpEx(GetPlayerNameEx(playerid), "Frank")) 
		{
			SetPlayerSkin(playerid, 27);
			SetPlayerPosEx(playerid, 2795.61, -2462.44, 13.19);
			SetPlayerFacingAngle(playerid, 360);
			npcFrank = playerid;
			#if defined MRP_DEBUG 
				print("[DEBUG] Frank's on stage.");
			#endif
		}
		else if(strcmpEx(GetPlayerNameEx(playerid), "Julio")) {
			npcJulio = playerid;
		}
		else if(strcmpEx(GetPlayerNameEx(playerid), "Juan")) {
			npcJuan = playerid;
		}
		return 1;
	}

	if(GetState(playerid) == STATE_DEAD) {
	    SetState(playerid, STATE_ALIVE);
	    SetPlayerPosEx(playerid, 1178.1584, -1323.3243, 14.1063);
		SetPlayerHealth(playerid, 100.0);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "You have been sent to the hospital.");
	    return 1;
	}
	
	if(PlayerInfo[playerid][pPrisoned] > 0) {
		SetPlayerInteriorEx(playerid, 6);
		SetPlayerVirtualWorldEx(playerid, 1337);
		SetPlayerPosEx(playerid, 264.67, 77.79, 1001.04);
		return 1;
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SetState(playerid, STATE_DEAD);
	if(PlayerInfo[playerid][pPrisoned] > 0) {
		SetSpawnInfo(playerid, 0, 50, 264.67, 77.79, 1001.04, 0, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		return 1;
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	foreach(Player, i) {
		if(vehicleid == PlayerInfo[i][pTruck]) 
		{
			DestroyVehicle(vehicleid);
			PlayerInfo[i][pTruck] = INVALID_VEHICLE_ID;
			SendClientMessageEx(i, COLOR_RED, "Notice: " COL_YELLOW "You have been fined $200 for the destruction of your truck.");
			GivePlayerMoneyEx(i, -200);
		}
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[]) // always return 0 here if you use a return statement...
{
	if(strfind(text, "|", true) != -1)
	{
		SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You cannot use this '|' character in chat.");
		return 0;
	}
	
	if(TextIPCheck(playerid, text)) {
		SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");
		return 0;
	}

	if(text[0] == '!') // simple chat command.
	{
		if(strcmpEx(text[1], "print"))
		{
			new Float:pos[4];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			GetPlayerFacingAngle(playerid, pos[3]);
			printf("%.2f,%.2f,%.2f,%.2f",pos[0],pos[1],pos[2],pos[3]);
			return 0;
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		switch(strlen(text))
		{
			case 1 .. 20: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 1, 1, 1, 0, 1000);
			case 21 .. 50: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 1, 1, 1, 0, 2500);
			case 51 .. 100: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 1, 1, 1, 0, 3000);
			case 101 .. 128: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 1, 1, 1, 0, 3500);
			default: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 1, 1, 1, 0, 1250);
		}
	}
	SetPlayerChatBubble(playerid, text, COLOR_WHITE, 20.0, 6000);
	new chat_string[128];
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN && GetPVarInt(playerid, "AdminDuty") == 1)
		format(chat_string, 128, "%s %s says: %s", GetPlayerStaffRank(playerid), GetPlayerNameEx(playerid,1), text);
	else if(!strcmpEx(PlayerInfo[playerid][pAccent], "None") && GetPVarInt(playerid, "AdminDuty") != 1)
		format(chat_string, 128, "%s (%s accent) says: %s", GetPlayerNameEx(playerid,1), PlayerInfo[playerid][pAccent], text);
	else
		format(chat_string, 128, "%s says: %s", GetPlayerNameEx(playerid,1), text);
	ProxDetector(30.0, playerid, chat_string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	return 0;
}

public OnPlayerCommandReceived(playerid, cmdtext[]) 
{
	if(!LoginStatus[playerid]) {
		SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You are not logged in and cannot use commands.");
		return 0;
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success) 
{
	/* let's print what they're doing */
	new str[128];
	format(str, sizeof(str), "[cmd] %s: %s (%d)", GetPlayerNameEx(playerid), cmdtext, success);
	printf(str);
	return (!success) ? SendClientMessageEx(playerid, COLOR_ORANGE, "Server: " COL_WHITE "You have entered an unknown command! (" COL_ORANGE "%s" COL_WHITE ")", cmdtext) : (1);
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER) {
		PlayerInfo[playerid][uLastVeh] = GetPlayerVehicleID(playerid);
		
		format(LastVehUsed[GetPlayerVehicleID(playerid)], MAX_PLAYER_NAME, GetPlayerNameEx(playerid,1));
		SetPlayerArmedWeapon(playerid, 0);
	}

	if(newstate == PLAYER_STATE_ONFOOT) {
		if(GetVehicleModel(PlayerInfo[playerid][uLastVeh]) == 449) {
			SetCameraBehindPlayer(playerid);
			#if defined MRP_DEBUG 
				print("[DEBUG] Called : %i, %i, %i", playerid, newstate, oldstate);
			#endif
		}
	}
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid) // STREAMER
{
	for(new i = 1; i < MAX_MIDS; i++) {
		if(pickupid == MoneyPacket[i][mID] && gettime() > MoneyPacket[i][mTimer]) {
			GivePlayerMoneyEx(playerid, MoneyPacket[i][mCash]);
			DestroyMPacket(i);
			break; /* Let's not loop through the rest... */
		}
	}
	for(new i = 0; i < MAX_INFOS; i++) {
		if(pickupid == InfoEnum[i][infoPickup]) {
			SendClientMessageEx(playerid, COLOR_GREEN, "Help Point: " COL_WHITE "%s", InfoEnum[i][infoStr]);
			break;
		}
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	/*if(IsHolding(KEY_CROUCH)) {
		for(new i = 0; i < MAX_DOORS; i++) {
			if(IsPlayerInRangeOfPoint(playerid, DoorInfo[i][dRange], DoorInfo[i][dExteriorX], DoorInfo[i][dExteriorY], DoorInfo[i][dExteriorZ]) 
			&& (GetPlayerVirtualWorld(playerid) == DoorInfo[i][dVWx] && GetPlayerInterior(playerid) == DoorInfo[i][dIntx])) {
				EnterExitFunc(playerid, i, 1, TYPE_DOOR);
				break;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3, DoorInfo[i][dInteriorX], DoorInfo[i][dInteriorY], DoorInfo[i][dInteriorZ]) 
			&& (GetPlayerVirtualWorld(playerid) == DoorInfo[i][dVW] && GetPlayerInterior(playerid) == DoorInfo[i][dInt])) {
				EnterExitFunc(playerid, i, 2, TYPE_DOOR);
				break;
			}
		}
	}*/

	if(IsHolding(KEY_YES)) {
		new Float:pos[3];
		GetPlayerPos(npcFrank, pos[0], pos[1], pos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 5, pos[0], pos[1], pos[2])) {
			if(PlayerInfo[playerid][TruckerStage] > 0)
				return ShowPlayerDialog(playerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "Frank - Message", "You're already on a job for me.\nSpeaking of which, YOU SHOULD DO THAT NOW!", "Sorry", "");
			if(GetPVarInt(playerid, "CoolDown") > gettime()) 
				return ShowPlayerDialog(playerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "Frank - Message", "Sorry, I don't have anything for you right now.\nCheck back again soon.", "Okay", "");
			new info[132];
			if(PlayerInfo[playerid][pJob] != P_JOB_TRUCKER) 
				format(info, sizeof(info), "Hey, you lookin' for a job, kid?\nI am need some truckers to deliver goods around the city, ya' know.\nInterested in working for me?");
			else 
				format(info, sizeof(info), "I see you've come crawling back for some more.\nCan you go on another run? I need some more goods shipped around Los Santos.");
			ShowPlayerDialog(playerid, DIALOG_TRUCKER_JOB, DIALOG_STYLE_MSGBOX, "Frank - Interaction", info, "Yes", "Nah");
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;

	/* modified version of cessil's */
	new time = gettime();

    if(lastHealthUpdate[playerid] < time && PlayerInfo[playerid][pStaff] <= 0) {
        lastHealthUpdate[playerid] = time;

        new Float:currentHealth;
        GetPlayerHealth(playerid, currentHealth);

        new currentHealthInt = floatround(currentHealth, floatround_round);
        new healthShouldBeInt = floatround(GetPVarFloat(playerid,"playerHealth"), floatround_round);

        if(currentHealthInt == healthShouldBeInt) SetPVarInt(playerid, "healthSynched", 1);

        if(!GetPVarInt(playerid,"healthSynched")) {
            if(currentHealthInt > healthShouldBeInt) {
                healthUpdateFail{playerid}++;
                switch(healthUpdateFail{playerid}) {
                    case 30, 45: {
                        foreach(Player, i) {
                            if(PlayerInfo[i][pStaff] >= STAFF_ADMIN) {
                                SendClientMessageEx(i, COLOR_RED, "[AdmWarn] " COL_YELLOW "%s possibly has deysnced health (%d secs, %d/%d)", GetPlayerNameEx(playerid, 1), healthUpdateFail{playerid}, currentHealthInt, healthShouldBeInt);
                            }
                        }
                        SetPlayerHealth(playerid, GetPVarFloat(playerid, "playerHealth"));
                    }
                    case 60: {
                        foreach(Player, i) {
                            if(PlayerInfo[i][pStaff] >= STAFF_ADMIN) {
                                SendClientMessageEx(i, COLOR_RED, "[AdmWarn] " COL_YELLOW "%s possibly has deysnced health (%d secs, %d/%d) and was kicked.", GetPlayerNameEx(playerid, 1), healthUpdateFail{playerid}, currentHealthInt, healthShouldBeInt);
                            }
                        }
                        SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_YELLOW "Please reconnect, an error occured with syncing your health");
                        SetTimerEx("KickDelay", 100, false, "i", playerid);
                        return 1;
                    }
                }
            }
        }
        else
        {
            healthUpdateFail{playerid} = 0;
            if(healthShouldBeInt > currentHealthInt) {
                SetPVarFloat(playerid, "playerHealth", currentHealth);
            }
            if(currentHealthInt > healthShouldBeInt && currentHealthInt <= 100 && currentHealthInt  > 0) {
                SetPlayerHealth(playerid, GetPVarFloat(playerid, "playerHealth"));
            }
            if(currentHealthInt > 100 || currentHealthInt < 0) {
                BanEx(playerid, "Health Hacks");
                return 1;
            }
        }
    }
    if(lastArmourUpdate[playerid] < time && PlayerInfo[playerid][pStaff] <= 0) {
        lastArmourUpdate[playerid] = time;

        new Float:currentArmour;
        GetPlayerArmour(playerid, currentArmour);

        new currentArmourInt = floatround(currentArmour,floatround_round);
        new armourShouldBeInt = floatround(GetPVarFloat(playerid, "playerArmour"), floatround_round);

        if(currentArmourInt == armourShouldBeInt) SetPVarInt(playerid, "armourSynched", 1);

        if(!GetPVarInt(playerid,"armourSynched")) {
            if(currentArmourInt > armourShouldBeInt) {
                armourUpdateFail{playerid}++;
                switch(armourUpdateFail{playerid}) {
                    case 30, 45: {
                        foreach(Player, i) {
                            if(PlayerInfo[i][pStaff] >= STAFF_ADMIN) {
                                SendClientMessageEx(i, COLOR_RED, "[AdmWarn]" COL_YELLOW "%s possibly has deysnced armour (%d secs, %d/%d)", GetPlayerNameEx(playerid, 1), armourUpdateFail{playerid}, currentArmourInt, armourShouldBeInt);
                            }
                        }
                        SetPlayerArmour(playerid, GetPVarFloat(playerid, "playerArmour"));
                    }
                    case 60: {
                        foreach(Player, i) {
                            if(PlayerInfo[i][pStaff] >= STAFF_ADMIN) {
                                SendClientMessageEx(i, COLOR_RED, "[AdmWarn]" COL_YELLOW "%s possibly has deysnced armour (%d secs, %d/%d) and was kicked.", GetPlayerNameEx(playerid, 1), armourUpdateFail{playerid}, currentArmourInt, armourShouldBeInt);
                            }
                        }
                        SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_YELLOW "Please reconnect, an error occured with syncing your armour.");
                        SetTimerEx("KickDelay", 100, false, "i", playerid);
                        return 1;
                    }
                }
            }
        }
        else
        {
            armourUpdateFail{playerid} = 0;
            if(armourShouldBeInt > currentArmourInt) {
                SetPVarFloat(playerid, "playerArmour", currentArmour);
            }
            if(currentArmourInt > armourShouldBeInt && currentArmourInt <= 100 && currentArmourInt  > 0) {
                SetPlayerArmour(playerid,GetPVarFloat(playerid,"playerArmour"));
            }
            if(currentArmourInt > 100 || currentArmourInt < 0) {
                BanEx(playerid, "Armour Hacks");
                return 1;
            }
        }
    }
    DeletePVar(playerid, "afkTimer");
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LOGIN:
		{
			if(!response) return Kick(playerid),1;
			new escapedstring[64], hash[129];

			if(InvalidChar(inputtext)) return Kick(playerid); // temp disallow and kick.

			mysql_real_escape_string(inputtext, escapedstring, gSQLHandle);
			WP_Hash(hash, sizeof(hash), escapedstring);

			format(query, sizeof(query), "SELECT * FROM `user_accounts` WHERE Username='%s' AND Password = '%s'", GetPlayerNameEx(playerid), hash);
			mysql_function_query(gSQLHandle, query, true, "LoginAccount", "i", playerid);
		}
		case DIALOG_REGISTER:
		{
			if(!response) return Kick(playerid),1;

			new escapedstring[64], hash[129], caption[MAX_PLAYER_NAME + 12], info[128];

			if(InvalidChar(inputtext)) return Kick(playerid); // temp disallow and kick.

			if(strlen(inputtext) < 4 || strlen(inputtext) > 60) {
			    format(info, sizeof(info), "{FFFFFF}Welcome to Monolith Roleplay, {1E90FF}%s{FFFFFF}\nPlease create a password to register this username.\n" COL_RED "Your password must be between 4 and 60 characters.", GetPlayerNameEx(playerid,1));
				format(caption, sizeof(caption), "Register - %s", GetPlayerNameEx(playerid,1));
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, caption, info, "Okay", "Cancel");
				return 1;
			}

			mysql_real_escape_string(inputtext, escapedstring, gSQLHandle);
			WP_Hash(hash, sizeof(hash), escapedstring);

			PlayerInfo[playerid][pStaff] = 0;
			PlayerInfo[playerid][pDisabled] = 0;
			PlayerInfo[playerid][pLevel] = 1;
			PlayerInfo[playerid][pCreated] = 0;
			
			SetState(playerid, 1);
			SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
			
			format(PlayerInfo[playerid][pUserIp], 16, GetPlayerIpEx(playerid));

			format(query, sizeof(query), "INSERT INTO `user_accounts` (`Username`, `Password`, `Staff`, `Mod`, `Level`, `XP`, `Disabled`, `UserIp`) VALUES ('%s', '%s', %d, %d, %d, %d, %d, '%s')", GetPlayerNameEx(playerid), hash, 0,0,1,0,0, GetPlayerIpEx(playerid));
			mysql_function_query(gSQLHandle, query, false, "RegisterAccount", "i", playerid);
		}
		case DIALOG_CREATION_ONE:
		{
			if(response)
			{
				ClearChat(playerid);
				PlayerInfo[playerid][pSex] = 1; // male
				SendClientMessageEx(playerid, COLOR_ORANGE, "Character Creation: " COL_WHITE "You have selected male. You may change this later.");
				SetTimerEx("EventHandler", 2500, false, "ii", playerid, EVENT_CREATION_SKIN);
			}
			else
			{
				ClearChat(playerid);
				PlayerInfo[playerid][pSex] = 2; // female
				SendClientMessageEx(playerid, COLOR_ORANGE, "Character Creation: " COL_WHITE "You have selected female. You may change this later.");
				SetTimerEx("EventHandler", 2500, false, "ii", playerid, EVENT_CREATION_SKIN);
			}
		}
		case DIALOG_CREATION_SKIN:
		{
			/* This is temporary */
			SetPlayerSkin(playerid, (PlayerInfo[playerid][pSex] == 2) ? (93) : (59));
			SetTimerEx("Freeze_Handler", 500, false, "ii", playerid, 1);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);

			PlayerInfo[playerid][pModel] = (PlayerInfo[playerid][pSex] == 2) ? (93) : (59);
			PlayerInfo[playerid][pCreated] = 1;
			PlayerInfo[playerid][pVW] = 0;
			PlayerInfo[playerid][pInt] = 0;

			SendClientMessageEx(playerid, COLOR_GOLDENROD, "Monolith Roleplay: " COL_WHITE "Have fun and play safe! You may now explore!");
		}
		case DIALOG_ACMENU_LOGIN:
		{
			if(!response) return 1;
			
			if(!isnull(inputtext))
			{
				if(InvalidChar(inputtext)) return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You entered an invalid character into the dialog.");

				new escapedstring[64], hash[129];
				
				mysql_real_escape_string(inputtext, escapedstring, gSQLHandle);
				WP_Hash(hash, sizeof(hash), escapedstring);
				
				format(query, sizeof(query), "SELECT `Password` FROM `user_accounts` WHERE `Password`='%s'",hash);
				mysql_function_query(gSQLHandle, query, false, "ACMenu_Handler", "i", playerid);
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You did not enter anything into the dialog.");
			}
		}
		case DIALOG_ACMENU_MAIN:
		{
			if(!response) return 1;

			if(listitem == 0) {
				ShowPlayerDialog(playerid, DIALOG_ACMENU_PASS, DIALOG_STYLE_INPUT, "Input New Pass", "Please enter a new pass below that is above 6 characters:", "Enter", "Cancel");
			}
		}
		case DIALOG_ACMENU_PASS:
		{
			if(!response) return 1;

			if(isnull(inputtext)) {
				SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "Null input not accepted.");
				return 1;
			}

			if(strlen(inputtext) < 7) {
				SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "Your password must be at least 6 characters long.");
				return 1;
			}

			if(InvalidChar(inputtext)) {
				SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You entered an invalid character into the dialog.");
				return 1;
			}

			new escapedstring[64], hash[129];

			mysql_real_escape_string(inputtext, escapedstring, gSQLHandle);
			WP_Hash(hash, sizeof(hash), escapedstring);

			SetPVarInt(playerid, "ChangedPass", 1);
			format(query, sizeof(query), "UPDATE `user_accounts` SET `Password` = '%s' WHERE `UserID` = %d", hash, PlayerInfo[playerid][pUserID]);
			mysql_function_query(gSQLHandle, query, false, "ACMenu_Handler", "i", playerid);
		}
		case DIALOG_ATM:
		{
			if(!response) {
				DeletePVar(playerid, "UsingATMID");
				return 1;
			}
			
			switch(listitem) // WITHDRAW - DEPOSIT - BALANCE - EXIT 
			{
				case 0:
				{
					new info[128];

					SendClientMessageEx(playerid, COLOR_ORANGE, "Note: " COL_WHITE "You have a limited withdraw amount at an ATM. Please visit a bank to withdraw more.");
					format(info, sizeof(info), "Please enter an amount that is equal to or below $%s that you would like to withdraw:", NumFormat(ATMInfo[GetPVarInt(playerid, "UsingATMID")][aMoney]));
					ShowPlayerDialog(playerid, DIALOG_ATM_WITHDRAW, DIALOG_STYLE_INPUT, "Withdraw Menu", info, "Okay", "Cancel");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_ATM_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit Menu", "Please enter an amount you would like to deposit:", "Okay", "Cancel");
				}
				case 2:
				{
					new info[286];
					format(info, sizeof(info), COL_WHITE "==" COL_GOLDENROD "BALANCE SHEET" COL_WHITE "==\n\n\
						Cash (On Hand): {00FF00}$%s{FFFFFF}\n\
						Bank Balance: {00FF00}$%s{FFFFFF}\n\
						Total Wealth: {00FF00}$%s{FFFFFF}\n\
						Paycheck Amount: {00FF00}$%s{FFFFFF}\n\
						Bills Total: {FF0000}$%s{FFFFFF}\n\
						Bank Balance after bills: {FFFF00}$%s",
					NumFormat(PlayerInfo[playerid][pMoneyOnHand]),
					NumFormat(PlayerInfo[playerid][pBankMoney]),
					NumFormat(PlayerInfo[playerid][pMoneyOnHand] + PlayerInfo[playerid][pBankMoney]),
					NumFormat(PlayerInfo[playerid][pTotalPay]),
					NumFormat(PlayerInfo[playerid][pBills]),
					NumFormat(PlayerInfo[playerid][pBankMoney] - PlayerInfo[playerid][pBills]));

					ShowPlayerDialog(playerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "Balance Sheet", info, "Okay", "");
					DeletePVar(playerid, "UsingATMID");
				}
				case 3: return 1;
			}
		}
		case DIALOG_ATM_WITHDRAW: 
		{
			if(!response) return 1;
			new idx = GetPVarInt(playerid, "UsingATMID");
			new amt = strval(inputtext);
			if(amt <= 0) {
				return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You cannot withdraw less than $1.");
			}
			if(amt > PlayerInfo[playerid][pBankMoney]) {
				return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You can not go over your bank amount.");
			}
			if(amt > ATMInfo[idx][aMoney]) {
				return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You cannot go over the ATM's amount");
			}
			SendClientMessageEx(playerid, COLOR_GREEN, "Withdraw: " COL_WHITE "You have successfully withdrawn $%s.", NumFormat(amt));
			GivePlayerBankMoney(playerid, -amt);
			GivePlayerMoneyEx(playerid, amt);
			
			ATMInfo[idx][aMoney]-=amt;
			UpdateATMLabel(idx);

			DeletePVar(playerid, "UsingATMID");
		}
		case DIALOG_ATM_DEPOSIT: 
		{
			if(!response) return 1;
			new idx = GetPVarInt(playerid, "UsingATMID");
			new amt = strval(inputtext);
			if(amt < 1) {
				return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You cannot deposit less than $1.");
			}
			if(amt > PlayerInfo[playerid][pMoneyOnHand]) {
				return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You can not go over your on-hand amount.");
			}
			SendClientMessageEx(playerid, COLOR_GREEN, "Deposit: " COL_WHITE "You have successfully deposited $%s.", NumFormat(amt));
			GivePlayerMoneyEx(playerid, -amt);
			GivePlayerBankMoney(playerid, amt);

			ATMInfo[idx][aMoney] += amt;
			UpdateATMLabel(idx);

			DeletePVar(playerid, "UsingATMID");
		}
		case DIALOG_ADMIN_NAME: {
			if(!response) 
				return Kick(playerid); /* idiot handling */

			if(isnull(inputtext)) 
				return SendClientMessageEx(playerid, COLOR_RED, "You are a dunce. Try again and this time actually enter text.");

			if(InvalidChar(inputtext)) return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You entered an invalid character into the dialog.");

			new escapedstring[64];
			mysql_real_escape_string(inputtext, escapedstring, gSQLHandle);
			format(PlayerInfo[playerid][pAdminName], MAX_PLAYER_NAME, escapedstring);
			
			format(query, sizeof(query), "UPDATE `user_accounts` SET `AdminName`='%s' WHERE `UserID`=%d", escapedstring, PlayerInfo[playerid][pUserID]);
			mysql_function_query(gSQLHandle, query, false, "OnUpdateAdminName", "i", playerid);
		}
		case DIALOG_LOAD_TRUCK:
		{
			PlayerInfo[playerid][TruckerStage] = 3;
			if(response)
			{
				new point = random(sizeof(LegalTruckPoints));
				SendClientMessageEx(playerid, COLOR_GOLDENROD, "Frank: " COL_WHITE "Alright, you'll take the " COL_GREEN "food supplies" COL_WHITE ".");
				SetPlayerCheckpoint(playerid, LegalTruckPoints[point][0], LegalTruckPoints[point][1], LegalTruckPoints[point][2], 5);
			}
			else
			{
				new point = random(sizeof(IllegalTruckPoints));
				SendClientMessageEx(playerid, COLOR_GOLDENROD, "Frank: " COL_WHITE "Alright, you'll take the " COL_RED "children's toys" COL_WHITE ".");
				SetPlayerCheckpoint(playerid, IllegalTruckPoints[point][0], IllegalTruckPoints[point][1], IllegalTruckPoints[point][2], 5);
				SetPVarInt(playerid, "HighRiskTrucker", 1);
			}
			ShowPlayerMessage(playerid, "~r~Loading...~w~ Please wait.", 11);
			SetTimerEx("Freeze_Handler", 10000, false, "ii", playerid, 1);
		}
		case DIALOG_TRUCKER_JOB:
		{
			if(response)
			{
				PlayerInfo[playerid][TruckerStage] = 1;
				if(PlayerInfo[playerid][pJob] != P_JOB_TRUCKER) PlayerInfo[playerid][pJob] = P_JOB_TRUCKER;
				ShowPlayerDialog(playerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "Frank - Message", "Glad you decided to work for me.\nMake your way over there to pick up a truck.", "Okay", "");
				SetPlayerCheckpoint(playerid, 2748.54, -2450.31, 13.64, 5);
			}
			else 
			{
				ShowPlayerDialog(playerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "Frank - Message", "Sorry to hear you can't.\nJust come back if you change your mind.", "Okay", "");
				PlayerInfo[playerid][TruckerStage] = 0;
				DisablePlayerCheckpoint(playerid);
			}
		}
		case DIALOG_ACCENT:
		{
			if(response) { // custom
				SetPVarInt(playerid, "AccentSelection", 1);
				ShowPlayerDialog(playerid, DIALOG_ACCENT_INPUT, DIALOG_STYLE_INPUT, "Enter Accent", "Please enter an APPROPRIATE accent below.\n\
					Abuse can get you banned from this feature.", "Enter", "Cancel");
			}
			else { // pre-selected
				SetPVarInt(playerid, "AccentSelection", 2);
				ShowPlayerDialog(playerid, DIALOG_ACCENT_INPUT, DIALOG_STYLE_LIST, "Pick Accent", 
					"English\n\
					French\n\
					Arabian\n\
					Italian\n\
					Swedish\n\
					Dutch\n\
					German\n\
					Indian\n\
					Turkish\n\
					Slavic\n\
					Texan\n\
					Southern\n\
					Canadian\n\
					Scottish\n\
					Russian\n\
					Jersey",
					"Enter", 
					"Cancel"
				);
			}
		}
		case DIALOG_ACCENT_INPUT: 
		{
			if(response) {
				if(GetPVarInt(playerid, "AccentSelection") == 1) {
					if(isnull(inputtext))
						return SendClientMessageEx(playerid, COLOR_ORANGE, "Dialog Usage: " COL_WHITE "Please enter text.");
					if(TextIPCheck(playerid, inputtext))
						return SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");
					if(InvalidChar(inputtext))
						return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You entered an invalid character into the dialog.");
					if(strlen(inputtext) > 11)
						return SendClientMessageEx(playerid, COLOR_ORANGE, "Dialog Usage: " COL_WHITE "Please enter text less than 11."); 
					format(PlayerInfo[playerid][pAccent], 12, inputtext);
					SendClientMessageEx(playerid, COLOR_GREEN, "Success: " COL_GREY "You have set your accent to be %s.", PlayerInfo[playerid][pAccent]);
					DeletePVar(playerid, "AccentSelection");
				}
				else if(GetPVarInt(playerid, "AccentSelection") == 2) {
					switch(listitem) {
						case 0: format(PlayerInfo[playerid][pAccent], 12, "English");
						case 1: format(PlayerInfo[playerid][pAccent], 12, "French");
						case 2: format(PlayerInfo[playerid][pAccent], 12, "Arabian");
						case 3: format(PlayerInfo[playerid][pAccent], 12, "Italian");
						case 4: format(PlayerInfo[playerid][pAccent], 12, "Swedish");
						case 5: format(PlayerInfo[playerid][pAccent], 12, "Dutch");
						case 6: format(PlayerInfo[playerid][pAccent], 12, "German");
						case 7: format(PlayerInfo[playerid][pAccent], 12, "Indian");
						case 8: format(PlayerInfo[playerid][pAccent], 12, "Turkish");
						case 9: format(PlayerInfo[playerid][pAccent], 12, "Slavic");
						case 10: format(PlayerInfo[playerid][pAccent], 12, "Texan");
						case 11: format(PlayerInfo[playerid][pAccent], 12, "Southern");
						case 12: format(PlayerInfo[playerid][pAccent], 12, "Canadian");
						case 13: format(PlayerInfo[playerid][pAccent], 12, "Scottish");
						case 14: format(PlayerInfo[playerid][pAccent], 12, "Russian");
						case 15: format(PlayerInfo[playerid][pAccent], 12, "Jersey");
					}
					SendClientMessageEx(playerid, COLOR_GREEN, "Success: " COL_GREY "You have set your accent to be %s.", PlayerInfo[playerid][pAccent]);
					DeletePVar(playerid, "AccentSelection");
				}
			}
		}
		case DIALOG_FIND_NPC:
		{
			new Float:npcPos[3];
			if(response) {
				switch(listitem) {
					case 0: 
					{
						GetPlayerPos(npcFrank, npcPos[0], npcPos[1], npcPos[2]);
						SetPlayerCheckpoint(playerid, npcPos[0], npcPos[1], npcPos[2], 5);
						SendClientMessageEx(playerid, COLOR_GREY, "You have set your checkpoint to Frank's location.");
					}
					case 1:
					{
						GetPlayerPos(npcJuan, npcPos[0], npcPos[1], npcPos[2]);
						SetPlayerCheckpoint(playerid, npcPos[0], npcPos[1], npcPos[2], 5);
						SendClientMessageEx(playerid, COLOR_GREY, "You have set your checkpoint to Juan's location.");
					}
					case 2:
					{
						GetPlayerPos(npcJulio, npcPos[0], npcPos[1], npcPos[2]);
						SetPlayerCheckpoint(playerid, npcPos[0], npcPos[1], npcPos[2], 5);
						SendClientMessageEx(playerid, COLOR_GREY, "You have set your checkpoint to Julios' location.");
					}
				}
			}
		}
		case DIALOG_FIND_JOB: 
		{
			if(response) {
				switch(listitem) {
					case 0: SetPlayerCheckpoint(playerid, 2772.41, -2461.37, 13.63, 5);
				}
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerInfo[playerid][TruckerStage] > 0 && PlayerInfo[playerid][pJob] == P_JOB_TRUCKER)
	{
		switch(PlayerInfo[playerid][TruckerStage])
		{
			case 1:
			{
				PlayerInfo[playerid][pTruck] = CreateVehicle(499, 2739.64, -2465.97, 13.64, 271.7, random(5), 1, 500);
				
				PutPlayerInVehicle(playerid, PlayerInfo[playerid][pTruck], 0);
				TogglePlayerControllable(playerid, 0);
				SetTimerEx("Freeze_Handler", 2000, false, "ii", playerid, 1);
				SendClientMessageEx(playerid, COLOR_GOLDENROD, "Task: " COL_WHITE "Please make your way to the next checkpoint to load your vehicle");
				
				switch(random(3)) {
					case 0: SetPlayerCheckpoint(playerid, 2744.09, -2431.66, 13.65, 5);
					case 1: SetPlayerCheckpoint(playerid, 2744.72, -2422.54, 13.62, 5);
					case 2: SetPlayerCheckpoint(playerid, 2744.66, -2440.08, 13.64, 5);
				}
				PlayerInfo[playerid][TruckerStage] = 2;
			}
			case 2:
			{
				TogglePlayerControllable(playerid, 0);
				ShowPlayerDialog(playerid, DIALOG_LOAD_TRUCK, DIALOG_STYLE_MSGBOX, "Loading Truck", "As you approach the shady harbor master, he asks what you would like to load your truck with.", "Legal", "Illegal");
			}
			case 3:
			{
				if(GetPVarInt(playerid, "HighRiskTrucker") == 1) {
					GivePlayerMoneyEx(playerid, 250);
					ShowPlayerMessage(playerid, "~g~$250~w~, 150XP and pot for ~r~illegal~w~ delivery!");
					ExpHandler(playerid, 150);
				}
				else {
					GivePlayerMoneyEx(playerid, 200);
					ShowPlayerMessage(playerid, "~g~$200~w~ and 100XP for delivery!");
					ExpHandler(playerid, 100);
				}
				SetPlayerCheckpoint(playerid, 2567.66, -2417.91, 13.63, 5);
				SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You have 5 minutes to return the vehicle to the point before it destroys itself and detracts $200.");
				SetPVarInt(playerid, "TruckerReturn", gettime()+300);
				SetPVarInt(playerid, "CoolDown", gettime()+360);
				PlayerInfo[playerid][TruckerStage] = 4;
			}
			case 4:
			{
				DestroyVehicle(PlayerInfo[playerid][pTruck]);
				PlayerInfo[playerid][pTruck] = INVALID_VEHICLE_ID;
				PlayerInfo[playerid][TruckerStage] = 0;
				DisablePlayerCheckpoint(playerid);
			}
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	new string[256];
	format(string, sizeof(string), "%s's QuickStats\n\
		VIP: %s\n\
		Staff: %s\n\
		Developer: %s\n\
		Level: %d\n\
		Sex: %s",
		GetPlayerNameEx(clickedplayerid, 1),
		GetPlayerVIPStatus(clickedplayerid),
		GetPlayerStaffRank(clickedplayerid),
		GetPlayerStaffRank(clickedplayerid, 1),
		PlayerInfo[clickedplayerid][pLevel],
		(PlayerInfo[clickedplayerid][pSex] == 2) ? ("Female") : ("Male")
	);
	ShowPlayerDialog(playerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "QuickStats", string, "Done", "");
	return 1;
}

public KickDelay(playerid) 
{
	return Kick(playerid);
}

public BanCheck(playerid)
{
	new fields, rows, fetch[64];
    cache_get_data(rows, fields, gSQLHandle);
	
	if(rows)
	{
		cache_get_field_content(0, "BannedReason", fetch, gSQLHandle, 64);
		
		SendClientMessageEx(playerid, COLOR_RED, "You are banned from the server, reason: %s.", fetch);
		SetTimerEx("KickDelay", 500, false, "i", playerid);
	}
	else
	{
		format(query, sizeof(query), "SELECT * FROM `user_accounts` WHERE Username = '%s' LIMIT 1", GetPlayerNameEx(playerid));
		mysql_function_query(gSQLHandle, query, true, "CheckAccount", "i", playerid);
	}
	return 1;
}

public CheckAccount(playerid)
{
	new fields, rows, info[128], caption[MAX_PLAYER_NAME + 12];
	cache_get_data(rows, fields, gSQLHandle);
	
	if(rows)
	{
		format(info, sizeof(info), "{FFFFFF}Welcome back to Monolith Roleplay, {1E90FF}%s{FFFFFF}\nPlease enter the password to your account.", GetPlayerNameEx(playerid,1));
		format(caption, sizeof(caption), "Login - %s", GetPlayerNameEx(playerid,1));
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, caption, info, "Okay", "Cancel");
	}
	else
	{
		format(info, sizeof(info), "{FFFFFF}Welcome to Monolith Roleplay, {1E90FF}%s{FFFFFF}\nPlease create a password to register this username.",GetPlayerNameEx(playerid,1));
		format(caption, sizeof(caption), "Register - %s", GetPlayerNameEx(playerid,1));
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, caption, info, "Okay", "Cancel");
	}
	return 1;
}

public RegisterAccount(playerid)
{
	if(mysql_affected_rows(gSQLHandle))
	{
		PlayerInfo[playerid][pUserID] = mysql_insert_id(gSQLHandle); // -- only works after it is inserted, as I found out.
		#if defined MRP_DEBUG 
			printf("[DEBUG] Registered Account %s, ID:%d", GetPlayerNameEx(playerid), PlayerInfo[playerid][pUserID]);
		#endif
		PlayerInfo[playerid][pHealth] = 100;
		SetSpawnInfo(playerid, 0, 299, 1772.34, -1945.99, 13.55, 0, -1, -1, -1, -1, -1, -1);
		SpawnPlayer(playerid);
		
		SetPVarFloat(playerid, "playerHealth", 100.0);
		SetPVarFloat(playerid, "playerArmour", 000.0);

		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, playerid+21);

		GivePlayerMoneyEx(playerid, 5000);
		GivePlayerBankMoney(playerid, 2500);
		
		TogglePlayerControllable(playerid, 0);
		ClearChat(playerid);
		PreLoadAnims(playerid);
		
		PlayerInfo[playerid][pTruck] = INVALID_VEHICLE_ID;
		PlayerInfo[playerid][pModel] = 299;
		PlayerInfo[playerid][pVW] = playerid+21;
		PlayerInfo[playerid][pInt] = 0;
		LoginStatus[playerid] = 1;

		SetTimerEx("EventHandler", 3000, false, "ii", playerid, EVENT_CREATION_SEX);
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "Your account could not be created!");
		SetTimerEx("KickDelay", 500, false, "i", playerid);
	}
	return 1;
}

public p_AchievementHandler(playerid, type)
{
	new fields, rows, fetch[MAX_INT];
    cache_get_data(rows, fields, gSQLHandle);

  	if(type == 1)
  	{
  		if(rows) {
			cache_get_field_content(0, "AchievementRiskTaker", fetch, gSQLHandle, MAX_INT);
			PlayerInfo[playerid][pAchievementRiskTaker] = strval(fetch);
			cache_get_field_content(0, "AchievementRichMcRich", fetch, gSQLHandle, MAX_INT);
			PlayerInfo[playerid][pAchievementRichMcRich] = strval(fetch);
			cache_get_field_content(0, "AchievementFirstCar", fetch, gSQLHandle, MAX_INT);
			PlayerInfo[playerid][pAchievementFirstCar] = strval(fetch);
			cache_get_field_content(0, "AchievementFirstBiz", fetch, gSQLHandle, MAX_INT);
			PlayerInfo[playerid][pAchievementFirstBiz] = strval(fetch);
			cache_get_field_content(0, "AchievementFirstHouse", fetch, gSQLHandle, MAX_INT);
			PlayerInfo[playerid][pAchievementFirstHouse] = strval(fetch);
			cache_get_field_content(0, "AchievementFirstFaction", fetch, gSQLHandle, MAX_INT);
			PlayerInfo[playerid][pAchievementFirstFaction] = strval(fetch);
			#if defined MRP_DEBUG
				print("Loaded %s's Achievements from the database.", GetPlayerNameEx(playerid));
			#endif
	    }
	    else {
	    	format(query, sizeof(query), "INSERT INTO `user_achievements` (`UserID`) VALUES (%d)", PlayerInfo[playerid][pUserID]);
			mysql_function_query(gSQLHandle, query, false, "p_AchievementHandler", "ii", playerid, 2);
	    }
  	}
  	else {
		PlayerInfo[playerid][pAchievementRiskTaker] = 0;
		PlayerInfo[playerid][pAchievementRichMcRich] = 0;
		PlayerInfo[playerid][pAchievementFirstCar] = 0;
		PlayerInfo[playerid][pAchievementFirstBiz] = 0;
		PlayerInfo[playerid][pAchievementFirstHouse] = 0;
		PlayerInfo[playerid][pAchievementFirstFaction] = 0;
		#if defined MRP_DEBUG
				printf("Added %s's Achievements into the database.", GetPlayerNameEx(playerid));
		#endif
  	}
    return 1;
}

public LoginAccount(playerid)
{
	new fields, rows, fetch[64], string[128];
    cache_get_data(rows, fields, gSQLHandle);
	
	if(rows)
	{
		cache_get_field_content(0, "UserID", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pUserID] = strval(fetch);
		cache_get_field_content(0, "Staff", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pStaff] = strval(fetch);
		cache_get_field_content(0, "Mod", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pMod] = strval(fetch);
		cache_get_field_content(0, "Level", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pLevel] = strval(fetch);
		cache_get_field_content(0, "XP", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pXP] = strval(fetch);
		cache_get_field_content(0, "Disabled", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pDisabled] = strval(fetch);

		// unsure about Ip handling... this is for /ipcheck
		cache_get_field_content(0, "UserIP", PlayerInfo[playerid][pUserIp], gSQLHandle, 16); /* specific string */

		cache_get_field_content(0, "PosX", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pPosX] = floatstr(fetch);
		cache_get_field_content(0, "PosY", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pPosY] = floatstr(fetch);
		cache_get_field_content(0, "PosZ", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pPosZ] = floatstr(fetch);
		cache_get_field_content(0, "PosA", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pPosA] = floatstr(fetch);

		cache_get_field_content(0, "Model", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pModel] = strval(fetch);
		cache_get_field_content(0, "VirtualWorld", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pVW] = strval(fetch);
		cache_get_field_content(0, "Interior", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pInt] = strval(fetch);
		cache_get_field_content(0, "CharacterCreated", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pCreated] = strval(fetch);
		cache_get_field_content(0, "Class", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pClass] = strval(fetch);
		cache_get_field_content(0, "State", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pState] = strval(fetch);
		
		cache_get_field_content(0, "Health", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pHealth] = floatstr(fetch);
		cache_get_field_content(0, "Armour", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pArmour] = floatstr(fetch);
		SetPVarFloat(playerid, "playerHealth", PlayerInfo[playerid][pHealth]);
		SetPVarFloat(playerid, "playerArmour", PlayerInfo[playerid][pArmour]);
		
		cache_get_field_content(0, "MoneyOnHand", fetch, gSQLHandle, MAX_INT); 
		PlayerInfo[playerid][pMoneyOnHand] = strval(fetch);
		cache_get_field_content(0, "BankMoney", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pBankMoney] = strval(fetch);

		cache_get_field_content(0, "AdminName", PlayerInfo[playerid][pAdminName], gSQLHandle, 24); /* specific string */

		cache_get_field_content(0, "ConnectedTotal", fetch, gSQLHandle, MAX_INT); 
		PlayerInfo[playerid][pConnectedTotal] = strval(fetch);
		cache_get_field_content(0, "ConnectedMinutes", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pConnectedMinutes] = strval(fetch);
		cache_get_field_content(0, "pJob", fetch, gSQLHandle, MAX_INT); 
		PlayerInfo[playerid][pJob] = strval(fetch);
		cache_get_field_content(0, "VIP", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pVIP] = strval(fetch);

		cache_get_field_content(0, "Accent", PlayerInfo[playerid][pAccent], gSQLHandle, MAX_INT);
		cache_get_field_content(0, "ACBanned", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pACBanned] = strval(fetch);
		
		cache_get_field_content(0, "Developer", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pDeveloper] = strval(fetch);

		/* Achievements */
		cache_get_field_content(0, "AchievementPoints", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pAchievementPoints] = strval(fetch);
		format(query, sizeof(query), "SELECT * FROM `user_achievements` WHERE `UserID`=%d", PlayerInfo[playerid][pUserID]);
		mysql_function_query(gSQLHandle, query, true, "p_AchievementHandler", "ii", playerid, 1);

		cache_get_field_content(0, "GPS", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pGPS] = strval(fetch);
		cache_get_field_content(0, "TotalPay", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pGPS] = strval(fetch);
		cache_get_field_content(0, "Bills", fetch, gSQLHandle, MAX_INT);
		PlayerInfo[playerid][pBills] = strval(fetch);

		LoginStatus[playerid] = 1;

		PlayerInfo[playerid][pTruck] = INVALID_VEHICLE_ID;

		if(PlayerInfo[playerid][pModel] == 0) {
			PlayerInfo[playerid][pModel] = 299;
			SendClientMessageEx(playerid, COLOR_YELLOW, "Skin: " COL_WHITE "We are sorry, but you cannot have Skin ID 0 and it has been reset to 299 (Claude).");
		}

		if(PlayerInfo[playerid][pPosX] == 0.0 && PlayerInfo[playerid][pPosY] == 0.0)
		{
			SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pModel], 1772.34, -1945.99, 13.55, 0, -1, -1, -1, -1, -1, -1);
			printf("%s was spawned at the default location.", GetPlayerNameEx(playerid));
		}
		else
		{
			SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pModel], PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ], PlayerInfo[playerid][pPosA], -1, -1, -1, -1, -1, -1);
		}
		
		SpawnPlayer(playerid);
		PreLoadAnims(playerid);
		LoadPlayerTextDraws(playerid);

		if(GetState(playerid) == STATE_DEAD && PlayerInfo[playerid][pCreated] != 0)
		{
			SetState(playerid, STATE_ALIVE);
		    SetPlayerPosEx(playerid, 1178.1584, -1323.3243, 14.1063);
			SetPlayerHealth(playerid, 100.0);
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		    SendClientMessageEx(playerid, COLOR_YELLOW, "You have been sent to the hospital.");
		}

		if(GetState(playerid) == 0) /* no state */
		{ 
			SetState(playerid, STATE_ALIVE); 
		}

		SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
		SetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);
		
		SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
		SetPlayerInterior(playerid, PlayerInfo[playerid][pInt]);

		ClearChat(playerid);
		TogglePlayerControllable(playerid, 1);

		format(string, 128, "~w~Welcome back,~n~~r~%s~w~!", GetPlayerNameEx(playerid,1));
		ShowPlayerMessage(playerid, string, 10);
		//GameTextForPlayer(playerid, string, 5000, 1);

		SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);

		if(PlayerInfo[playerid][pCreated] != 1)// if they disconnected during the process, send them through again.
		{
			SetTimerEx("Freeze_Handler", 500, false, "ii", playerid, 0);
			SetTimerEx("EventHandler", 1000, false, "ii", playerid, EVENT_CREATION_SEX);
		}

		/* Touch and I'll string you up and then nullify said string. */
		if(PlayerInfo[playerid][pDeveloper] >= 2) {
			SetPlayerColor(playerid, 0x662266FF);
		}

		//new color = GetPlayerColor(playerid);
		//format(string, sizeof(string), "[Global Message] {%s}%s" COL_WHITE " has logged into the server.", IntToHex(color), GetPlayerNameEx(playerid, 1));
		//SendClientMessageToAll(COLOR_GOLDENROD, string);

		if(PlayerInfo[playerid][pVIP] > 0 && PlayerInfo[playerid][pStaff] < 1) { // no one cares if staff vips log in...
			foreach(Player, i) {
				if(PlayerInfo[i][pVIP] > 0)
					SendClientMessageEx(i, COLOR_OLIVE, "[VIP] %s has logged in as a %s VIP.", GetPlayerNameEx(playerid, 1), GetPlayerVIPStatus(playerid));
			}
		}

		if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
			foreach(Player, i) {
				if(PlayerInfo[i][pStaff] >= PlayerInfo[playerid][pStaff])
					SendClientMessageEx(i, COLOR_YELLOW, "[ADMIN] %s has logged in as a %s.", GetPlayerNameEx(playerid, 1), GetPlayerStaffRank(playerid));
			}
		}

		cache_get_field_content(0, "HasCompleted", fetch, gSQLHandle, 12);
		PlayerInfo[playerid][uHasCompleted] = strval(fetch);

		if(PlayerInfo[playerid][pCreated] != 0) {
			if(server_config_pass && PlayerInfo[playerid][uHasCompleted] != 1) {
				ShowPlayerDialog(playerid, DIALOG_ACMENU_PASS, DIALOG_STYLE_INPUT, "Forced Password Change", "For your security, a forced password change has been enabled.\nPlease enter a new password below: ", "Enter", "");				
			}
		}

		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		format(string, sizeof(string), "%s (%d)", GetPlayerNameEx(playerid, 1), playerid);

		PlayerInfo[playerid][nameTag] = CreateDynamic3DTextLabel(string, COLOR_WHITE, pos[0], pos[1], pos[2]+0.1, 
				10.0, playerid, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 10.0);

		/* TODO: Removable upon finish */
		#if defined _Alpha
			if(PlayerInfo[playerid][pCreated] != 0) {
				ShowPlayerDialog(playerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "Notice", "This server is currently unfinished.\nPlease report any bugs to a Developer (Purple Names) or on the User Control Panel.\nAny complaints will be disregarded relating to this.", "Okay", "");
			}
		#endif
	}
	else
	{
		new info[186], caption[MAX_PLAYER_NAME + 12];	
		format(info, sizeof(info), "{FFFFFF}Welcome back to Monolith Roleplay {1E90FF}%s{FFFFFF}\nPlease enter the password to your account.\n" COL_RED "You have entered the wrong password, please try again.", GetPlayerNameEx(playerid,1));
		format(caption, sizeof(caption), "Login - %s", GetPlayerNameEx(playerid,1));
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, caption, info, "Okay", "Cancel");
	}
	return 1;
}

public SaveUserAccount(playerid, stage)
{
	return (stage == 3) ? printf("User Data: Account ID %i save query finished.", PlayerInfo[playerid][pUserID]) : (1);
}

public EventHandler(playerid, event)
{
	switch(event)
	{
		case EVENT_CREATION_SEX:
		{
			ShowPlayerDialog(playerid, DIALOG_CREATION_ONE, DIALOG_STYLE_MSGBOX, "Creation - Choose Sex", "Please select your sex. (male or female)", "Male", "Female");
		}
		case EVENT_CREATION_SKIN: 
		{
			SendClientMessageEx(playerid, COLOR_YELLOW, "Notice: " COL_WHITE "During alpha, this is the only option");
			ShowPlayerDialog(playerid, DIALOG_CREATION_SKIN, DIALOG_STYLE_LIST, "Skin Selection", "Default Skin (male/female)", "Okay", "");
		}
	}
	return 1;
}

/* this is a callback to allow for calling via timer */
public ClearChat(playerid)
{
	for(new i = 0; i < 11; i++)
		SendClientMessage(playerid, -1, "");
	return 1;
}

public ACMenu_Handler(playerid)
{
	new fields, rows;
    cache_get_data(rows, fields, gSQLHandle);

    /* reused the callback and added this here */
    if(GetPVarInt(playerid, "ChangedPass") == 1) {
    	if(mysql_affected_rows(gSQLHandle)) {
    		SendClientMessageEx(playerid, COLOR_YELLOW, "Notice: " COL_WHITE "You have successfully changed your password.");
    	}
    	else {
    		SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "Your password was not changed.");
    	}
    	DeletePVar(playerid, "ChangedPass");
    	return 1;
    }

    if(rows)
    	ShowPlayerDialog(playerid, DIALOG_ACMENU_MAIN, DIALOG_STYLE_LIST, "Account Menu Options", "Change Password\nClose", "Okay", "");
    else
    	SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You have entered an incorrect password.");
    return 1;
}

public LoadATMs() 
{
	new fields, rows, fetch[64];
    cache_get_data(rows, fields, gSQLHandle);

    for(new i = 0; i < rows; i++) {
    	cache_get_field_content(i, "aID", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aID] = strval(fetch);
		cache_get_field_content(i, "Money", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aMoney] = strval(fetch);
		cache_get_field_content(i, "Disabled", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aDisabled] = strval(fetch);

		cache_get_field_content(i, "PosX", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aPosX] = floatstr(fetch);
		cache_get_field_content(i, "PosY", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aPosY] = floatstr(fetch);
		cache_get_field_content(i, "PosZ", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aPosZ] = floatstr(fetch);
		
		cache_get_field_content(i, "Range", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aRange] = strval(fetch);
		cache_get_field_content(i, "VirtualWorld", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aVW] = strval(fetch);
		cache_get_field_content(i, "Interior", fetch, gSQLHandle, MAX_INT);
		ATMInfo[i][aInt] = strval(fetch);

		if(ATMInfo[i][aPosX] != 0 && ATMInfo[i][aPosY] != 0 && ATMInfo[i][aPosZ] != 0) {
			new text[148];
			if(ATMInfo[i][aDisabled] != 1)
				format(text, sizeof(text), "==ATM==\nStatus:" COL_GREEN " Working\n" COL_GOLDENROD "ATM Balance:" COL_GREEN " $%s\n" COL_GOLDENROD "ID: {FFFFFF}%i", NumFormat(ATMInfo[i][aMoney]), i);
			else
				format(text, sizeof(text), "==ATM==\nStatus:" COL_RED " Damaged\n" COL_GOLDENROD "ATM Balance:" COL_GREEN " $0\n" COL_GOLDENROD "ID: {FFFFFF}%i",i);
			aLabels[i] = CreateDynamic3DTextLabel(text, 0xDAA520FF, ATMInfo[i][aPosX], ATMInfo[i][aPosY], ATMInfo[i][aPosZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ATMInfo[i][aVW], ATMInfo[i][aInt], -1, 10.0);
			ATMInfo[i][aPickup] = CreateDynamicPickup(1239, 1, ATMInfo[i][aPosX], ATMInfo[i][aPosY], ATMInfo[i][aPosZ]);
			//printf("[DEBUG] %i, %i, %i, %.2f, %.2f, %.2f, %i, %i, %i", ATMInfo[i][aID], ATMInfo[i][aMoney], ATMInfo[i][aDisabled], ATMInfo[i][aPosX],
			//	ATMInfo[i][aPosY], ATMInfo[i][aPosZ], ATMInfo[i][aRange], ATMInfo[i][aVW], ATMInfo[i][aInt]);
		
		}
    }
    return 1;
}

public OnSaveATM(i) 
{
	return (!mysql_affected_rows(gSQLHandle)) ? printf("[DEBUG] Failed to affect rows for ATM ID %i.", i) : (1);
}

public LoadDoors() 
{
	new fields, rows, fetch[128];
    cache_get_data(rows, fields, gSQLHandle);

    for(new i = 0; i < rows; i++) {

    	new Float:xa,Float:ya,Float:za;
    	new text[128];

    	cache_get_field_content(i, "dID", fetch, gSQLHandle, MAX_INT);
    	DoorInfo[i][dID] = strval(fetch);
		
		/* Specific Strings */
		cache_get_field_content(i, "dName", DoorInfo[i][dName], gSQLHandle, 64);
		cache_get_field_content(i, "dOwner", DoorInfo[i][dOwner], gSQLHandle, 24);
		
		cache_get_field_content(i, "dOwnable", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dOwnable] = strval(fetch);

		cache_get_field_content(i, "dExteriorX", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dExteriorX] = floatstr(fetch);
		xa = floatstr(fetch);
		cache_get_field_content(i, "dExteriorY", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dExteriorY] = floatstr(fetch);
		ya = floatstr(fetch);
		cache_get_field_content(i, "dExteriorZ", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dExteriorZ] = floatstr(fetch);
		za = floatstr(fetch);
		cache_get_field_content(i, "dExteriorA", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dExteriorA] = floatstr(fetch);
		cache_get_field_content(i, "dInteriorX", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dInteriorX] = floatstr(fetch);
		cache_get_field_content(i, "dInteriorY", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dInteriorY] = floatstr(fetch);
		cache_get_field_content(i, "dInteriorZ", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dInteriorZ] = floatstr(fetch);
		cache_get_field_content(i, "dInteriorA", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dInteriorA] = floatstr(fetch);

		cache_get_field_content(i, "dInt", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dInt] = strval(fetch);
		cache_get_field_content(i, "dVW", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dVW] = strval(fetch);
		cache_get_field_content(i, "dStaff", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dStaff] = strval(fetch);
		cache_get_field_content(i, "dVIP", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dVIP] = strval(fetch);
		cache_get_field_content(i, "dMod", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dMod] = strval(fetch);
		cache_get_field_content(i, "dDisabled", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dDisabled] = strval(fetch);
		cache_get_field_content(i, "dRange", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dRange] = strval(fetch);
		cache_get_field_content(i, "dIntx", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dIntx] = strval(fetch);
		cache_get_field_content(i, "dVWx", fetch, gSQLHandle, MAX_INT);
		DoorInfo[i][dVWx] = strval(fetch);

		if(xa != 0 && ya != 0 && za != 0) {
			if(DoorInfo[i][dOwnable] == 0) {
				if(DoorInfo[i][dDisabled] == 1) {
					format(text, sizeof(text), "%s\nStatus:" COL_RED " Closed\n" COL_GOLDENROD "ID: " COL_WHITE "%i", DoorInfo[i][dName], i);
				}
				else {
					format(text, sizeof(text), "%s\nStatus:" COL_GREEN " Open\n" COL_GOLDENROD "ID: " COL_WHITE "%i", DoorInfo[i][dName], i);
				}
			}
			else {
				if(DoorInfo[i][dDisabled] == 1) {
					format(text, sizeof(text), "%s\nStatus:" COL_RED " Closed\n" COL_GOLDENROD "Owner: " COL_WHITE "%s\n" COL_GOLDENROD "ID: " COL_WHITE "%i", DoorInfo[i][dName], DoorInfo[i][dOwner], i);
				}
				else {
					format(text, sizeof(text), "%s\nStatus:" COL_GREEN " Open\n" COL_GOLDENROD "Owner: " COL_WHITE "%s\n" COL_GOLDENROD "ID: " COL_WHITE "%i", DoorInfo[i][dName], DoorInfo[i][dOwner], i);
				}
			}
			dLabels[i] = CreateDynamic3DTextLabel(text, 0xDAA520FF, xa, ya, za+0.1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DoorInfo[i][dVWx], DoorInfo[i][dIntx], -1, 10.0);
			DoorInfo[i][dPickup] = CreateDynamicPickup(1239, 1, xa, ya, za);
		}
    }
}

public OnSaveDoor(i) 
{
	// this can be an error or just a warning (as if, the door info didn't change, nothing updated)
	return (!mysql_affected_rows(gSQLHandle)) ? printf("[DEBUG] Warning: Failed to affect rows for Door ID %i", i) : (1);
}

public Freeze_Handler(playerid, type)
{
	if(type) {
		TogglePlayerControllable(playerid, 1);
		DeletePVar(playerid, "Frozen");
	}
	else {
		TogglePlayerControllable(playerid, 0);
		SetPVarInt(playerid, "Frozen", 2); // -- script frozen w/o other player interaction.
	}
	return 1;
}

public OnUpdateAdminName(playerid)
{
	return (mysql_affected_rows(gSQLHandle)) 
		? SendClientMessageEx(playerid, COLOR_GREEN, "Success: " COL_WHITE "Your admin name will be displayed to players as %s. You may now go on duty.", GetAdminName(playerid)) 
		: SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "Row not affected.");
}

/* Custom damage is handled in the SPC library, not here. */

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ) 
{
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart) 
{
	return 1;
}

public LoadHelpInfos()
{
	new fields, rows, fetch[MAX_INT];
    cache_get_data(rows, fields, gSQLHandle);

    for(new i = 0; i < rows; i++) {

    	new text[32];

    	cache_get_field_content(i, "infoStr", InfoEnum[i][infoStr], gSQLHandle, 64);

    	if(isnull(InfoEnum[i][infoStr])) continue;

    	cache_get_field_content(i, "infoID", fetch, gSQLHandle, MAX_INT);
    	InfoEnum[i][infoID] = strval(fetch);

    	cache_get_field_content(i, "infoX", fetch, gSQLHandle, MAX_INT);
    	InfoEnum[i][infoPos][0] = floatstr(fetch);
    	cache_get_field_content(i, "infoY", fetch, gSQLHandle, MAX_INT);
    	InfoEnum[i][infoPos][1] = floatstr(fetch);
    	cache_get_field_content(i, "infoZ", fetch, gSQLHandle, MAX_INT);
    	InfoEnum[i][infoPos][2] = floatstr(fetch);

    	format(text, sizeof(text), "Help Icon - Step over for info.");
    	InfoEnum[i][infoLabel] = CreateDynamic3DTextLabel(text, 0xF5DEB3FF, InfoEnum[i][infoPos][0], InfoEnum[i][infoPos][1], InfoEnum[i][infoPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, /* vw */ 0, /* int */ 0, -1, 10.0);
    	InfoEnum[i][infoPickup] = CreateDynamicPickup(1239, 2, InfoEnum[i][infoPos][0], InfoEnum[i][infoPos][1], InfoEnum[i][infoPos][2]-0.4, 0, 0, -1);
    }
	return 1;
}

/* eventually, this will be a handler */
public CallShowAgain(playerid, text[], time)
{
	ShowPlayerMessage(playerid, text, time);
	return 1;
}

public LoadTowers() 
{
	new fields, rows, fetch[MAX_INT], string[128];
    cache_get_data(rows, fields, gSQLHandle);
    for(new i = 0; i < MAX_TOWERS; i++) 
    {
    	cache_get_field_content(i, "towerID", fetch, gSQLHandle, MAX_INT);
    	TowerInfo[i][tID] = strval(fetch);

    	cache_get_field_content(i, "PosX", fetch, gSQLHandle, MAX_INT);
    	TowerInfo[i][tPos][0] = floatstr(fetch);
    	cache_get_field_content(i, "PosY", fetch, gSQLHandle, MAX_INT);
    	TowerInfo[i][tPos][1] = floatstr(fetch);
    	cache_get_field_content(i, "PosZ", fetch, gSQLHandle, MAX_INT);
    	TowerInfo[i][tPos][2] = floatstr(fetch);

    	cache_get_field_content(i, "Range", fetch, gSQLHandle, MAX_INT);
    	TowerInfo[i][tRange] = strval(fetch);

    	cache_get_field_content(i, "Owner", TowerInfo[i][tOwner], gSQLHandle, MAX_INT);

    	cache_get_field_content(i, "Attached", fetch, gSQLHandle, MAX_INT);
    	TowerInfo[i][tAttached] = strval(fetch);

    	if(TowerInfo[i][tPos][0] != 0.0 && TowerInfo[i][tPos][1] != 0.0 && TowerInfo[i][tPos][2] != 0.0) {
    		if(TowerInfo[i][tAttached] != 0) {
    			format(string, sizeof(string), "Cell Tower %d\nOwner: %s\nRange: %d", i, TowerInfo[i][tOwner], TowerInfo[i][tRange]);
    		}
    		else {
    			format(string, sizeof(string), "Cell Tower %d\nOwner: The State\nRange: %d", i, TowerInfo[i][tRange]);
    		}
    		TowerInfo[i][towerLabel] = CreateDynamic3DTextLabel(string, COLOR_TAN, TowerInfo[i][tPos][0], TowerInfo[i][tPos][1], TowerInfo[i][tPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, /* vw */ 0, /* int */ 0, -1, 10.0);
    	}
    }
}
 
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(response)
    {
        SendClientMessage(playerid, COLOR_YELLOW, "Attached object edition saved.");
 
        ao[playerid][index][ao_x] = fOffsetX;
        ao[playerid][index][ao_y] = fOffsetY;
        ao[playerid][index][ao_z] = fOffsetZ;
        ao[playerid][index][ao_rx] = fRotX;
        ao[playerid][index][ao_ry] = fRotY;
        ao[playerid][index][ao_rz] = fRotZ;
        ao[playerid][index][ao_sx] = fScaleX;
        ao[playerid][index][ao_sy] = fScaleY;
        ao[playerid][index][ao_sz] = fScaleZ;
    }
    else
    {
        SendClientMessageEx(playerid, COLOR_YELLOW, "Attached object edition not saved.");
 
        new i = index;
        SetPlayerAttachedObject(playerid, index, modelid, boneid, ao[playerid][i][ao_x], ao[playerid][i][ao_y], ao[playerid][i][ao_z], ao[playerid][i][ao_rx], ao[playerid][i][ao_ry], ao[playerid][i][ao_rz], ao[playerid][i][ao_sx], ao[playerid][i][ao_sy], ao[playerid][i][ao_sz]);
    }
    return 1;
}