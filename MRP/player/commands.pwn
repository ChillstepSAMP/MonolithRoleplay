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

CMD:help(playerid, params[]) /* place-holder until a dialog/TD is created for this (pointless for now) */
{
	SendClientMessageEx(playerid, COLOR_GREY, "*** GENERAL *** /sfa /acmenu /atm /enter /exit /veh /exp /g");
	SendClientMessageEx(playerid, COLOR_YELLOW, "QuickNote: " COL_WHITE "This is a placeholder for commands and will be changed later.");
	return 1;
}

CMD:sfa(playerid, params[]) // TODO: Remove or restrict.
{
	new Float:angle;
	if(!sscanf(params,"f", angle)) {
		SetPlayerFacingAngle(playerid, angle);
	}
	else {
		SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/sfa <angle>");
	}
	return 1;
}

CMD:acmenu(playerid, params[]) // TODO: FINISH!
{
	ShowPlayerDialog(playerid, DIALOG_ACMENU_LOGIN, DIALOG_STYLE_PASSWORD, "Verify to Access", "Please enter your password to enter the Account Management dialog.", "Okay", "Cancel");
	return 1;
}

CMD:atm(playerid, params[]) {
	for(new i = 0; i < MAX_ATMS; i++) {
		if(IsPlayerInRangeOfPoint(playerid, ATMInfo[i][aRange], ATMInfo[i][aPosX], ATMInfo[i][aPosY], ATMInfo[i][aPosZ])) {
			
			if(ATMInfo[i][aDisabled] != 0) continue;

			new caption[24];
			format(caption, sizeof(caption), "ATM Balance: $%s", NumFormat(ATMInfo[i][aMoney]));
			
			ShowPlayerDialog(playerid, DIALOG_ATM, DIALOG_STYLE_LIST, caption, "Withdraw\nDeposit\nSee Balance\nExit", "Push", "");
			SetPVarInt(playerid, "UsingATMID", i);
			
			printf("[DEBUG] %s is now using ATM ID %i", GetPlayerNameEx(playerid), GetPVarInt(playerid, "UsingATMID"));
			break; // break out of the loop
		}
	}
	return 1;
}

CMD:robatm(playerid, params[]) 
{
	ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
	ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
	return 1;
}

CMD:enter(playerid, params[]) 
{
	for(new i = 0; i < MAX_DOORS; i++) {
		if(IsPlayerInRangeOfPoint(playerid, DoorInfo[i][dRange], DoorInfo[i][dExteriorX], DoorInfo[i][dExteriorY], DoorInfo[i][dExteriorZ]) 
			&& (GetPlayerVirtualWorld(playerid) == DoorInfo[i][dVWx] && GetPlayerInterior(playerid) == DoorInfo[i][dIntx])) {
			EnterExitFunc(playerid, i, 1, TYPE_DOOR);
			break;
		}
	}
	for(new i = 0; i < MAX_HOUSES; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][houseExt][0], HouseInfo[i][houseExt][1], HouseInfo[i][houseExt][2])) {
			EnterExitFunc(playerid, i, 1, TYPE_HOUSE);
			break;
		}
	}
	return 1;
}

CMD:exit(playerid, params[])
{
	for(new i = 0; i < MAX_DOORS; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 3, DoorInfo[i][dInteriorX], DoorInfo[i][dInteriorY], DoorInfo[i][dInteriorZ]) 
			&& (GetPlayerVirtualWorld(playerid) == DoorInfo[i][dVW] && GetPlayerInterior(playerid) == DoorInfo[i][dInt])) {
			EnterExitFunc(playerid, i, 2, TYPE_DOOR);
			break;
		}
	}
	for(new i = 0; i < MAX_HOUSES; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][houseInt][0], HouseInfo[i][houseInt][1], HouseInfo[i][houseInt][2])
			&& (GetPlayerVirtualWorld(playerid) == HouseInfo[i][houseVirtualWorld] && GetPlayerInterior(playerid) == HouseInfo[i][houseInterior])) {
			EnterExitFunc(playerid, i, 2, TYPE_HOUSE);
			break;
		}
	}
	return 1;
}

CMD:veh(playerid, params[]) 
{
	new vehiclemodel, color[2], opt;

	if(IsPlayerInAnyVehicle(playerid)) {
		SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "You cannot do this inside a vehicle.");
		return 1;
	}

	if(!sscanf(params, "dddI(0)", vehiclemodel, color[0], color[1], opt)) {
		
		new id;
		
		/* Get the ID of next used vehicle */
		for(new i = 0; i < sizeof(user_spawned_vehs); i++) {
			if(user_spawned_vehs[i] == INVALID_VEHICLE_ID) {
				id = i;
				break;
			}
		}

		new Float:rotation, Float:Pos[3];
		GetPlayerFacingAngle(playerid, rotation);
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		user_spawned_vehs[id] = CreateVehicle(vehiclemodel, Pos[0], Pos[1], Pos[2], rotation, color[0], color[1], 25000);
		if(!opt) {
			PutPlayerInVehicle(playerid, user_spawned_vehs[id], 0);
			PlayerInfo[playerid][uLastVeh] = user_spawned_vehs[id];
		}
		SendClientMessageEx(playerid, COLOR_GOLDENROD, "Vehicle: " COL_WHITE "You have spawned a %s.", VehicleNames[GetVehicleModel(user_spawned_vehs[id]) - 400]);
	}
	else {
		SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/veh <model> <color 1> <color 2>");
	}
	return 1;
}

CMD:ask(playerid, params[])
{
	new string[128];
	if(GetPVarInt(playerid, "LastAsked") > gettime())
		return SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "Please wait %d seconds before using this chat system again.",
			GetPVarInt(playerid, "LastAsked") - gettime());
	if(isnull(params)) 
		return SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/ask [message]");
	if(TextIPCheck(playerid, params))
		return SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");

	format(string, sizeof(string), "[Ask] %s %s: %s", GetPlayerStaffRank(playerid), GetPlayerNameEx(playerid, 1), params);
	SendClientMessageToAll(0x6699FFFF, string);
	if(strcmpEx(GetPlayerStaffRank(playerid), "Player")) SetPVarInt(playerid, "LastAsked", gettime()+20);	
	return 1;
}

CMD:exp(playerid, params[])
{
	return SendClientMessageEx(playerid, COLOR_YELLOW, "[Exp] Level: %d - Exp Calculated for next: %d", PlayerInfo[playerid][pLevel], CalcExp(PlayerInfo[playerid][pLevel]));
}

CMD:level(playerid, params[])
{
	return (strval(params)) ? (PlayerInfo[playerid][pLevel] += 1) : (PlayerInfo[playerid][pLevel] -= 1);
}

CMD:ooc(playerid, params[]) 
{
	new chat_string[128];
	if(isnull(params))
		return SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/me [action]");
	if(TextIPCheck(playerid, params))
		return SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");
	if(PlayerInfo[playerid][pStaff] >= STAFF_ADMIN)
		format(chat_string, sizeof(chat_string), "(([OOC] %s %s: %s ))", GetPlayerStaffRank(playerid), GetPlayerNameEx(playerid,1), params);
	else
		format(chat_string, sizeof(chat_string), "(([OOC] %s: %s ))", GetPlayerNameEx(playerid,1), params);
	SendClientMessageToAll(COLOR_TAN, chat_string);
	return 1;
}

CMD:me(playerid, params[])
{
	new chat_string[128];
	if(isnull(params))
		return SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/me [action]");
	if(TextIPCheck(playerid, params))
		return SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");

	format(chat_string, 128, "* {C2A2DA}%s %s", GetPlayerNameEx(playerid,1), params);
	ProxDetector(30.0, playerid, chat_string, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE);
	return 1;
}

CMD:do(playerid, params[])
{
	new chat_string[128];
	if(isnull(params))
		return SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/do [message]");
	if(TextIPCheck(playerid, params))
		return SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");

	format(chat_string, 128, "* %s (( %s ))", params, GetPlayerNameEx(playerid,1));
	ProxDetector(30.0, playerid, chat_string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
	return 1;
}

CMD:distance(playerid, params[])
{
	new Float:pos[3], Float:npcFrankPos[3], iDistance[2];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerPos(npcFrank, npcFrankPos[0], npcFrankPos[1], npcFrankPos[2]);
	iDistance[0] = GetDistanceBetweenPoints(pos[0], pos[1], pos[2], npcFrankPos[0], npcFrankPos[1], npcFrankPos[2]);
	SendClientMessageEx(playerid, COLOR_GREY, "[Custom] You are %d meters away from Frank.", iDistance[0]);
	iDistance[1] = floatround(GetPlayerDistanceFromPoint(playerid, npcFrankPos[0], npcFrankPos[1], npcFrankPos[2]));
	SendClientMessageEx(playerid, COLOR_GREY, "[SA-MP] You are %d meters away from Frank.", iDistance[1]);
	return 1;
}

CMD:accent(playerid, params[])
{
	if(PlayerInfo[playerid][pACBanned] == 0) {
		ShowPlayerDialog(playerid, DIALOG_ACCENT, DIALOG_STYLE_MSGBOX, "Accent", "Hello, welcome to the accent creator. Abuse can lead to a ban from this feature.\n\
			Would you like to create a custom accent or choose from a selection?", "Custom", "Selection");
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_WHITE "You are currently barred from using custom accents");
	}
	return 1;
}

CMD:b(playerid, params[])
{
    new var[128];
    if(isnull(params)) return SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/b <message>");
    if(TextIPCheck(playerid, params))
		return SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");
 	format(var, sizeof(var), "(( (%i) %s says: %s ))", playerid, GetPlayerNameEx(playerid, 1), params);
    ProxDetector(20.0, playerid, var, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
    return 1;
}

CMD:low(playerid, params[]) return cmd_l(playerid, params);
CMD:l(playerid, params[])
{
	new var[128];
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "(/l)ow <message>");
	if(TextIPCheck(playerid, params))
		return SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");
	format(var, sizeof(var), "%s says quietly: %s", GetPlayerNameEx(playerid, 1), params);
	ProxDetector(5.0, playerid, var, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
	format(var, sizeof(var), "(quietly) %s", params);
	SetPlayerChatBubble(playerid, var, -1, 5.0, 5000);
	return 1;
}

CMD:shout(playerid, params[]) return cmd_s(playerid, params);
CMD:s(playerid, params[])
{
	new var[128];
	if(isnull(params)) return SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "(/s)hout <message>");
	if(TextIPCheck(playerid, params))
		return SendClientMessageEx(playerid, COLOR_RED, "Warning: " COL_YELLOW "You have entered an illegal message. Please revise your text to not include websites/IPs.");
	format(var, sizeof(var), "(shouts) %s!", params);
	SetPlayerChatBubble(playerid, var, -1, 60.0, 5000);
	format(var, sizeof(var), "%s shouts: %s!", GetPlayerNameEx(playerid, 1), params);
	ProxDetector(30.0, playerid, var,-1,-1,-1,COLOR_FADE1,COLOR_FADE2);
	return 1;
}

CMD:find(playerid, params[])
{
	new option[64];
	if(PlayerInfo[playerid][pGPS] == 1) {
		if(!sscanf(params, "s[64]", option)) {
			if(strcmpEx(option, "npc")) {
				ShowPlayerDialog(playerid, DIALOG_FIND_NPC, DIALOG_STYLE_LIST, "Find NPCs", "Find Frank\n\
					Find Juan\n\
					Find Julio",
					"Okay",
					"Cancel"
				);
			}
			else if(strcmpEx(option, "job")) {
				ShowPlayerDialog(playerid, DIALOG_FIND_JOB, DIALOG_STYLE_LIST, "Find Jobs", "Find Trucker\n\
					Find Lumberjack\n",
					"Okay",
					"Cancel"
				);
			}
			else {
				SendClientMessageEx(playerid, COLOR_ORANGE, "Usage Options: " COL_WHITE "You have entered an invalid option");
			}
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/find [option]");
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage Options: " COL_WHITE "NPC, Job");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_GREY, "You need a GPS to complete this action.");
	}
	return 1;
}

CMD:buyhouse(playerid, params[])
{
	new id;
	for(new i = 0; i < MAX_HOUSES; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 1.5, HouseInfo[i][houseExt][0], HouseInfo[i][houseExt][1], HouseInfo[i][houseExt][2])) {
			id = i;
			break;
		}
	}

	if(HouseInfo[id][houseVacant] != 0) {
		SendClientMessageEx(playerid, COLOR_GREY, "This house is already owned.");
		return 1;
	}

	if(PlayerInfo[playerid][pHouseKey1] != -1) {
		SendClientMessageEx(playerid, COLOR_GREY, "You already own a house.");
		return 1;
	}

	if(GetPVarInt(playerid, "confirmPurchase") != 1) {
		SetPVarInt(playerid, "confirmPurchase", 1);
		SendClientMessageEx(playerid, COLOR_GREY, "Please confirm your purchase. Note, your money must be in the bank.");
		return 1;
	}

	if(PlayerInfo[playerid][pBankMoney] < HouseInfo[id][houseCost]) {
		SendClientMessageEx(playerid, COLOR_GREY, "You do not have enough in the bank to afford this house.");
		return 1;
	}

	HouseInfo[id][houseVacant] = 1;
	PlayerInfo[playerid][pHouseKey1] = id;
	format(HouseInfo[id][houseOwner], 24, GetPlayerNameEx(playerid,1));
	UpdateHouseLabel(id);
	GivePlayerBankMoney(playerid, -HouseInfo[id][houseCost]);
	return 1;
}