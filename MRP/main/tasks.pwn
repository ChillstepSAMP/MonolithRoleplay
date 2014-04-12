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

// DESC: Usually called a heartbeat, but I'm a trololol.
// TICK: 1 second.
task Lungs[1000]() {
	foreach(Player, playerid) {
		if(LoginStatus[playerid] != 0) {

			/*new Float:health, Float:armour;
			GetPlayerHealth(playerid, health);
			GetPlayerArmour(playerid, armour);
			if(health != PlayerInfo[playerid][pHealth]) {
				SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
			}
			if(armour != PlayerInfo[playerid][pArmour]) {
				SetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);
			}*/

			/* Players variable is reset on login, so it is a breach to have it set. */
			if(GetPVarInt(playerid, "AdminDuty") > 0 && PlayerInfo[playerid][pStaff] == 0) {
				foreach(Player, i) { /* Send the staff a warning message */
					if(PlayerInfo[i][pStaff] > 0) 
						SendClientMessageEx(i, COLOR_RED, "Warning: " COL_YELLOW "%s was found to have AdminDuty set and not be an admin.", GetPlayerNameEx(playerid, 1));
				}
				Kick(playerid);
			}

			if(GetPlayerMoney(playerid) != PlayerInfo[playerid][pMoneyOnHand]) {
				ResetMoneyBar(playerid);
			}
			if(GetPlayerScore(playerid) != PlayerInfo[playerid][pLevel]) {
				SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
			}
			if(PlayerInfo[playerid][pTDTime] != 0 && PlayerInfo[playerid][pTDTime] <= gettime()) {
				if(GetPVarInt(playerid, "TDToHide") == 1) {
					HideAchievementGUIFrame(playerid);
					DeletePVar(playerid, "TDToHide");
				}
				else {
					TextDrawHideForPlayer(playerid, PlayerInfo[playerid][pTDInfo]);
				}
				PlayerInfo[playerid][pTDTime] = 0;
			}

			if(PlayerInfo[playerid][pAchievementRiskTaker] != 1 && PlayerInfo[playerid][pMoneyOnHand] > 20000) {
				AchievementHandler(playerid, A_RISKTAKER, 2);
			}
			else if(PlayerInfo[playerid][pAchievementRichMcRich] != 1 && (PlayerInfo[playerid][pBankMoney] + PlayerInfo[playerid][pMoneyOnHand] >= 10000000)) {
				AchievementHandler(playerid, A_RICH, 8);
			}
			
			PlayerInfo[playerid][pConnectedSeconds]++;
			if(PlayerInfo[playerid][pConnectedSeconds] >= 60) {
				PlayerInfo[playerid][pConnectedSeconds] = 0;
				PlayerInfo[playerid][pConnectedMinutes]++;

				if(PlayerInfo[playerid][pConnectedMinutes] >= 60) {
					PlayerInfo[playerid][pConnectedMinutes] = 0;
					PlayerInfo[playerid][pConnectedTotal]++;
				}
			}
			if(GetPVarInt(playerid, "AdminDuty") != 1) SetPVarInt(playerid, "afkTimer", GetPVarInt(playerid, "afkTimer")+1);

			if(GetPVarInt(playerid, "afkTimer") > 120 && PlayerInfo[playerid][pStaff] != STAFF_HADMIN) {
				SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_YELLOW "You have been kicked for being AFK for more than 2 minutes");
				SetTimerEx("KickDelay", 500, false, "i", playerid);
			}

			if(PlayerInfo[playerid][pTruck] != INVALID_VEHICLE_ID) {
				if(gettime() > GetPVarInt(playerid, "TruckerReturn") && PlayerInfo[playerid][TruckerStage] >= 4) {
					DestroyVehicle(PlayerInfo[playerid][pTruck]);
					PlayerInfo[playerid][pTruck] = INVALID_VEHICLE_ID;
					SendClientMessageEx(playerid, COLOR_RED, "Notice: " COL_YELLOW "You have been fined $200 for failing to return the truck in 5 minutes.");
					GivePlayerMoneyEx(playerid, -200);
					PlayerInfo[playerid][TruckerStage] = 0;
					DisablePlayerCheckpoint(playerid);
				}
			}
		}
	}
}

// DESC: Drop money of player over defined limit.
// TICK: 5 seconds.
new waitt[MAX_PLAYERS];
task moneyDropTimer[5000]() {
	foreach(Player, i) {
		if(LoginStatus[i] != 0) {
			if(!IsPlayerInAnyVehicle(i)) {
				if(PlayerInfo[i][pMoneyOnHand] > 20000 && gettime() > waitt[i]) {
					DropPlayerMoney(i);
					SendClientMessageEx(i, COLOR_PURPLE, "** You feel some of your money start to drop from your pockets.");
					waitt[i] = gettime()+45; // Default: 45 seconds
				}
			}
		}
	}
}

// DESC: Cleanup objects and pickups.
// TICK: 120 Seconds.
task ObjectCleanUp[120000]() {
	for(new i = 0; i < MAX_MIDS; i++) {
		if(MoneyPacket[i][mLifeSpan] < gettime()) {
			DestroyMPacket(i);
		}
	}
}

// DESC: Unfreeze a player, generally for streamprep.
// TIME: 5 seconds.
/*timer Freeze_Handler[5000](playerid)
{
	TogglePlayerControllable(playerid, 1);
	return 1;
}*/