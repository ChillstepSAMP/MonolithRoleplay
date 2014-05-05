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

GetPlayerIpEx(playerid)
{
	new UserIp[16];
	GetPlayerIp(playerid, UserIp, sizeof(UserIp));
	return UserIp;
}

GetPlayerNameEx(playerid, type=0)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	if(type == 1) 
	{
		for(new i = 0; i < sizeof(name); i++)
		{
			if(name[i] == '_')
			{
				name[i] = ' ';
			}
		}
	}
	return name;
}

/*SendClientMessageEx(playerid, color, message[], va_args<>) 
{	
	va_format(va_str, 128, message, va_start<3>);
	return SendClientMessage(playerid, color, va_str);
}*/

Log(file[], io_input[], va_args<>) 
{

	new string[256], date[2][3];
	new File: fileHandle = fopen(file, io_append);
	
	va_format(va_str, 128, io_input, va_start<2>);

	gettime(date[0][0], date[0][1], date[0][2]);
	getdate(date[1][0], date[1][1], date[1][2]);
	format(string, sizeof(string), "[%i/%i/%i - %i:%i:%i] %s\r\n", date[1][2], date[1][1], date[1][0], date[0][0], date[0][1], date[0][2], va_str);
	fwrite(fileHandle, string);
	return fclose(fileHandle);
}

ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)// no credit taken, I did not make this.
{
    if(IsPlayerConnected(playerid))
    {
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && LoginStatus[playerid] != 0)
            {
                if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
                {
                    GetPlayerPos(i, posx, posy, posz);
                    tempposx = (oldposx -posx);
                    tempposy = (oldposy -posy);
                    tempposz = (oldposz -posz);
                    if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
                    {
                        SendClientMessageEx(i, col1, string);
                    }
                    else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
                    {
                        SendClientMessageEx(i, col2, string);
                    }
                    else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
                    {
                        SendClientMessageEx(i, col3, string);
                    }
                    else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
                    {
                        SendClientMessageEx(i, col4, string);
                    }
                    else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
                    {
                        SendClientMessageEx(i, col5, string);
                    }
                }
            }
        }
    }
    return 1;
}

strcmpEx(cmp[], cmp2[])
{
	if(!strcmp(cmp, cmp2, true)) return 1;
	else return 0;
}

BeginSaveUser(playerid)
{
	#define i[%0] PlayerInfo[playerid][%0]

	GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
	GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);

	GetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);

	format(query, sizeof(query), "UPDATE `user_accounts` SET `Staff`= %i,\ 
	`Mod`= %i,\
	`Level`= %i,\
	`XP`= %i,\
	`Disabled`= %i,\
	`UserIP`= '%s',\
	`PosX` = %f,\
	`PosY` = %f,\
	`PosZ` = %f,\
	`PosA` = %f,\
	`Model` = %i,\
	`VirtualWorld` = %i,\
	`Interior` = %i WHERE `UserID` = %i",
		i[pStaff], i[pMod], i[pLevel], i[pXP], i[pDisabled], i[pUserIp],
		i[pPosX], i[pPosY], i[pPosZ], i[pPosA], i[pModel], i[pVW], i[pInt], i[pUserID]);
	mysql_function_query(gSQLHandle, query, false, "SaveUserAccount", "ii", playerid, 1);

	format(query, sizeof(query), "UPDATE `user_accounts` SET `CharacterCreated`=%i,\
	`Class`=%i,\
	`State`=%i,\
	`Health`=%f,\
	`Armour`=%f,\
	`Sex`=%i,\
	`ACLock`=%i,\
	`MoneyOnHand`=%i,\
	`BankMoney`=%i,\
	`ConnectedTotal`=%i,\
	`ConnectedMinutes`=%i,\
	`pJob`=%i WHERE `UserID` = %i",
		i[pCreated], i[pClass], i[pState], i[pHealth], i[pArmour], i[pSex], 
		i[pACLock], i[pMoneyOnHand], i[pBankMoney], i[pConnectedTotal], i[pConnectedMinutes], i[pJob], i[pUserID]);
	mysql_function_query(gSQLHandle, query, false, "SaveUserAccount", "ii", playerid, 2);

	format(query, sizeof(query), "UPDATE `user_accounts` SET `VIP`=%d,\
	`Accent`='%s',\
	`ACBanned`=%d,\
	`AchievementPoints`=%d,\
	`GPS`=%d,\
	`TotalPay`=%d,\
	`Bills`=%d,\
	`HouseKey1`=%d WHERE `UserID` = %d",
		i[pVIP], i[pAccent], i[pACBanned], i[pAchievementPoints],
		i[pGPS], i[pTotalPay], i[pBills], i[pHouseKey1], i[pUserID]);
	mysql_function_query(gSQLHandle, query, false, "SaveUserAccount", "ii", playerid, 3);
	#undef i
	return 1;
}

ResetPlayer(playerid)
{
	for(new i = 0; pInfo:i < pInfo; i++)// credits to [Diablo]
	{
    	 PlayerInfo[playerid][pInfo:i] = 0;
	}
	DeletePVar(playerid, "AdminDuty");
	return 1;
}


SetPlayerHealthEx(playerid, Float:health)
{
	SetPVarFloat(playerid, "playerHealth", health);
	SetPlayerHealth(playerid, health);
	return 1;
}

SetPlayerArmourEx(playerid, Float:armour)
{
	SetPVarFloat(playerid, "playerArmour", armour);
	SetPlayerArmour(playerid, armour);
	return 1;
}

InvalidChar(text[])
{
	if(strfind(text, "'", true) != -1 || strfind(text, "`", true) != -1 
		|| strfind(text, ",", true) != -1) return 1;
	return 0;
}

TextIPCheck(playerid, text[])
{
	new dots;
	new underscores;
	new nums;
	for(new i = 0, j = strlen(text); i < j; i++) {
		if(text[i] == '.') 
			dots++;
		else if(text[i] == '_')
			underscores++;
		else if(isNum(text[i]))
			nums++;
	}
	
	if(dots >= 3 && PlayerInfo[playerid][pStaff] <= STAFF_ADMIN) {
		foreach(Player, i) {
			if(PlayerInfo[i][pStaff] >= STAFF_ADMIN)
				SendClientMessageEx(i, COLOR_RED, "AdmWarn: " COL_YELLOW "%s has possibly entered an IP: %s", GetPlayerNameEx(playerid,1), text);
		}
		return 1;
	}
	else if(underscores >= 3 && PlayerInfo[playerid][pStaff] <= STAFF_ADMIN) {
		foreach(Player, i) {
			if(PlayerInfo[i][pStaff] >= STAFF_ADMIN)
				SendClientMessageEx(i, COLOR_RED, "AdmWarn: " COL_YELLOW "%s has possibly entered an IP: %s", GetPlayerNameEx(playerid,1), text);
		}
		return 1;
	}
	else if(nums >= 10 && PlayerInfo[playerid][pStaff] <= STAFF_ADMIN) {
		foreach(Player, i) {
			if(PlayerInfo[i][pStaff] >= STAFF_ADMIN)
				SendClientMessageEx(i, COLOR_RED, "AdmWarn: " COL_YELLOW "%s has possibly entered an IP: %s", GetPlayerNameEx(playerid,1), text);
		}
		return 1;
	}
	return 0;
}

isNum(text[])
{
	for (new i = 0, j = strlen(text); i < j; i++)
	{
		if (text[i] > '9' || text[i] < '0') return 0;
	}
	return 1;
}

ResetMPacket(id)
{
	for(new i = 0; mpInfo:i < mpInfo; i++)
	{
    	 MoneyPacket[id][mpInfo:i] = -1;
	}
	return 1;
}

NextMoneyID()
{
	for(new i = 1; i < MAX_MIDS; i++) {
		if(MoneyPacket[i][mUsed] == -1) {
			return i;
		}
	}
	return -1;
}

DropPlayerMoney(playerid) {

	new Float:PlayerPos[3];
	GetPlayerPos(playerid, PlayerPos[0], PlayerPos[1], PlayerPos[2]);

	new id = NextMoneyID(); // get the ID of next unused packet
	new rand = random(100);
	new amount;
	
	if(PlayerInfo[playerid][pMoneyOnHand] >= 25000) {
		switch(rand) {
			case 0 .. 50: {
				amount = 775;
			}
			case 51 .. 99: {
				amount = 900;
			}
			default: {
				amount = 600;
			}
		}
	}
	else {
		switch(rand) {
			case 0 .. 50: {
				amount = 635;
			}
			case 51 .. 99: {
				amount = 700;
			}
			default: {
				amount = 400;
			}
		}
	}
	
	if(id != -1) { // error handling
		MoneyPacket[id][mUsed] = 1; // omfg
		MoneyPacket[id][mID] = CreateDynamicPickup(1212, 1, PlayerPos[0], PlayerPos[1]+0.5, PlayerPos[2]-0.6, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 45.0);
		MoneyPacket[id][mCash] = amount;
		MoneyPacket[id][mTimer] = gettime()+3; // allow for player to walk off the cash so he doesn't insta pick it back up.
		MoneyPacket[id][mLifeSpan] = gettime()+120; // 120 second life-span before being destroyed.
		#if defined MRP_DEBUG
			printf("[DEBUG] ID: %i, ID: %i, Amt:%s, Time: %i, Span: %i", id, MoneyPacket[id][mID], NumFormat(MoneyPacket[id][mCash]), MoneyPacket[id][mTimer], MoneyPacket[id][mLifeSpan]);
		#endif
		GivePlayerMoneyEx(playerid, -amount);
	}
	else {
		printf("Attempted to drop %i for Player %s but failed!", amount, GetPlayerNameEx(playerid, 1));
	}
	return 1;
}

DestroyMPacket(packetid) {
	if(IsValidDynamicPickup(MoneyPacket[packetid][mID]))
		DestroyDynamicPickup(MoneyPacket[packetid][mID]);
	MoneyPacket[packetid][mCash] = -1;
	MoneyPacket[packetid][mUsed] = -1;
	MoneyPacket[packetid][mLifeSpan] = -1;
	return 1;
}

GivePlayerMoneyEx(playerid, money) {
	PlayerInfo[playerid][pMoneyOnHand] += money;
	return GivePlayerMoney(playerid, money);
}

GivePlayerBankMoney(playerid, money) {
	return PlayerInfo[playerid][pBankMoney] += money;
}

NumFormat(number) {
    new tStr[13];
 
    format(tStr, sizeof(tStr), "%i", number);
 
    if(strlen(tStr) < 4)
 		return tStr;
 
    new iPos = strlen(tStr), iCount = 1;
 
    while(iPos > 0) {
		if(iCount == 4) {
			iCount = 0;
			strins(tStr, ",", iPos, 1);
			iPos++;
		}
        iCount++;
        iPos--;
    }
    return tStr;
}

ResetMoneyBar(playerid) {
	new amt = GetPlayerMoney(playerid);
	GivePlayerMoney(playerid, -amt);
	GivePlayerMoney(playerid, PlayerInfo[playerid][pMoneyOnHand]);
	return 1;
}

OnLoadATMs() {
	format(query, sizeof(query), "SELECT * FROM `sys_atms`");
	mysql_function_query(gSQLHandle, query, false, "LoadATMs", "");
	print("[DEBUG] Loading ATMs...");
	return 1;
}

SaveATM(i) 
{
	#define a[%0] ATMInfo[i][%0]
	format(query, sizeof(query), "UPDATE `sys_atms` SET `Money`=%i,\
		`Disabled`=%i,\
		`PosX`=%f,\
		`PosY`=%f,\
		`PosZ`=%f,\
		`Range`=%i,\
		`VirtualWorld`=%i,\
		`Interior`=%i WHERE `aID`=%i",
		a[aMoney],
		a[aDisabled],
		a[aPosX],
		a[aPosY],
		a[aPosZ],
		a[aRange],
		a[aVW],
		a[aInt],
		a[aID]
	);
	mysql_function_query(gSQLHandle, query, false, "OnSaveATM", "i", i); // i - the id
	#undef a
	return 1;
}

OnLoadDoors() 
{
	format(query, sizeof(query), "SELECT * FROM `sys_doors`");
	mysql_function_query(gSQLHandle, query, false, "LoadDoors", "");
	print("[DEBUG] Loading Doors...");
	return 1;
}

SaveDoor(i) 
{
	#define d[%0] DoorInfo[i][%0]
	format(query, sizeof(query), "UPDATE `sys_doors` SET `dName`='%s',\
		`dOwner`='%s',\
		`dOwnable`=%i,\
		`dExteriorX`=%f,\
		`dExteriorY`=%f,\
		`dExteriorZ`=%f,\
		`dExteriorA`=%f,\
		`dInteriorX`=%f,\
		`dInteriorY`=%f,\
		`dInteriorZ`=%f,\
		`dInteriorA`=%f,\
		`dInt`=%i,\
		`dVW`=%i,\
		`dStaff`=%i,\
		`dVIP`=%i,\
		`dMod`=%i,\
		`dDisabled`=%i,\
		`dRange`=%i WHERE `dID` = %i",
		d[dName],
		d[dOwner],
		d[dOwnable],
		d[dExteriorX],
		d[dExteriorY],
		d[dExteriorZ],
		d[dExteriorA],
		d[dInteriorX],
		d[dInteriorY],
		d[dInteriorZ],
		d[dInteriorA],
		d[dInt],
		d[dVW],
		d[dStaff],
		d[dVIP],
		d[dMod],
		d[dDisabled],
		d[dRange],
		d[dID]
	);
	mysql_function_query(gSQLHandle, query, false, "OnSaveDoor", "i", i);
	#undef d
	return 1;
}

/*
	@params status
		STATUS:
			1. Entering
			2. Exiting
*/
EnterExitFunc(playerid, id, status, type)
{
	if(status == 1) {
		switch(type) {
			case TYPE_DOOR: {
				SetPlayerInterior(playerid, DoorInfo[id][dInt]);
				SetPlayerVirtualWorld(playerid, DoorInfo[id][dVW]);
				SetPlayerPosEx(playerid, DoorInfo[id][dInteriorX], DoorInfo[id][dInteriorY], DoorInfo[id][dInteriorZ]);
				SetPlayerFacingAngle(playerid, DoorInfo[id][dInteriorA]);

				// StreamPrep(playerid);
				GameTextForPlayer(playerid, "~r~Loading...", 4000, 1);
				TogglePlayerControllable(playerid, 0);
				SetTimerEx("Freeze_Handler", 5000, false, "i", playerid);
				//defer Freeze_Handler(playerid);
			}
			case TYPE_GARAGE: {}
			case TYPE_HOUSE: {

				if(HouseInfo[id][houseLock] == 1) {
					ShowPlayerMessage(playerid, "~r~Locked", 3);
					return 1;
				}

				SetPlayerInterior(playerid, HouseInfo[id][houseInterior]);
				SetPlayerVirtualWorld(playerid, HouseInfo[id][houseVirtualWorld]);
				SetPlayerPosEx(playerid, HouseInfo[id][houseInt][0], HouseInfo[id][houseInt][1], HouseInfo[id][houseInt][2]);
				SetPlayerFacingAngle(playerid, HouseInfo[id][houseInt][3]);
				GameTextForPlayer(playerid, "~r~Loading...", 4000, 1);
				TogglePlayerControllable(playerid, 0);
				SetTimerEx("Freeze_Handler", 5000, false, "i", playerid);
			}
			case TYPE_BUSINESS: {}
			case TYPE_BANK: {}
		}
	}
	else {
		switch(type) {
			case TYPE_DOOR: {
				SetPlayerInterior(playerid, DoorInfo[id][dIntx]);
				SetPlayerVirtualWorld(playerid, DoorInfo[id][dVWx]);
				SetPlayerPosEx(playerid, DoorInfo[id][dExteriorX], DoorInfo[id][dExteriorY], DoorInfo[id][dExteriorZ]);
				SetPlayerFacingAngle(playerid, DoorInfo[id][dExteriorA]);

				// StreamPrep(playerid);
				GameTextForPlayer(playerid, "~r~Loading...", 4000, 1);
				
				TogglePlayerControllable(playerid, 0);
				
				SetTimerEx("Freeze_Handler", 5000, false, "ii", playerid, 1);
				//defer Freeze_Handler(playerid);
			}
			case TYPE_GARAGE: {}
			case TYPE_HOUSE: {
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerPosEx(playerid, HouseInfo[id][houseExt][0], HouseInfo[id][houseExt][1], HouseInfo[id][houseExt][2]);
				SetPlayerFacingAngle(playerid, HouseInfo[id][houseExt][3]);
				GameTextForPlayer(playerid, "~r~Loading...", 4000, 1);
				TogglePlayerControllable(playerid, 0);
				SetTimerEx("Freeze_Handler", 5000, false, "i", playerid);
			}
			case TYPE_BUSINESS: {}
			case TYPE_BANK: {}
		}
	}
	UpdatePlayerTag(playerid);
	return 1;
}

SetPlayerPosEx(playerid, Float:x, Float:y, Float:z)
{
	PlayerInfo[playerid][pPosX] = x;
	PlayerInfo[playerid][pPosY] = y;
	PlayerInfo[playerid][pPosZ] = z;
	return SetPlayerPos(playerid, x, y, z);
}

/*stock StreamPrep(playerid) 
{ 
	// TD CODE HERE // 
	defer Freeze_Handler(playerid);
	return 1;
}*/

UpdateDoorLabel(i, moved = 0) 
{
	new text[128];
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
	if(!moved) {
		UpdateDynamic3DTextLabelText(dLabels[i], 0xDAA520FF, text);
	}
	else {
		DestroyDynamicPickup(DoorInfo[i][dPickup]);
		DestroyDynamic3DTextLabel(dLabels[i]);
		dLabels[i] = CreateDynamic3DTextLabel(text, 0xDAA520FF, DoorInfo[i][dExteriorX], DoorInfo[i][dExteriorY], DoorInfo[i][dExteriorZ]+0.1, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DoorInfo[i][dVWx], DoorInfo[i][dIntx], -1, 10.0);
		DoorInfo[i][dPickup] = CreateDynamicPickup(1239, 1, DoorInfo[i][dExteriorX], DoorInfo[i][dExteriorY], DoorInfo[i][dExteriorZ]);
	}
	return 1;
}

UpdateATMLabel(i, moved = 0) {
	new text[148];
	if(ATMInfo[i][aDisabled] != 1) {
		format(text, sizeof(text), "==ATM==\nStatus:" COL_GREEN " Working\n" COL_GOLDENROD "ATM Balance:" COL_GREEN " $%s\n" COL_GOLDENROD "ID: {FFFFFF}%i", NumFormat(ATMInfo[i][aMoney]), i);
	}
	else {
		format(text, sizeof(text), "==ATM==\nStatus:" COL_RED " Damaged\n" COL_GOLDENROD "ATM Balance:" COL_GREEN " $0\n" COL_GOLDENROD "ID: {FFFFFF}%i",i);
	}
	if(!moved) {
		UpdateDynamic3DTextLabelText(aLabels[i], 0xDAA520FF, text);
	}
	else {
		DestroyDynamicPickup(ATMInfo[i][aPickup]);
		DestroyDynamic3DTextLabel(aLabels[i]);
		aLabels[i] = CreateDynamic3DTextLabel(text, 0xDAA520FF, ATMInfo[i][aPosX], ATMInfo[i][aPosY], ATMInfo[i][aPosZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ATMInfo[i][aVW], ATMInfo[i][aInt], -1, 10.0);
		ATMInfo[i][aPickup] = CreateDynamicPickup(1239, 1, ATMInfo[i][aPosX], ATMInfo[i][aPosY], ATMInfo[i][aPosZ]);
	}
	return 1;
}

stock IntToHex(num)
{
	new i, padlen, retNum[7];
	
	format(retNum, sizeof(retNum), "%x", num);
	padlen = (6 - strlen(retNum));
	
	while (i++ != padlen) {
		strins(retNum, "0", 0, 7);
	}
	return retNum;
}

ExpHandler(playerid, newxp)
{
	#define level PlayerInfo[playerid][pLevel]
	PlayerInfo[playerid][pXP] += newxp;
	if(PlayerInfo[playerid][pXP] > CalcExp(level)) {
		level += 1;
		ShowPlayerMessage(playerid, "~g~Level Up:~w~You have leveled up!");
		SendClientMessageEx(playerid, COLOR_GREEN, "Level Up: " COL_WHITE "You have leveled up to %d. Experience to next level: %d", level, CalcExp(level));
	}
	#undef level
	return 1;
}

LoadPlayerTextDraws(playerid)
{
	/* 
		Player Textdraw Developers:
			(*) Scaleta - ShowPlayerMessage TD
	*/

	// ShowPlayerMessage() TD
	PlayerInfo[playerid][pTDInfo] = TextDrawCreate(320.000000, 400.000000, " ");
	TextDrawAlignment(PlayerInfo[playerid][pTDInfo], 2);
	TextDrawBackgroundColor(PlayerInfo[playerid][pTDInfo], 255);
	TextDrawFont(PlayerInfo[playerid][pTDInfo], 1);
	TextDrawLetterSize(PlayerInfo[playerid][pTDInfo], 0.349999, 1.700000);
	TextDrawColor(PlayerInfo[playerid][pTDInfo], -1);
	TextDrawSetOutline(PlayerInfo[playerid][pTDInfo], 1);
	TextDrawSetProportional(PlayerInfo[playerid][pTDInfo], 1);
	return 1;
}

ShowPlayerMessage(playerid, text[], time=10)
{
	if(GetPVarInt(playerid, "TDToHide") == 1) { // will call until the other is gone.
		SetTimerEx("CallShowAgain", 2000, false, "is[128]i", playerid, text, time);
		return 1;
	}

	new substr[128];
	format(substr, sizeof(substr), "%s", text);

	if(PlayerInfo[playerid][pTDTime] != 0) { /* Add this little check to destroy anything still being displayed */
		TextDrawHideForPlayer(playerid, PlayerInfo[playerid][pTDInfo]);
		PlayerInfo[playerid][pTDTime] = 0;
	}

	TextDrawSetString(PlayerInfo[playerid][pTDInfo], substr);
	TextDrawShowForPlayer(playerid, PlayerInfo[playerid][pTDInfo]);
		
	PlayerInfo[playerid][pTDTime] = gettime()+time;
	return 1;
}

GetPlayerStaffRank(playerid, devcheck=0)
{
	new rank[32];
	if(PlayerInfo[playerid][pStaff] > 0 && devcheck != 1) {
		switch(PlayerInfo[playerid][pStaff]) {
			case STAFF_ADMIN: strcpy(rank, "Admin");
			case STAFF_SADMIN: strcpy(rank, "Senior Admin");
			case STAFF_LADMIN: strcpy(rank, "Lead Admin");
			case STAFF_HADMIN: strcpy(rank, "Head Admin");
			default: strcpy(rank, "Unknown Admin");
		}

	}
	else if(PlayerInfo[playerid][pDeveloper] > 0 && devcheck != 1) {
		switch(PlayerInfo[playerid][pDeveloper]) {
			case 1: strcpy(rank, "Mapper");
			case 2: strcpy(rank, "Mapping Director");
			case 3: strcpy(rank, "Scripter");
			case 4: strcpy(rank, "Senior Scripter");
			case 1337: strcpy(rank, "Development Director");
		}
	}
	else if(PlayerInfo[playerid][pMod] > 0 && devcheck != 1) {
		strcpy(rank, "Player Mod");
	}
	else {
		strcpy(rank, "Player");
	}
	if(devcheck) {
		switch(PlayerInfo[playerid][pDeveloper])
		{
			case 0: strcpy(rank, "None");
			case 1: strcpy(rank, "Mapper");
			case 2: strcpy(rank, "Mapping Director");
			case 3: strcpy(rank, "Scripter");
			case 4: strcpy(rank, "Senior Scripter");
			case 1337: strcpy(rank, "Development Director");
		}
	}
	return rank;
}

GetPlayerVIPStatus(playerid)
{
	new vip[32];
	if(PlayerInfo[playerid][pVIP] > 0) {
		switch(PlayerInfo[playerid][pVIP]) {
			case 1: strcpy(vip, "Bandit");
			case 2: strcpy(vip, "Rogue");
			case 3: strcpy(vip, "Hero");
			case 4: strcpy(vip, "VIP Mod");
		}
	}
	else {
		strcpy(vip, "None");
	}
	return vip;
}

SaveHelpInfo(i)
{
	#define en[%0] InfoEnum[i][%0]
	format(query, sizeof(query), "UPDATE `helpinfos` SET `infoX`=%.2f, `infoY`=%.2f, `infoZ`=%.2f, `infoStr`='%s' WHERE `infoID` = %d",
		en[infoPos][0],
		en[infoPos][1],
		en[infoPos][2],
		en[infoStr],
		en[infoID]
	);
	mysql_function_query(gSQLHandle, query, false, "FinishQuery", "");
	#undef en
	return 1;
}

SaveTower(i)
{
	format(query, sizeof(query), "UPDATE `cell_towers` SET `PosX`=%.2f, `PosY`=%.2f, `PosZ`=%.2f, `Range`=%d, `Owner`='%s',\
		`Attached`=%d WHERE `towerID`=%d",
		TowerInfo[i][tPos][0],
		TowerInfo[i][tPos][1],
		TowerInfo[i][tPos][2],
		TowerInfo[i][tRange],
		TowerInfo[i][tOwner],
		TowerInfo[i][tAttached],
		TowerInfo[i][tID]
	);
	mysql_function_query(gSQLHandle, query, false, "FinishQuery", "");
	return 1;
}

GetDistanceBetweenPoints(Float:x, Float:y, Float:z, Float:xa, Float:ya, Float:za) 
{
    return floatround(floatsqroot(floatpower(x - xa, 2) + floatpower(y - ya, 2) + floatpower(z - za, 2)));
}

GetVehicleDriver(vehicleid)
{
	foreach(Player, i) {
	    if (GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER) return i;
	}
	return INVALID_PLAYER_ID;
}

CreateServerTextDraws()
{
	/* 
		Textdraw Developers:
			(*) Shane - Achievement TD
	*/
	
	// Achievement Box
	AchievementTD[0] = TextDrawCreate(186.000000, 345.000000, "Box");
	TextDrawBackgroundColor(AchievementTD[0], 0);
	TextDrawFont(AchievementTD[0], 1);
	TextDrawLetterSize(AchievementTD[0], 1.590000, 7.700005);
	TextDrawColor(AchievementTD[0], 0);
	TextDrawSetOutline(AchievementTD[0], 0);
	TextDrawSetProportional(AchievementTD[0], 1);
	TextDrawSetShadow(AchievementTD[0], 1);
	TextDrawUseBox(AchievementTD[0], 1);
	TextDrawBoxColor(AchievementTD[0], 100);
	TextDrawTextSize(AchievementTD[0], 454.000000, 18.000000);
	
	// Message
	AchievementTD[1] = TextDrawCreate(317.000000, 338.000000, "Achievement Unlocked");
	TextDrawAlignment(AchievementTD[1], 2);
	TextDrawBackgroundColor(AchievementTD[1], 255);
	TextDrawFont(AchievementTD[1], 2);
	TextDrawLetterSize(AchievementTD[1], 0.189999, 1.200000);
	TextDrawColor(AchievementTD[1], -1);
	TextDrawSetOutline(AchievementTD[1], 1);
	TextDrawSetProportional(AchievementTD[1], 1);
	
	// Title
	AchievementTD[2] = TextDrawCreate(323.000000, 360.000000, " ");
	TextDrawAlignment(AchievementTD[2], 2);
	TextDrawBackgroundColor(AchievementTD[2], 255);
	TextDrawFont(AchievementTD[2], 2);
	TextDrawLetterSize(AchievementTD[2], 0.449999, 2.000000);
	//TextDrawLetterSize(AchievementTD[2], 0.529999, 2.800000);
	TextDrawColor(AchievementTD[2], -1);
	TextDrawSetOutline(AchievementTD[2], 1);
	TextDrawSetProportional(AchievementTD[2], 1);
	
	// Description.
	AchievementTD[3] = TextDrawCreate(322.000000, 385.000000, " ");
	TextDrawAlignment(AchievementTD[3], 2);
	TextDrawBackgroundColor(AchievementTD[3], 255);
	TextDrawFont(AchievementTD[3], 1);
	TextDrawLetterSize(AchievementTD[3], 0.189999, 1.200000);
	TextDrawColor(AchievementTD[3], -1);
	TextDrawSetOutline(AchievementTD[3], 1);
	TextDrawSetProportional(AchievementTD[3], 1);
	return 1;
}

HideAchievementGUIFrame(playerid)
{
	for(new i = 0; i < 4; i++)
	{
		TextDrawHideForPlayer(playerid, AchievementTD[i]);
	}
	return 1;
}

AchievementHandler(playerid, achievement, points)
{
	if(PlayerInfo[playerid][pTDTime] != 0) { // no conflicts.
		TextDrawHideForPlayer(playerid, PlayerInfo[playerid][pTDInfo]);
		PlayerInfo[playerid][pTDTime] = 0;
	}
	
	switch(achievement) {
		case A_RISKTAKER: {
			TextDrawShowForPlayer(playerid, AchievementTD[0]);
			TextDrawShowForPlayer(playerid, AchievementTD[1]);
			TextDrawSetString(AchievementTD[2], "Risk Taker");
			TextDrawShowForPlayer(playerid, AchievementTD[2]);
			TextDrawSetString(AchievementTD[3], "You're carrying more cash than you can handle!~n~~g~+2~w~ Achievement Points");
			TextDrawShowForPlayer(playerid, AchievementTD[3]);
			PlayerInfo[playerid][pAchievementRiskTaker] = 1;
		}
		case A_RICH: {
			TextDrawShowForPlayer(playerid, AchievementTD[0]);
			TextDrawShowForPlayer(playerid, AchievementTD[1]);
			TextDrawSetString(AchievementTD[2], "RichMcRich");
			TextDrawShowForPlayer(playerid, AchievementTD[2]);
			TextDrawSetString(AchievementTD[3], "You seem to be in the top one percent!~n~~g~+8~w~ Achievement Points");
			TextDrawShowForPlayer(playerid, AchievementTD[3]);
			PlayerInfo[playerid][pAchievementRichMcRich] = 1;
		}
		case A_FIRSTCAR: {
			TextDrawShowForPlayer(playerid, AchievementTD[0]);
			TextDrawShowForPlayer(playerid, AchievementTD[1]);
			TextDrawSetString(AchievementTD[2], "First Car");
			TextDrawShowForPlayer(playerid, AchievementTD[2]);
			TextDrawSetString(AchievementTD[3], "You have acquired your first vehicle!~n~~g~+2~w~ Achievement Points");
			TextDrawShowForPlayer(playerid, AchievementTD[3]);
			PlayerInfo[playerid][pAchievementFirstCar] = 1;
		}
		case A_BIZMAN: {
			TextDrawShowForPlayer(playerid, AchievementTD[0]);
			TextDrawShowForPlayer(playerid, AchievementTD[1]);
			TextDrawSetString(AchievementTD[2], "Business Man");
			TextDrawShowForPlayer(playerid, AchievementTD[2]);
			TextDrawSetString(AchievementTD[3], "You have acquired your very own business!~n~~g~+5~w~ Achievement Points");
			TextDrawShowForPlayer(playerid, AchievementTD[3]);
			PlayerInfo[playerid][pAchievementFirstBiz] = 1;
		}
		case A_FAMILYMAN: {
			TextDrawShowForPlayer(playerid, AchievementTD[0]);
			TextDrawShowForPlayer(playerid, AchievementTD[1]);
			TextDrawSetString(AchievementTD[2], "Family Man");
			TextDrawShowForPlayer(playerid, AchievementTD[2]);
			TextDrawSetString(AchievementTD[3], "You have acquired your first home to sleep in!~n~~g~+5~w~ Achievement Points");
			TextDrawShowForPlayer(playerid, AchievementTD[3]);
			PlayerInfo[playerid][pAchievementFirstHouse] = 1;
		}	
		case A_FACTION: {
			TextDrawShowForPlayer(playerid, AchievementTD[0]);
			TextDrawShowForPlayer(playerid, AchievementTD[1]);
			TextDrawSetString(AchievementTD[2], "Faction Kinda-Guy");
			TextDrawShowForPlayer(playerid, AchievementTD[2]);
			TextDrawSetString(AchievementTD[3], "You have stepped up and joined the ranks of a faction!~n~~g~+2~w~ Achievement Points");
			TextDrawShowForPlayer(playerid, AchievementTD[3]);
			PlayerInfo[playerid][pAchievementFirstFaction] = 1;
		}
		case A_MEETANDGREET: {
			TextDrawShowForPlayer(playerid, AchievementTD[0]);
			TextDrawShowForPlayer(playerid, AchievementTD[1]);
			TextDrawSetString(AchievementTD[2], "Meet and Greet");
			TextDrawShowForPlayer(playerid, AchievementTD[2]);
			TextDrawSetString(AchievementTD[3], "You have met the developer of this fine establishment!~n~~g~+2~w~ Achievement Points");
			TextDrawShowForPlayer(playerid, AchievementTD[3]);
			PlayerInfo[playerid][pAchievementMeetAndGreet] = 1;
		}
	}
	SetPVarInt(playerid, "TDToHide", 1);
	PlayerInfo[playerid][pTDTime] = gettime()+10;
	PlayerInfo[playerid][pAchievementPoints] += points;
	SavePlayerAchievements(playerid);
	return 1;
}

SavePlayerAchievements(playerid)
{
	format(query, sizeof(query), "UPDATE `user_achievements` SET `AchievementRiskTaker`=%d,\
		`AchievementRichMcRich`=%d,\
		`AchievementFirstCar`=%d,\
		`AchievementFirstBiz`=%d,\
		`AchievementFirstHouse`=%d,\
		`AchievementFirstFaction`=%d WHERE `UserID`=%d",
		PlayerInfo[playerid][pAchievementRiskTaker],
		PlayerInfo[playerid][pAchievementRichMcRich],
		PlayerInfo[playerid][pAchievementFirstCar],
		PlayerInfo[playerid][pAchievementFirstBiz],
		PlayerInfo[playerid][pAchievementFirstHouse],
		PlayerInfo[playerid][pAchievementFirstFaction],
		PlayerInfo[playerid][pUserID]
	);
	mysql_function_query(gSQLHandle, query, false, "FinishQuery", "");
	return 1;
}

UpdateHouseLabel(i, reset=0)
{
	new string[128];
	if(strcmpEx(HouseInfo[i][houseOwner], "None")) {
		format(string, sizeof(string), "House ID: %d\nFor Sale!\nCost: %d\nLevel: %d", 
			i,
			HouseInfo[i][houseCost],
			HouseInfo[i][houseLevel]
		);
	}	
	else {
		format(string, sizeof(string), "House ID: %d\nOwner: %s\nLevel: %d",
			i,
			HouseInfo[i][houseOwner],
			HouseInfo[i][houseLevel]
		);
	}
	
	if(!reset) {
		UpdateDynamic3DTextLabelText(HouseInfo[i][houseLabel], COLOR_GREEN, string);
	}
	else {
		DestroyDynamicPickup(HouseInfo[i][houseIcon]);
		DestroyDynamic3DTextLabel(HouseInfo[i][houseLabel]);
		HouseInfo[i][houseLabel] = CreateDynamic3DTextLabel(string, COLOR_GREEN, HouseInfo[i][houseExt][0], HouseInfo[i][houseExt][1]+0.1, HouseInfo[i][houseExt][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, /* vw */ 0, /* int */ 0, -1, 10.0);
		HouseInfo[i][houseIcon] = CreateDynamicPickup(1273, 1, HouseInfo[i][houseExt][0], HouseInfo[i][houseExt][1], HouseInfo[i][houseExt][2]);
	}
	return 1;
}

SaveHouse(i) 
{
	#define h[%0] HouseInfo[i][%0]
	format(query, sizeof(query), "UPDATE `houses` SET `houseOwner`='%s',\
		`houseExtX`=%.2f,\
		`houseExtY`=%.2f,\
		`houseExtZ`=%.2f,\
		`houseExtA`=%.2f,\
		`houseIntX`=%.2f,\
		`houseIntY`=%.2f,\
		`houseIntZ`=%.2f,\
		`houseIntA`=%.2f,\
		`houseInterior`=%d,\
		`houseVirtualWorld`=%d,\
		`houseCost`=%d,\
		`houseBill`=%d,\
		`houseVacant`=%d,\
		`houseLock`=%d,\
		`houseLevel`=%d WHERE `houseID`=%d",
		h[houseOwner],
		h[houseExt][0],
		h[houseExt][1],
		h[houseExt][2],
		h[houseExt][3],
		h[houseInt][0],
		h[houseInt][1],
		h[houseInt][2],
		h[houseInt][3],
		h[houseInterior],
		h[houseVirtualWorld],
		h[houseCost],
		h[houseBill],
		h[houseVacant],
		h[houseLock],
		h[houseLevel],
		h[houseID]
	);
	mysql_function_query(gSQLHandle, query, false, "FinishQuery", "");

	format(query, sizeof(query), "UPDATE `houses` SET `houseStorage1`=%d,\
		`houseStorage2`=%d,\
		`houseStorage3`=%d,\
		`houseStorage4`=%d,\
		`houseStorage5`=%d,\
		`houseStorage6`=%d,\
		`houseStorage7`=%d,\
		`houseStorage8`=%d WHERE `houseID`=%d",
		h[houseStorage][0],
		h[houseStorage][1],
		h[houseStorage][2],
		h[houseStorage][3],
		h[houseStorage][4],
		h[houseStorage][5],
		h[houseStorage][6],
		h[houseStorage][7],
		h[houseID]
	);
	mysql_function_query(gSQLHandle, query, false, "FinishQuery", "");
	
	return 1;
	#undef h
}

UpdatePlayerTag(playerid) 
{
	new Float:pos[3];
	new string[24+6];
	DestroyDynamic3DTextLabel(PlayerInfo[playerid][nameTag]);
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	if(GetPVarInt(playerid, "AdminDuty") >= 1) {
		format(string, sizeof(string), "%s %s", GetPlayerStaffRank(playerid), GetAdminName(playerid));
		PlayerInfo[playerid][nameTag] = CreateDynamic3DTextLabel(string, 0x65909AFF, pos[0], pos[1], pos[2]+0.2, 
					10.0, playerid, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 10.0);
	}
	else {
		format(string, sizeof(string), "%s (%d)", GetPlayerNameEx(playerid, 1), playerid);
		PlayerInfo[playerid][nameTag] = CreateDynamic3DTextLabel(string, COLOR_WHITE, pos[0], pos[1], pos[2]+0.1, 
			10.0, playerid, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 10.0);
	}
	return 1;
}