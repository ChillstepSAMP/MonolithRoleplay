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

	----

	There are two types of jobs that you can have. Ones that have a base paycheck, and those that
	just add onto your paycheck as you do them.
*/

//SPECIAL_ACTION_CARRY

OnLoadTrees()
{
	//format(query, sizeof(query), "SELECT * from `trees`");
	//mysql_function_query(gSQLHandle, query, true, "LoadTrees", "");
	return 1;
}

UpdateTreeLabel(i, moved = 0) 
{
	new text[64];
	#define label TreeInfo[i][treeLabel]
	if(TreeInfo[i][treeType] == 0) 
		format(text, sizeof(text), "Lubmer Jack " COL_WHITE "Job\n" COL_GREY "Type /join to get job");
	else if(TreeInfo[i][treeType] == 1)
		format(text, sizeof(text), "Light Timber " COL_WHITE "Tree\n" COL_GREY "Type /chop to begin chopping");
	else
		format(text, sizeof(text), "Heavy Timber " COL_WHITE "Tree\n" COL_GREY "Type /chop to begin chopping");
	if(!moved)
		UpdateDynamic3DTextLabelText(label, COLOR_GREEN, text);
	else {
		if(IsValidDynamic3DTextLabel(label)) 
			DestroyDynamic3DTextLabel(label);
		label = CreateDynamic3DTextLabel(text, COLOR_GREEN, TreeInfo[i][treePos][0], TreeInfo[i][treePos][1], TreeInfo[i][treePos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
	}
	return 1;
}

public LoadTrees()
{
	new fields, rows, fetch[16];
    cache_get_data(rows, fields, gSQLHandle);
    
    for(new i = 0; i < rows; i++) {
    	cache_get_field_content(i, "treeID", fetch, gSQLHandle, MAX_INT);
    	TreeInfo[i][treeID] = strval(fetch);
    	cache_get_field_content(i, "treeType", fetch, gSQLHandle, MAX_INT);
    	TreeInfo[i][treeType] = strval(fetch);
    	UpdateTreeLabel(i, 1);
    }
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_JOIN_JOB) {
		SetPVarInt(playerid, "WorkingJob", GetPVarInt(playerid, "JoiningID"));
		DeletePVar(playerid, "JoiningID");

		new szStr[16];
		switch(GetPVarInt(playerid, "WorkingJob")) {
			case 1: szStr = "Lumberjack";
		}
		SendClientMessageEx(playerid, COLOR_GREEN, "Job: " COL_WHITE "You are now working as a %s.", szStr);
		SendClientMessageEx(playerid, COLOR_YELLOW, "Job Note: " COL_WHITE "This job is not permanent, and only adds to your paycheck as your work");
	}
	return 1;
}

CMD:join(playerid, params[])
{
	for(new i = 0; i < MAX_TREES; i++) {
		if(IsPlayerInRangeOfPoint(playerid, 3.0, TreeInfo[i][treePos][0], TreeInfo[i][treePos][1], TreeInfo[i][treePos][2])) {
			if(TreeInfo[i][treeType] == 0) {
				SetPVarInt(playerid, "JoiningID", 1);
				ShowPlayerDialog(playerid, DIALOG_JOIN_JOB, DIALOG_STYLE_MSGBOX, COL_GREEN "Lumber Jack", 
					COL_WHITE "Are you sure you would like to become a lumber jack", "Confirm", "Cancel");
				break;
			}
		}
	}
	return 1;
}

CMD:chop(playerid, params[])
{
	if(GetPVarInt(playerid, "WorkingJob") == JOB_LUMBER) {
		if(PlayerInfo[playerid][usingTreeID] != -1) {
			return SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You are already cutting a tree");
		} 
		for(new i = 0; i < MAX_TREES; i++) {
			if(IsPlayerInRangeOfPoint(playerid, 3.0, TreeInfo[i][treePos][0], TreeInfo[i][treePos][1], TreeInfo[i][treePos][2])) {
				if(TreeInfo[i][treeType] != 0) {
					PlayerInfo[playerid][usingTreeID] = i;
					SetPlayerArmedWeapon(playerid, WEAPON_CHAINSAW); /* harmless weapon, with SPC added. */
				}
			}
		}
	}
	return 1;
}

CMD:createtree(playerid, params[])
{
	new type;
	if(PlayerInfo[playerid][pStaff] >= STAFF_SADMIN) {
		if(!sscanf(params, "d", type)) {
			new id, Float:fPos[3];
			for(new i = 0; i < MAX_TREES; i++) {
				if(TreeInfo[i][treePos][0] == 0.0 && TreeInfo[i][treePos][1] == 0.0 && TreeInfo[i][treePos][2] == 0.0) {
					id = i;
					break;
				}
			}
			GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
			TreeInfo[id][treePos][0] = fPos[0];
			TreeInfo[id][treePos][1] = fPos[1];
			TreeInfo[id][treePos][2] = fPos[2];
			UpdateTreeLabel(id, 1); // it's easier to update it, where the function will just create it.
			SendClientMessageEx(playerid, COLOR_GREEN, "Tree" COL_WHITE "You have successfully made a tree at your position.");
		}
		else {
			SendClientMessageEx(playerid, COLOR_ORANGE, "Usage: " COL_WHITE "/createtree [type]");
		}
	}
	else {
		SendClientMessageEx(playerid, COLOR_RED, "Error: " COL_WHITE "You are not authorized to use this command.");
	}
	return 1;
}