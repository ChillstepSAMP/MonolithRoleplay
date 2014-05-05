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

CMD:ahelp(playerid, params[]) /* Temp */
{
	#define admin PlayerInfo[playerid][pStaff]
	if(admin >= STAFF_ADMIN) {
		if(admin >= STAFF_ADMIN) {
			SendClientMessageEx(playerid, COLOR_GREY, "*** {00FF00}ADMIN{B4B5B7} *** /ipcheck /idcheck /freeze /unfreeze /setvw /setint");
			SendClientMessageEx(playerid, COLOR_GREY, "*** {00FF00}ADMIN{B4B5B7} *** /goto /kick /lastused /fixveh /respawnveh /aduty");
		}
		if(admin >= STAFF_SADMIN) {
			SendClientMessageEx(playerid, COLOR_GREY, "*** {00FF00}SENIOR ADMIN{B4B5B7} *** /takemod /givexp /sweepvehs");
		}
		if(admin >= STAFF_LADMIN) {
			SendClientMessageEx(playerid, COLOR_GREY, "*** {0000CD}LEAD ADMIN{B4B5B7} *** /makepmod /takestaff /createatm /editatm /createdoor /editdoor");
			SendClientMessageEx(playerid, COLOR_GREY, "*** {0000CD}LEAD ADMIN{B4B5B7} *** /skick /giveweapon");
		}
		if(admin >= STAFF_HADMIN) {
			SendClientMessageEx(playerid, COLOR_GREY, "*** {DC143C}HEAD ADMIN{B4B5B7} *** /makestaff /givemoney /createkey /revokekey");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	#undef admin
	return 1;
}

CMD:ipcheck(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN)
	{
		new giveplayerid;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "That player is not connected.");
				return 1;
			}

			if(PlayerInfo[giveplayerid][pStaff] >= STAFF_ADMIN && PlayerInfo[playerid][pStaff] <= STAFF_SADMIN) {
				SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You may not do this to another staff member.");
				return 1;
			}

			SendClientMessageEx(playerid, COLOR_RED, "IP Info: " COL_WHITE "%s's Current IP: %s | Database IP: %s", 
				GetPlayerNameEx(giveplayerid,1), GetPlayerIpEx(giveplayerid), PlayerInfo[giveplayerid][pUserIp]);
			Log("IpLog.log", "%s has checked %s's Ip. (/ipcheck)",GetPlayerNameEx(playerid),GetPlayerNameEx(giveplayerid));
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/ipcheck <playerid>");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:idcheck(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN)
	{
		new giveplayerid;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "That player is not connected.");
				return 1;
			}

			SendClientMessageEx(playerid, COLOR_RED, "Database Info: " COL_WHITE "%s's database ID is " COL_YELLOW "%i" COL_WHITE ".", 
				GetPlayerNameEx(giveplayerid,1), PlayerInfo[giveplayerid][pUserID]);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/idcheck <playerid>");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:makepmod(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN)
	{
		new giveplayerid;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "That player is not connected.");
				return 1;
			}
			if(PlayerInfo[giveplayerid][pStaff] > 0)
			{
				SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "This player is a staff member and cannot be made a moderator.");
				return 1;
			}
			PlayerInfo[giveplayerid][pMod] = 1;
			SendClientMessageEx(playerid, COLOR_SBLUE, "Promotion: " COL_WHITE "You have made %s a Player Mod.",GetPlayerNameEx(giveplayerid,1));
			SendClientMessageEx(giveplayerid, COLOR_SBLUE, "Promotion: " COL_WHITE "You have been made a Player Mod by %s.", GetPlayerNameEx(playerid,1));
			Log("Promotion.log", "%s has promoted %s to PMod.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/makepmod <playerid>");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:makestaff(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_HADMIN)
	{
		new giveplayerid;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "That player is not connected.");
				return 1;
			}
			PlayerInfo[giveplayerid][pStaff] = 1;
			PlayerInfo[giveplayerid][pMod] = 0;
			SendClientMessageEx(playerid, COLOR_SBLUE, "Promotion: " COL_WHITE "You have made %s a staff member.",GetPlayerNameEx(giveplayerid,1));
			SendClientMessageEx(giveplayerid, COLOR_SBLUE, "Promotion: " COL_WHITE "You have been made a staff member by %s.", GetPlayerNameEx(playerid,1));
			Log("Promotion.log", "%s has promoted %s to level 1 staff.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/makestaff <playerid>");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:takestaff(playerid, params[]) 
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN)
	{
		new giveplayerid;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "That player is not connected.");
				return 1;
			}

			if(PlayerInfo[giveplayerid][pStaff] == 0)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "This player does not have any staff or mod position.");
				return 1;
			}

			if(PlayerInfo[giveplayerid][pStaff] >= PlayerInfo[playerid][pStaff])
			{
				SendClientMessageEx(playerid, COLOR_ORANGE, "Warning: " COL_WHITE "You cannot do this to a higher or equal staff member!");
				return 1;
			}

			PlayerInfo[giveplayerid][pStaff] = 0;
			SendClientMessageEx(playerid, COLOR_RED, "Revokation: " COL_WHITE "You have taken %s's Staff.",GetPlayerNameEx(giveplayerid,1));
			SendClientMessageEx(giveplayerid, COLOR_RED, "Revokation: " COL_WHITE "You have had your Staff revoked by %s.", GetPlayerNameEx(playerid,1));
			Log("Promotion.log", "%s has taken %s's staff.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/takestaff <playerid>");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:takemod(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_SADMIN)
	{
		new giveplayerid;
		if(!sscanf(params, "u", giveplayerid))
		{
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "That player is not connected.");
				return 1;
			}

			if(PlayerInfo[giveplayerid][pMod] == 0)
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "This player does not have any staff or mod position.");
				return 1;
			}

			PlayerInfo[giveplayerid][pMod] = 0;
			SendClientMessageEx(playerid, COLOR_RED, "Revokation: " COL_WHITE "You have taken %s's Mod.",GetPlayerNameEx(giveplayerid,1));
			SendClientMessageEx(giveplayerid, COLOR_RED, "Revokation: " COL_WHITE "You have had your Mod revoked by %s.", GetPlayerNameEx(playerid,1));
			Log("Promotion.log", "%s has taken %s's mod.",GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid));
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/takemod <playerid>");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:freeze(playerid, params[])
{
	new giveplayerid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "u", giveplayerid)) {
			SendClientMessageEx(giveplayerid, COLOR_YELLOW, "Notice: " COL_WHITE "You have been frozen by an admin.");
			TogglePlayerControllable(giveplayerid, 0);

			foreach(Player, i) {
				if(PlayerInfo[i][pStaff] >= STAFF_ADMIN) {
					SendClientMessageEx(i, COLOR_RED, "AdmCmd: " COL_YELLOW "%s has frozen %s.", GetPlayerNameEx(playerid, 1), GetPlayerNameEx(giveplayerid, 1));
				}
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/freeze <playerid>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	new giveplayerid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "u", giveplayerid)) {
			SendClientMessageEx(giveplayerid, COLOR_YELLOW, "Notice: " COL_WHITE "You have been unfrozen by an admin.");
			TogglePlayerControllable(giveplayerid, 1);

			foreach(Player, i) {
				if(PlayerInfo[i][pStaff] >= STAFF_ADMIN) {
					SendClientMessageEx(i, COLOR_RED, "AdmCmd: " COL_YELLOW "%s has unfrozen %s.", GetPlayerNameEx(playerid, 1), GetPlayerNameEx(giveplayerid, 1));
				}
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/unfreeze <playerid>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:givemoney(playerid, params[]) 
{
	new giveplayerid, amount;
	if(PlayerInfo[playerid][pStaff] == STAFF_HADMIN) { /* to limit abusing assholes, only Head Admins can use this. */
		if(!sscanf(params, "ui", giveplayerid, amount)) {
			if((amount + PlayerInfo[playerid][pMoneyOnHand]) > 20000) { /* let's not screw a player and make him start dropping. */
				GivePlayerBankMoney(giveplayerid, amount);
			}
			else {
				GivePlayerMoneyEx(giveplayerid, amount);
			}
			SendClientMessageEx(playerid, COLOR_GREEN, "Money: " COL_WHITE "You have awarded $%s to %s.", NumFormat(amount), GetPlayerNameEx(giveplayerid, 1));
			SendClientMessageEx(giveplayerid, COLOR_GREEN, "Money: " COL_WHITE "You have been awarded $%s from %s.", NumFormat(amount), GetPlayerNameEx(playerid, 1));
			Log("Give.log", "%s has given %s $%s. (/givemoney)", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid), NumFormat(amount));
			
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/givemoney <playerid> <amount>");
		}
	} 
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
		
		if(PlayerInfo[playerid][pStaff] >= STAFF_SADMIN) {
			SendClientMessageEx(playerid, COLOR_YELLOW, "Hint: " COL_WHITE "Contact a Head Administrator to have money issued.");
		}
	}
	return 1;
}

CMD:createatm(playerid, params[]) 
{
	new money, range, disabled;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "iI(3)I(0)", money, range, disabled)) {
			
			new Float:Pos[3], id, text[148];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

			for(new i = 0; i < MAX_ATMS; i++) { /* we would create a function, but it's only used once. */
				if(ATMInfo[i][aPosX] == 0 && ATMInfo[i][aPosY] == 0 && ATMInfo[i][aPosZ] == 0) {
					id = i;
					break;
				}
			}

			ATMInfo[id][aPosX] = Pos[0];
			ATMInfo[id][aPosY] = Pos[1];
			ATMInfo[id][aPosZ] = Pos[2];
			ATMInfo[id][aMoney] = money;
			ATMInfo[id][aRange] = range;
			ATMInfo[id][aDisabled] = disabled;
			ATMInfo[id][aInt] = GetPlayerInterior(playerid);
			ATMInfo[id][aVW] = GetPlayerVirtualWorld(playerid);

			if(ATMInfo[id][aDisabled] != 1) {
				format(text, sizeof(text), "==ATM==\nStatus:" COL_GREEN " Working\n" COL_GOLDENROD "ATM Balance:" COL_GREEN " $%s\n" COL_GOLDENROD "ID: {FFFFFF}%i", NumFormat(ATMInfo[id][aMoney]), id);
			}
			else {
				format(text, sizeof(text), "==ATM==\nStatus:" COL_RED " Damaged\n" COL_GOLDENROD "ATM Balance:" COL_GREEN " $0\n" COL_GOLDENROD "ID: {FFFFFF}%i",id);
			}
			aLabels[id] = CreateDynamic3DTextLabel(text, 0xDAA520FF, ATMInfo[id][aPosX], ATMInfo[id][aPosY], ATMInfo[id][aPosZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ATMInfo[id][aVW], ATMInfo[id][aInt], -1, 10.0);
			
			printf("[DEBUG] CREATED: %i, %i, %i, %.2f, %.2f, %.2f, %i, %i, %i", ATMInfo[id][aID], ATMInfo[id][aMoney], ATMInfo[id][aDisabled], ATMInfo[id][aPosX],
				ATMInfo[id][aPosY], ATMInfo[id][aPosZ], ATMInfo[id][aRange], ATMInfo[id][aVW], ATMInfo[id][aInt]);

			SaveATM(id);
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/createatm <money> <range (deft: 3)> <disabled (deft: 0)>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:editatm(playerid, params[])
{
	new id, option[64], value;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "is[64]I(-1)", id, option, value)) {

			if(strcmpEx(option, "position")) {
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				ATMInfo[id][aPosX] = pos[0];
				ATMInfo[id][aPosY] = pos[1];
				ATMInfo[id][aPosZ] = pos[2];
			}
			else if(strcmpEx(option, "money")) {
				if(value != -1) {
					ATMInfo[id][aMoney] = value;
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Please enter a value for the option.");
				}
			}
			else if(strcmpEx(option, "range")) {
				if(value != -1) {
					ATMInfo[id][aRange] = value;
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Please enter a value for the option.");
				}
			}
			else if(strcmpEx(option, "disabled")) {
				if(value != -1) {
					ATMInfo[id][aDisabled] = value;
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Please enter a value for the option.");
				}
			}
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "Invalid option chosen.");
				return 1;
			}
			SendClientMessageEx(playerid, COLOR_GREY, "You have edited the %s", option);
			Log("ATMEdit.log", "%s has edited %s (Optional:%d) for ATM ID: %d", GetPlayerNameEx(playerid,1), option, value, id);
			UpdateATMLabel(id, 1);
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/editatm <atm id> <option> <value (if required)>");
			SendClientMessageEx(playerid, COLOR_ORANGE, "Options: " COL_WHITE "Position - Money - Range - Disabled");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:setvw(playerid, params[]) 
{
	new giveplayerid, worldid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "ui", giveplayerid, worldid)) {
			SetPlayerVirtualWorld(giveplayerid, worldid);
			PlayerInfo[giveplayerid][pVW] = worldid;
			SendClientMessageEx(giveplayerid, COLOR_RED, "Virtual World: " COL_WHITE "An Admin has set your virtual world.");
			SendClientMessageEx(playerid, COLOR_RED, "Virtual World: " COL_WHITE "You have set %s's virtual world.", GetPlayerNameEx(giveplayerid,1));
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/setvw <playerid> <worldid>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:setint(playerid, params[]) 
{
	new giveplayerid, interiorid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "ui", giveplayerid, interiorid)) {
			SetPlayerInterior(giveplayerid, interiorid);
			PlayerInfo[giveplayerid][pVW] = interiorid;
			SendClientMessageEx(giveplayerid, COLOR_RED, "Interior: " COL_WHITE "An Admin has set your interior.");
			SendClientMessageEx(playerid, COLOR_RED, "Interior: " COL_WHITE "You have set %s's interior.", GetPlayerNameEx(giveplayerid,1));
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/setint <playerid> <interiorid>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:createdoor(playerid, params[]) 
{
	new name[64], range, disabled;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "I(3)I(0)s[64]", range, disabled, name)) {
			
			new Float:Pos[3], id, text[148];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

			for(new i = 0; i < MAX_DOORS; i++) { /* we would create a function, but it's only used once. */
				if(DoorInfo[i][dExteriorX] == 0 && DoorInfo[i][dExteriorY] == 0 && DoorInfo[i][dExteriorZ] == 0) {
					id = i;
					break;
				}
			}

			format(DoorInfo[id][dName], 64, name);
			DoorInfo[id][dExteriorX] = Pos[0];
			DoorInfo[id][dExteriorY] = Pos[1];
			DoorInfo[id][dExteriorZ] = Pos[2];
			DoorInfo[id][dRange] = range;
			DoorInfo[id][dDisabled] = disabled;
			DoorInfo[id][dIntx] = GetPlayerInterior(playerid);
			DoorInfo[id][dVWx] = GetPlayerVirtualWorld(playerid);
			DoorInfo[id][dVW] = id;
			DoorInfo[id][dInt] = 0;

			if(DoorInfo[id][dOwnable] == 0) {
				if(DoorInfo[id][dDisabled] == 1) {
					format(text, sizeof(text), "%s\nStatus:" COL_RED " Closed\n" COL_GOLDENROD "ID: " COL_WHITE "%i", DoorInfo[id][dName], id);
				}
				else {
					format(text, sizeof(text), "%s\nStatus:" COL_GREEN " Open\n" COL_GOLDENROD "ID: " COL_WHITE "%i", DoorInfo[id][dName], id);
				}
			}
			else {
				if(DoorInfo[id][dDisabled] == 1) {
					format(text, sizeof(text), "%s\nStatus:" COL_RED " Closed\n" COL_GOLDENROD "Owner: " COL_WHITE "%s\n" COL_GOLDENROD "ID: " COL_WHITE "%i", DoorInfo[id][dName], DoorInfo[id][dOwner], id);
				}
				else {
					format(text, sizeof(text), "%s\nStatus:" COL_GREEN " Open\n" COL_GOLDENROD "Owner: " COL_WHITE "%s\n" COL_GOLDENROD "ID: " COL_WHITE "%i", DoorInfo[id][dName], DoorInfo[id][dOwner], id);
				}
			}
			UpdateDoorLabel(id,1);
			SaveDoor(id);

			SendClientMessageEx(playerid, COLOR_ORANGE, "Door: " COL_WHITE "The door has been created. You may now edit the interior (/editdoor).");
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/createdoor <range optional( (deft: 3))> <disabled optional( (deft: 0)> <name>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:editdoor(playerid, params[]) 
{
	new id, option[64], value;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "is[64]I(-1)", id, option, value)) {
			new Float:Pos[4];
			if(strcmpEx(option, "exterior")) {
				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				GetPlayerFacingAngle(playerid, Pos[3]);
				DoorInfo[id][dExteriorX] = Pos[0];
				DoorInfo[id][dExteriorY] = Pos[1];
				DoorInfo[id][dExteriorZ] = Pos[2];
				DoorInfo[id][dExteriorA] = Pos[3];
				DoorInfo[id][dIntx] = GetPlayerInterior(playerid);
				DoorInfo[id][dVWx] = GetPlayerVirtualWorld(playerid);
				
				SendClientMessageEx(playerid, COLOR_YELLOW, "Door Info: " COL_WHITE "You have changed the exterior coords to: X:%.2f, Y:%.2f, Z:%.2f ", Pos[0], Pos[1], Pos[2]);
				UpdateDoorLabel(id, 1); /* optional parameter 2 resets the label */
				Log("Door.log", "%s edited door ID %i : Set ext pos %.2f, %.2f, %.2f", GetPlayerNameEx(playerid, 1), id, Pos[0], Pos[1], Pos[2]);
			}
 			else if(strcmpEx(option, "interior")) {
 				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				DoorInfo[id][dInteriorX] = Pos[0];
				DoorInfo[id][dInteriorY] = Pos[1];
				DoorInfo[id][dInteriorZ] = Pos[2];
				DoorInfo[id][dInteriorA] = Pos[3];
				DoorInfo[id][dInt] = GetPlayerInterior(playerid);
				DoorInfo[id][dVW] = GetPlayerVirtualWorld(playerid); 

				UpdateDoorLabel(id);
				SendClientMessageEx(playerid, COLOR_YELLOW, "Door Info: " COL_WHITE "You have changed the interior coords to: X:%.2f, Y:%.2f, Z:%.2f ", Pos[0], Pos[1], Pos[2]);	
				Log("Door.log", "%s edited door ID %i : Set int pos %.2f, %.2f, %.2f", GetPlayerNameEx(playerid, 1), id, Pos[0], Pos[1], Pos[2]);
			} 
			else if(strcmpEx(option, "status")) {
				if(value == -1) {
					SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "You did not enter a value.");
					return 1;
				}
				if(value != 0 || value != 1) {
					SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "Value for 'Status' needs to be 0 or 1.");
					return 1;
				} 
				DoorInfo[id][dDisabled] = value;
				UpdateDoorLabel(id);

				Log("Door.log", "%s has edit door ID %i : Set Disabled to %i", GetPlayerNameEx(playerid, 1), id, value);
			}
			else if(strcmpEx(option, "ownable")) {
				if(value == -1) {
					SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "You did not enter a value.");
					return 1;
				}
				if(value != 0 || value != 1) {
					SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "Value for 'Ownable' needs to be 0 or 1.");
					return 1;
				}
				DoorInfo[id][dOwnable] = value;
				UpdateDoorLabel(id);

				Log("Door.log", "%s has set door %d to be ownable.", GetAdminName(playerid), id);
			}
			else {
				SendClientMessageEx(playerid, COLOR_ORANGE, "Options: " COL_WHITE "You have entered an invalid parameter.");
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/editdoor <door id> <option> <value (if required)>");
			SendClientMessageEx(playerid, COLOR_ORANGE, "Options: " COL_WHITE "Exterior, Interior, Status (0-1), Ownable (0-1)");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:doorowner(playerid, params[]) 
{
	new id, giveplayerid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "du", id, giveplayerid)) {
			if(DoorInfo[id][dOwnable] == 1) {
				if(IsPlayerConnected(giveplayerid)) {
					Log("Door.log", "%s has set door ID %d's owner to be %s (Past: %s)", GetAdminName(playerid), id, GetPlayerNameEx(giveplayerid,1), DoorInfo[id][dOwner]);
					format(DoorInfo[id][dOwner], 24, GetPlayerNameEx(giveplayerid, 1));
					UpdateDoorLabel(id);
					SendClientMessageEx(playerid, COLOR_GREEN, "Door Assigned: " COL_WHITE "You have assigned door ID %d to %s.", id, GetPlayerNameEx(giveplayerid, 1));
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "That player is not connected.");
				}
			}
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "This door is not set to be ownable.");
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/doorowner <doorid> <playerid>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:doorname(playerid, params[]) 
{
	new name[64], id;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "ds[64]", id, name)) {
			Log("Door.log", "%s has renamed door ID %d from %s to %s", GetAdminName(playerid), DoorInfo[id][dName], name);
			format(DoorInfo[id][dName], 64, name);
			UpdateDoorLabel(id);
			SendClientMessageEx(playerid, COLOR_GREY, "You have set the door text to %s.", name);
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/doorname <doorid> <name>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:deletedoor(playerid, params[])
{
	new id;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "d", id)) {
			if(GetPVarInt(playerid, "ConfirmDelete") != 1) {
				SetPVarInt(playerid, "ConfirmDelete", 1);
				SendClientMessageEx(playerid, COLOR_YELLOW, "Confirm: " COL_GREY "If you are sure, please type this command again.");
				return 1;
			}


			Log("Door.log", "%s has deleted door ID %d.", GetAdminName(playerid), id);
			DeletePVar(playerid, "ConfirmDelete");
		}
		else {

		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	
	return 1;
}

CMD:goto(playerid, params[])
{
	new location[24], load;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(sscanf(params, "s[24]I(0)", location, load)) {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/goto <location> <load (0-1 optional)>");
			SendClientMessage(playerid, COLOR_ORANGE, "Options: " COL_WHITE "Los Santos (LS)");
			return 1;
		}

		if(strcmpEx(location, "ls")) {
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
				new vehicleid = GetPlayerVehicleID(playerid);
				SetVehiclePos(vehicleid, 1772.34, -1945.99, 13.55);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			else {
				SetPlayerPosEx(playerid, 1772.34, -1945.99, 13.55);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			return 1;
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Options: " COL_WHITE "You have entered an invalid parameter.");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:gotopos(playerid, params[])
{
	new Float:location[3], interior; 
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(sscanf(params, "fffd", location[0], location[1], location[2], interior)) {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/gotopos [x] [y] [z] [interior]");
			return 1;
		}

	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:kick(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN || PlayerInfo[playerid][pMod] > 0)
	{
		new giveplayerid, reason[24];
		if(!sscanf(params, "us[24]", giveplayerid, reason))
		{
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "That player is not connected.");
				return 1;
			}

			new message[128];
			format(message, sizeof(message), COL_RED "AdmCmd: " COL_YELLOW "%s has been kicked from the server by %s, reason: %s", GetPlayerNameEx(giveplayerid, 1), GetPlayerNameEx(playerid, 1), reason);
			SendClientMessageToAll(COLOR_YELLOW, message);

			SetTimerEx("KickDelay", 500, false, "i", giveplayerid);
			Log("Kick.log", message);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/kick <playerid> <reason>");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:skick(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN)
	{
		new giveplayerid, reason[24];
		if(!sscanf(params, "us[24]", giveplayerid, reason))
		{
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientMessageEx(playerid, COLOR_YELLOW, "Server: " COL_WHITE "That player is not connected.");
				return 1;
			}

			new message[128];
			format(message, sizeof(message), COL_RED "AdmCmd: " COL_YELLOW "%s has been silent kicked from the server by %s, reason: %s", GetPlayerNameEx(giveplayerid, 1), GetPlayerNameEx(playerid, 1), reason);
			foreach(Player, i) {
				if(PlayerInfo[i][pStaff] >= STAFF_ADMIN) {
					SendClientMessageEx(i, COLOR_YELLOW, message);
				}
			}

			SetTimerEx("KickDelay", 500, false, "i", giveplayerid);
			Log("Kick.log", message);
		}
		else
		{
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/skick <playerid> <reason>");
		}
	}
	else
	{
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:givexp(playerid, params[])
{
	new exp, giveplayerid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_SADMIN) {
		if(!sscanf(params, "ud", giveplayerid, exp)) {
			ExpHandler(giveplayerid, exp);
			SendClientMessageEx(playerid, COLOR_YELLOW, "Exp: " COL_WHITE "You have given %s experience to %s.", NumFormat(exp), GetPlayerNameEx(playerid, 1));
			SendClientMessageEx(playerid, COLOR_YELLOW, "You have received %s experience from an administrator.", NumFormat(exp));
		
			Log("Give.log", "%s has given %s %d experience", GetPlayerNameEx(playerid, 1), GetPlayerNameEx(giveplayerid, 1), exp);
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/givexp <playerid> <amount>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

#if !defined _Alpha

CMD:forcepassword(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] == STAFF_HADMIN) {
		
		if(GetPVarInt(playerid, "FP_Confirm") == 0) {
			SetPVarInt(playerid, "FP_Confirm", 1);
			return SendClientMessageEx(playerid, COLOR_ORANGE, "Confirm: " COL_WHITE "Please type this command again to confirm operation.");
		}

		/* We are not going to upset the natural balance and prompt everyone, just those logging in. */
		format(query, sizeof(query), "UPDATE `server_config` SET `ForceChange`=%d WHERE `serverID` = 1", strval(params));
		mysql_function_query(gSQLHandle, query, false, "InsertKey", "");
		SetGVarInt("serv_conf_pass", 1);
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You have forced a password change.");
	
		Log("Action.log", "%s has forced a password change to the server.", GetPlayerNameEx(playerid, 1));
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

#endif

CMD:lastused(playerid, params[])
{
	new vehicleid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "d", vehicleid)) {
			if(vehicleid != INVALID_VEHICLE_ID) {
				SendClientMessageEx(playerid, COLOR_GREEN, "VehInfo: " COL_YELLOW "%s last used this vehicle ID", LastVehUsed[vehicleid]);
			}
			else {
				SendClientMessageEx(playerid, COLOR_GREEN, "VehInfo: " COL_YELLOW "No-one last used this vehicle ID", LastVehUsed[vehicleid]);
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/lastused <vehicleid>");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
} 

CMD:sweepvehs(playerid, params[]) 
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_SADMIN) {
		for(new i = 0; i < sizeof(user_spawned_vehs); i++) {
			if(GetVehicleDriver(i) == INVALID_PLAYER_ID) {
				DestroyVehicle(i);
				user_spawned_vehs[i] = INVALID_VEHICLE_ID;
			}
		}
		SendClientMessageEx(playerid, COLOR_RED, "AdmCmd: " COL_WHITE "You have despawned all vehicles.");
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:fixveh(playerid, params[])
{
	new vehicleid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "d", vehicleid)) {
			if(vehicleid == INVALID_VEHICLE_ID) {
				return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "That was an invalid vehicle ID.");
			}
			RepairVehicle(vehicleid);
			SendClientMessageEx(playerid, COLOR_RED, "AdmCmd: " COL_WHITE "You have fixed vehicle ID %i.", vehicleid);
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/fixveh [vehicleid]");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:respawnveh(playerid, params[])
{
	new vehicleid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "d", vehicleid)) {
			if(vehicleid == INVALID_VEHICLE_ID) {
				return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "That was an invalid vehicle ID.");
			}
			SetVehicleToRespawn(vehicleid);
			SendClientMessageEx(playerid, COLOR_RED, "AdmCmd: " COL_WHITE "You have respawned vehicle ID %i.", vehicleid);
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/respawnveh [vehicleid]");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:giveweapon(playerid, params[]) 
{
	new weapon[32], weaponid, giveplayerid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "ui", giveplayerid, weaponid)) {
			GivePlayerWeapon(playerid, weaponid, 9999);
			GetWeaponName(weaponid, weapon, sizeof(weapon));
			SendClientMessageEx(playerid, COLOR_RED, "AdmCmd: " COL_YELLOW "You have given %s a %s.", GetPlayerNameEx(playerid, 1), weapon);
			SendClientMessageEx(playerid, COLOR_RED, "AdmCmd: " COL_YELLOW "You have been given a %s by %s.", weapon, GetPlayerNameEx(playerid, 1));
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE  "/giveweapon [playerid] [weaponid]");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:aduty(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {

		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		if(GetPVarInt(playerid, "AdminDuty") == 0) {

			if(isnull(GetAdminName(playerid))) {
				ShowPlayerDialog(playerid, DIALOG_ADMIN_NAME, DIALOG_STYLE_INPUT, "Input Admin Name", "Please choose an admin name for yourself\n\
				Please be appropriate or you will be removed.", "Okay", "");
				return 1;
			}

			format(string, sizeof(string), "An administrator has gone on duty. If you need help, report or use the ask system.");
			SendClientMessageToAll(0x65909AFF, string);

			DestroyDynamic3DTextLabel(PlayerInfo[playerid][nameTag]);
			format(string, sizeof(string), "%s %s", GetPlayerStaffRank(playerid), GetAdminName(playerid));

			PlayerInfo[playerid][nameTag] = CreateDynamic3DTextLabel(string, 0x65909AFF, pos[0], pos[1], pos[2]+0.2, 
					10.0, playerid, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 10.0);
			SetPVarInt(playerid, "AdminDuty", 1);

			ShowPlayerMessage(playerid, "You are now ~g~on~w~ admin duty!", 5);
		}
		else {
			DestroyDynamic3DTextLabel(PlayerInfo[playerid][nameTag]);
			format(string, sizeof(string), "%s (%d)", GetPlayerNameEx(playerid, 1), playerid);

			PlayerInfo[playerid][nameTag] = CreateDynamic3DTextLabel(string, COLOR_WHITE, pos[0], pos[1], pos[2]+0.1, 
				10.0, playerid, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 10.0);
			DeletePVar(playerid, "AdminDuty");

			ShowPlayerMessage(playerid, "You are now ~r~off~w~ admin duty!", 5);
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:setstat(playerid, params[])
{
	new giveplayerid, option[64], val;
	if(PlayerInfo[playerid][pStaff] <= STAFF_LADMIN) 
		return SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	if(sscanf(params, "us[64]d", giveplayerid, option, val)) {
		SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE  "/setstat <playerid> <option> <value>");
		return SendClientMessageEx(playerid, COLOR_ORANGE, "Options: " COL_WHITE "Level");
	}
	if(strcmpEx(option, "level")) {
		if(val <= 0)
			return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You may not go below 1.");
		PlayerInfo[giveplayerid][pLevel] = val;
	}
	else return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You have entered an invalid option for /setstat");
	return SendClientMessageEx(playerid, COLOR_GREEN, "Stats: " COL_WHITE "You have set %s's %s to %d", GetPlayerNameEx(giveplayerid, 1), option, val);
}

CMD:logpoint(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] == STAFF_HADMIN)
	{
		new fileStr[64], Float:pos[3];
		new File: fileHandle = fopen("Checkpoints.thy", io_append);
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
		format(fileStr, sizeof(fileStr), "SetPlayerCheckpoint(playerid, %.2f, %.2f, %.2f, 10);\r\n", pos[0], pos[1], pos[2]);
		fwrite(fileHandle, fileStr);
		fclose(fileHandle);
	}
	return 1;
}

CMD:admin(playerid, params[]) return cmd_a(playerid, params);
CMD:a(playerid, params[])
{
	new string[128];
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!isnull(params)) {
			format(string, sizeof(string), "%s %s: %s", GetPlayerStaffRank(playerid), GetPlayerNameEx(playerid, 1), params);
			foreach(Player, i) {
				if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN)
					SendClientMessageEx(i, COLOR_YELLOW, string);
			}
		}
		else 
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/a(dmin) <message>");
	}
	else
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	return 1;
}

CMD:makehelp(playerid, params[])
{
	new text[32], string[86], Float:pos[3];
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "s[86]", string)) 
		{
			new id;
			for(new i = 0; i < MAX_INFOS; i++) {
				if(isnull(InfoEnum[i][infoStr])) {
					id = i;
					break;
				}
			}

			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

			InfoEnum[id][infoPos][0] = pos[0];
			InfoEnum[id][infoPos][1] = pos[1];
			InfoEnum[id][infoPos][2] = pos[2];

			format(InfoEnum[id][infoStr], 86, string);
			format(text, sizeof(text), "Help Icon - Step over for more information.");

    		InfoEnum[id][infoLabel] = CreateDynamic3DTextLabel(text, 0xF5DEB3FF, InfoEnum[id][infoPos][0], InfoEnum[id][infoPos][1], InfoEnum[id][infoPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, /* vw */ 0, /* int */ 0, -1, 10.0);
    		InfoEnum[id][infoPickup] = CreateDynamicPickup(1239, 2, InfoEnum[id][infoPos][0], InfoEnum[id][infoPos][1], InfoEnum[id][infoPos][2]-0.4, 0, 0, -1);
    		
    		SaveHelpInfo(id);
		}
		else
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/makehelp <message>");
	}
	else
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	return 1;
}

CMD:maxconnections(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] == STAFF_HADMIN) {
		if(isnull(params)) return SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/maxconnections [num (per IP)]");
		SetMaxConnections(strval(params));
	}
	return 1;
}

CMD:acban(playerid, params[])
{
	new giveplayerid, reason[24];
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "us[24]", giveplayerid, reason)) {
			if(PlayerInfo[giveplayerid][pACBanned] != 0) {
				SendClientMessageEx(playerid, COLOR_GREY, "%s is already accent banned.", GetPlayerNameEx(giveplayerid, 1));
			}
			else {
				PlayerInfo[giveplayerid][pACBanned] = 1;
				va_SendClientMessageToAll(COLOR_LIGHTRED, "%s has been banned from using accents by %s, reason: %s", GetPlayerNameEx(giveplayerid, 1), GetPlayerNameEx(playerid, 1), reason);
				Log("Ban.log", "%s has been banned from using accents by %s, reason: %s", GetPlayerNameEx(giveplayerid, 1), GetPlayerNameEx(playerid, 1), reason);
				ShowPlayerDialog(giveplayerid, DIALOG_BLANK, DIALOG_STYLE_MSGBOX, "Important Notice", "You have been muted from using accents until the ban is lifted by an admin.\n\
					If you feel this was an inappropriate action, please report the administrator on the forums", "Okay", "");
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/acban <playerid> <reason>");
		}
	}
}

CMD:liftacban(playerid, params[])
{
	new giveplayerid, reason[24];
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(!sscanf(params, "us[24]", giveplayerid, reason)) {
			if(PlayerInfo[giveplayerid][pACBanned] == 0) {
				SendClientMessageEx(playerid, COLOR_GREY, "%s is not accent banned, currently.", GetPlayerNameEx(giveplayerid, 1));
			}
			else {
				foreach(Player, i) {
					if(PlayerInfo[i][pStaff] >= STAFF_ADMIN) 
						SendClientMessageEx(i, COLOR_LIGHTRED, "%s had his ACBan lifted by %s, reason: %s",GetPlayerNameEx(giveplayerid, 1), GetPlayerNameEx(playerid, 1), reason);
				}
				PlayerInfo[giveplayerid][pACBanned] = 0;
				SendClientMessageEx(giveplayerid, COLOR_LIGHTBLUE, "You have had your accent ban lifted by %s.", GetPlayerNameEx(playerid, 1));
				Log("Ban.log", "%s has lifted %s's ACBan.", GetPlayerNameEx(playerid, 1), GetPlayerNameEx(giveplayerid, 1));
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/liftacban <playerid> <reason>");
		}
	}
}

CMD:meetandgreet(playerid, params[])
{
	new giveplayerid;
	if(PlayerInfo[playerid][pStaff] >= STAFF_HADMIN) {
		if(!sscanf(params, "u", giveplayerid)) {
			AchievementHandler(giveplayerid, A_MEETANDGREET, 2);
			SendClientMessageEx(playerid, COLOR_LIGHTRED, "Award: " COL_GREY "You have awarded %s.", GetPlayerNameEx(giveplayerid,1));
			Log("HeadAdmin.log", "%s has specially awarded %s", GetPlayerNameEx(playerid,1), GetPlayerNameEx(giveplayerid, 1));
		}
	}
	return 1;
}

CMD:god(playerid, params[])
{
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN) {
		if(GetPVarInt(playerid, "pGod") == 0) {
			SetPVarFloat(playerid, "pGodHealth", GetPVarFloat(playerid, "playerHealth"));
			SetPVarFloat(playerid, "pGodArmour", GetPVarFloat(playerid, "playerArmour"));
			SetPVarInt(playerid, "pGod", 1);

			SetPlayerHealthEx(playerid, 0x7FB00000);
			SendClientMessageEx(playerid, COLOR_GREY, "God mode enabled.");
		}
		else {
			SetPlayerHealthEx(playerid, GetPVarFloat(playerid, "pGodHealth"));
			SetPlayerArmourEx(playerid, GetPVarFloat(playerid, "pGodArmour"));
			
			DeletePVar(playerid, "pGodHealth");
			DeletePVar(playerid, "pGodArmour");
			DeletePVar(playerid, "pGod");

			SendClientMessageEx(playerid, COLOR_GREY, "God mode disabled.");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:createhouse(playerid, params[])
{
	new Float:pos[4], id;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(GetPVarInt(playerid, "confirmCreation") > 0) {
			
			for(new i = 0; i < MAX_HOUSES; i++) {
				if(HouseInfo[i][houseExt][0] == 0.0 && HouseInfo[i][houseExt][1] == 0.0 && HouseInfo[i][houseExt][2] == 0.0) {
					id = i;
					break;
				}
			}

			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			GetPlayerFacingAngle(playerid, pos[3]);
			HouseInfo[id][houseExt][0] = pos[0];
			HouseInfo[id][houseExt][1] = pos[1];
			HouseInfo[id][houseExt][2] = pos[2];
			HouseInfo[id][houseExt][3] = pos[3];
			HouseInfo[id][houseCost] = 25500;
			HouseInfo[id][houseLevel] = 999; // prevent someone buying house without interior.
			HouseInfo[id][houseLock] = 1;
			HouseInfo[id][houseBill] = floatround(HouseInfo[id][houseCost]*0.065); // 6.5% bill :)
			HouseInfo[id][houseCreated] = 1;

			for(new i = 0; i < 8; i++) {
				HouseInfo[id][houseStorage][i] = -1;
			}

			UpdateHouseLabel(id, 1);
			DeletePVar(playerid, "confirmCreation");

			Log("House.log", "%s has created house id %d", GetPlayerNameEx(playerid, 1), id);
		}
		else {
			SendClientMessageEx(playerid, COLOR_GREY, "Please re-type this command if you would like to create a house at your location.");
			SetPVarInt(playerid, "confirmCreation", 1);
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:edithouse(playerid, params[])
{
	new option[32];
	new ix, id;
	new Float:pos[4];
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {
		if(!sscanf(params, "s[32]dI(-1)", option, id, ix)) {

			if(HouseInfo[id][houseCreated] == 0) {
				SendClientMessageEx(playerid, COLOR_GREY, "This House ID has not been created.");
				return 1;
			}

			if(strcmpEx(option, "Exterior")) {
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);
				HouseInfo[id][houseExt][0] = pos[0];
				HouseInfo[id][houseExt][1] = pos[1];
				HouseInfo[id][houseExt][2] = pos[2];
				HouseInfo[id][houseExt][3] = pos[3];
				UpdateHouseLabel(id,1);
			}
			else if(strcmpEx(option, "interior")) {
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				GetPlayerFacingAngle(playerid, pos[3]);
				HouseInfo[id][houseInt][0] = pos[0];
				HouseInfo[id][houseInt][1] = pos[1];
				HouseInfo[id][houseInt][2] = pos[2];
				HouseInfo[id][houseInt][3] = pos[3];
				HouseInfo[id][houseInterior] = GetPlayerInterior(playerid);
				HouseInfo[id][houseVirtualWorld] = id+999;
			}
			else if(strcmpEx(option, "int")) {
				if(ix != -1) {
					HouseInfo[id][houseInterior] = ix;
					UpdateHouseLabel(id);
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Invalid value.");
					return 1;
				}
			}
			else if(strcmpEx(option, "vw")) {
				if(ix != -1) {
					HouseInfo[id][houseVirtualWorld] = ix;
					UpdateHouseLabel(id);
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Invalid value.");
					return 1;
				}
			}
			else if(strcmpEx(option, "bill")) {
				if(ix != -1) {
					HouseInfo[id][houseBill] = ix;
					UpdateHouseLabel(id);
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Invalid value.");
					return 1;
				}
			}
			else if(strcmpEx(option, "locked")) {
				if(ix != -1) {
					HouseInfo[id][houseLock] = ix;
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Invalid value.");
					return 1;
				}	
			}
			else if(strcmpEx(option, "cost")) {
				if(ix != -1) {
					HouseInfo[id][houseCost] = ix;
					UpdateHouseLabel(id);
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Invalid value.");
					return 1;
				}
			}
			else if(strcmpEx(option, "level")) {
				if(ix != -1) {
					HouseInfo[id][houseLevel] = ix;
					UpdateHouseLabel(id);
				}
				else {
					SendClientMessageEx(playerid, COLOR_GREY, "Invalid value.");
					return 1;
				}
			}
			else {
				SendClientMessageEx(playerid, COLOR_GREY, "Invalid option.");
				return 1;
			}
			Log("House.log", "%s has set %s (Optional:%d) for House ID %d", GetPlayerNameEx(playerid, 1), option, ix, id);
			SendClientMessageEx(playerid, COLOR_WHITE, "You have set the %s.", option);
			SaveHouse(id);
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/edithouse <option> <house ID> <optional value>");
			SendClientMessageEx(playerid, COLOR_ORANGE, "Options: " COL_WHITE "Exterior, Interior, Int, VW, Bill, Locked, Cost, Level");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:deletehouse(playerid, params[])
{
	new id;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {

		if(sscanf(params, "d", id)) {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/deletehouse <houseid>");
			return 1;
		}

		if(GetPVarInt(playerid, "ConfirmDelete") > 0) {
			
			Log("House.log", "%s has deleted %s's house (HouseID:%d)", GetPlayerNameEx(playerid, 1), HouseInfo[id][houseOwner], id);
			format(HouseInfo[id][houseOwner], 24, "None");
			HouseInfo[id][houseExt][0] = 0;
			HouseInfo[id][houseExt][1] = 0;
			HouseInfo[id][houseExt][2] = 0;
			HouseInfo[id][houseExt][3] = 0;
			HouseInfo[id][houseCost] = 0;
			HouseInfo[id][houseLevel] = 999; 
			HouseInfo[id][houseLock] = 1;
			HouseInfo[id][houseBill] = 0;
			HouseInfo[id][houseCreated] = 0;

			for(new i = 0; i < 8; i++) {
				HouseInfo[id][houseStorage][i] = -1;
			}

			DestroyDynamicPickup(HouseInfo[id][houseIcon]);
			DestroyDynamic3DTextLabel(HouseInfo[id][houseLabel]);
			DeletePVar(playerid, "ConfirmDelete");


		}
		else {
			SendClientMessageEx(playerid, COLOR_GREY, "Please re-type this command if you would like to delete this house.");
			SetPVarInt(playerid, "ConfirmDelete", 1);
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}

CMD:asellhouse(playerid, params[])
{
	new id;
	if(PlayerInfo[playerid][pStaff] >= STAFF_LADMIN) {

		if(sscanf(params, "d", id)) {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/asellhouse <houseid>");
			return 1;
		}

		Log("House.log", "%s has sold %s's house (HouseID:%d)", GetPlayerNameEx(playerid, 1), HouseInfo[id][houseOwner], id);
		
		format(HouseInfo[id][houseOwner], 24, "None");
		HouseInfo[id][houseVacant] = 0;
		HouseInfo[id][houseCost] = 25500;
		HouseInfo[id][houseLevel] = 999; 
		HouseInfo[id][houseLock] = 1;

		for(new i = 0; i < 8; i++) {
			HouseInfo[id][houseStorage][i] = -1;
		}
		
		UpdateHouseLabel(id);
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are not authorized to use this command!");
	}
	return 1;
}
