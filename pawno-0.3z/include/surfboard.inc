/*  surfboard.inc
 *
 *  (c) Copyright 2010, Emilijo "Correlli" Lovrich
 *
 *  Credits: - Y_Less for foreach & GetXYInFrontOfPlayer functions & ZeeX for zcmd command processor.
*/

#if defined _surfboard_included
	#endinput
#endif
#define _surfboard_included

#if !defined _samp_included
	#error "You'll need to include the a_samp.inc include file before the surfboard.inc file!"
#endif

/* ----- */

#undef MAX_PLAYERS
#define MAX_PLAYERS (500)

#if !defined MAX_SURFBOARDS
	#define MAX_SURFBOARDS (50)
#endif

#if !defined MAX_SURFBOARD_SPEED
	#define MAX_SURFBOARD_SPEED (400.0)
#endif

#if !defined INVALID_SURFBOARD_ID
	#define INVALID_SURFBOARD_ID (-1)
#endif

/* ----- */

static
		bool:gOPF[3] = false;

/* ----- */

enum dataSurfboard
{
	modelID,
	objectID,
	Float:speed,
	Float:position[7]
}

new
		surfboardID = INVALID_SURFBOARD_ID, surfboardData[MAX_SURFBOARDS][dataSurfboard],
		Float:surfboardGoTo[MAX_SURFBOARDS][3], bool:firstSurfboard = false, sbTimer;

/* ----- */

stock CreateSurfboard(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz = 0.0)
{
	surfboardID++;
	if(surfboardID == MAX_SURFBOARDS)
	{
		printf("Limit of surfboards exceeded. Open the surfboard.inc and change the \"MAX_SURFBOARDS\" define to bigger value if you want to have more surfboards.\
				\nDon't forget that object limit in the current SA:MP version (0.3b) is 400, so it's a good thing to use an object-streamer if you're having many surfboards on server.");
		surfboardID--;
		return INVALID_SURFBOARD_ID;
	}
	new
			toSurfboardID = GetFreeSurfboardID();
	if(toSurfboardID == INVALID_SURFBOARD_ID)
	{
		print("Error: There are no surfboard IDs free.");
		surfboardID--;
		return INVALID_SURFBOARD_ID;
	}
	if(modelid < 1 || modelid > 3)
	{
		printf("Invalid model-ID at function \"CreateSurfboard\". Valid model-IDs are 1, 2 and 3.");
		surfboardID--;
		return INVALID_SURFBOARD_ID;
	}
	surfboardData[toSurfboardID][modelID] = modelid;
	surfboardData[toSurfboardID][position][0] = x;
	surfboardData[toSurfboardID][position][1] = y;
	surfboardData[toSurfboardID][position][2] = z;
	surfboardData[toSurfboardID][position][3] = rx;
	surfboardData[toSurfboardID][position][4] = ry;
	surfboardData[toSurfboardID][position][5] = rz;
	surfboardData[toSurfboardID][position][6] = rz;
	surfboardData[toSurfboardID][speed] = 0.0;
	surfboardData[toSurfboardID][objectID] = CreateObject(2403 + modelid, x, y, z, rx, ry, rz);
	if(!firstSurfboard)
	{
		firstSurfboard = true;
		//sbTimer = SetTimer("surfboard_Timer", 1000, true);
	}
	return toSurfboardID;
}

stock DestroySurfboard(sbid)
{
	if(IsSurfboardCreated(sbid))
	{
		surfboardID--;
		surfboardData[sbid][modelID] = 0;
		surfboardData[sbid][position][0] = 0.0;
		surfboardData[sbid][position][1] = 0.0;
		surfboardData[sbid][position][2] = 0.0;
		surfboardData[sbid][position][3] = 0.0;
		surfboardData[sbid][position][4] = 0.0;
		surfboardData[sbid][position][5] = 0.0;
		surfboardData[sbid][position][6] = 0.0;
		surfboardData[sbid][speed] = 0.0;
		DestroyObject(surfboardData[sbid][objectID]);
		if(surfboardID == INVALID_SURFBOARD_ID)
		{
			firstSurfboard = false;
			KillTimer(sbTimer);
		}
		for(new u = 0; u < MAX_PLAYERS; u++)
		{
			if((GetPVarInt(u, "surfboardID") - 1) == sbid)
			{
				SetPVarInt(u, "surfboardID", 0);
				ClearAnimations(u);
				SendClientMessage(u, 0xFFFFFFFF, "The surfboard has been deleted by an administrator!");
				break;
			}
		}
		return true;
	}
	return false;
}

stock IsSurfboardCreated(sbid)
{
	if(surfboardData[sbid][modelID]) return true;
	return false;
}

stock GetNumberOfSurfboards() return surfboardID;

stock GetFreeSurfboardID()
{
	new
			sbid = INVALID_SURFBOARD_ID;
	for(new a = 0; a < MAX_SURFBOARDS; a++)
	{
		if(!IsSurfboardCreated(a))
		{
			sbid = a;
			break;
		}
	}
	return sbid;
}

stock StopSurfboard(sbid)
{
	if(!IsSurfboardCreated(sbid)) return false;
	surfboardData[sbid][speed] = 0.0;
	StopObject(surfboardData[sbid][objectID]);
	return true;
}

stock RespawnSurfboard(sbid)
{
	if(!IsSurfboardCreated(sbid)) return false;
	DestroyObject(surfboardData[sbid][objectID]);
	surfboardData[sbid][position][5] = surfboardData[sbid][position][6];
	surfboardData[sbid][objectID] = CreateObject(2403 + surfboardData[sbid][modelID], surfboardData[sbid][position][0], surfboardData[sbid][position][1], surfboardData[sbid][position][2], surfboardData[sbid][position][3], surfboardData[sbid][position][4], surfboardData[sbid][position][5]);
	return true;
}

stock SetSurfboardSpeed(sbid, Float:surfspeed = MAX_SURFBOARD_SPEED)
{
	if(!IsSurfboardCreated(sbid)) return false;
	if(surfspeed > MAX_SURFBOARD_SPEED) surfboardData[sbid][speed] = MAX_SURFBOARD_SPEED;
	else surfboardData[sbid][speed] = surfspeed;
	return true;
}

stock IsPlayerAtSurfboard(playerid, sbid)
{
	new
			Float:pos[3];
	GetObjectPos(surfboardData[sbid][objectID], pos[0], pos[1], pos[2]);
	if(IsPlayerInRangeOfPoint(playerid, 1.5, pos[0], pos[1], pos[2])) return true;
	return false;
}

stock IsPlayerAtAnySurfboard(playerid)
{
	new
			a = 0;
	for(a = 0; a < MAX_SURFBOARDS; a++)
	{
		if(IsPlayerAtSurfboard(playerid, a)) return a;
	}
	return INVALID_SURFBOARD_ID;
}

stock IsSurfboardOccupied(sbid)
{
	if(!IsSurfboardCreated(sbid)) return INVALID_PLAYER_ID;
	for(new u = 0; u < MAX_PLAYERS; u++)
	{
		if((GetPVarInt(u, "surfboardID") - 1) == sbid) return u;
	}
	return INVALID_PLAYER_ID;
}

/* ----- */

stock GetXYInFrontOfPlayerOnSB(playerid, &Float:x, &Float:y, Float:distance)
{
	new
			Float:angle;
	GetPlayerPos(playerid, x, y, angle);
	GetPlayerFacingAngle(playerid, angle);
	x += (distance * floatsin(-angle + 270.0, degrees));
	y += (distance * floatcos(-angle + 270.0, degrees));
}

/* ----- */

task SurfUpdate[5000]()
{
	for(new u = 0; u < MAX_PLAYERS; u++)
	{
		new
				sbid = GetPVarInt(u, "surfboardID") - 1;
		if(sbid != INVALID_SURFBOARD_ID)
		{
			if(GetPVarInt(u, "isSurfing") != 0 || GetPVarInt(u, "surfing") != 0) {
			
				new Float: pos[3], Float: objPos[3];
				GetObjectPos(surfboardData[sbid][objectID], objPos[0], objPos[1], objPos[2]);
				GetPlayerPos(u, pos[0], pos[1], pos[2]);
				if(pos[2] < objPos[2])
				{
					StopSurfboard(sbid);
					RespawnSurfboard(sbid);
					SetPVarInt(u, "surfboardID", 0);
					SetPVarInt(u, "isSurfing", 0);
					SetPVarInt(u, "pendingsurfevent", 0);
					SetPVarInt(u, "currentlyissurf", 0);
					ClearAnimations(u);
					TogglePlayerControllable(u, 1);
					DisablePlayerRaceCheckpoint(u);
					SetPlayerPos(u, 324.6641,-1892.0195,1.7212);
					SendClientMessage(u, 0x0F9AF7FF, "You have fell off your surfboard & has been disqualified from the race.");
				} else {
					new rdm = random(6);
					if(rdm == 3) {
						ApplyAnimation(u, "OTB", "wtchrace_win", 4.0, 1, 0, 0, 0, 0);
						SendClientMessage(u, 0x0F9AF7FF, "Incoming wave!");
						SetTimerEx("ResetAnim", 3000, false, "i", u);
					} else return 1;
				}	
			}	
		}
	}
	return 1;
}	

forward ResetAnim(playerid);
public ResetAnim(playerid)
{
	ApplyAnimation(playerid, "BSKTBALL", "BBALL_def_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}	

forward surfboard_Timer();
public surfboard_Timer()
{
	for(new u = 0; u < MAX_PLAYERS; u++)
	{
		new
				sbid = GetPVarInt(u, "surfboardID") - 1;
		if(sbid != INVALID_SURFBOARD_ID)
		{
			if(!IsPlayerAtSurfboard(u, sbid))
			{
				StopSurfboard(sbid);
				RespawnSurfboard(sbid);
				SetPVarInt(u, "surfboardID", 0);
				ClearAnimations(u);
				SendClientMessage(u, 0xFFFFFFFF, "Surfing stopped - surfboard is re-spawned.");
			}
		}
	}
	return true;
}

/* ----- */

/*
command(surf, playerid, params[])
{
	new
			Float:objPos[3];
	if(!GetPVarInt(playerid, "surfboardID"))
	{
		if(GetPVarInt(playerid, "surfingAccess") == 1)
		{	
			if(GetPVarInt(playerid, "isSurfing") == 1)
				return SendClientMessage(playerid, -1, "You're already in the surfing event!");
				
			new
					sbid = IsPlayerAtAnySurfboard(playerid);
			if(sbid != INVALID_SURFBOARD_ID)
			{
				new
						isOccupied = IsSurfboardOccupied(sbid);
				if(isOccupied != INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFFFFFFFF, "This surfboard is currently occupied!");
				SetPVarInt(playerid, "surfboardID", sbid + 1);
				SetPVarInt(playerid, "isSurfing", 1);
				GetObjectPos(surfboardData[sbid][objectID], objPos[0], objPos[1], objPos[2]);
				SetPlayerPos(playerid, objPos[0], objPos[1], objPos[2] + 1.0);
				SetPlayerFacingAngle(playerid, surfboardData[sbid][position][5] + 270.0);
				ApplyAnimation(playerid, "BSKTBALL", "BBALL_def_loop", 4.0, 1, 0, 0, 0, 0);
				TogglePlayerControllable(playerid, 0);				
			    SetPVarInt(playerid, "pendingsurfevent", 1);
				SendClientMessage(playerid, 0xF2EF27FF, "You joined the {FF2200}surfing event{F2EF27}, please wait until an admin starts the race.");
			}
			else SendClientMessage(playerid, 0xFFFFFFFF, "You're not ontop of surfboard");
		}
		else SendClientMessage(playerid, -1, "You do not have access to this command, sorry.");	
	} else SendClientMessage(playerid, -1, "You cannot quit the event at this point.");
	else
	{
		StopSurfboard(GetPVarInt(playerid, "surfboardID") - 1);
		SetPVarInt(playerid, "surfboardID", 0);
		SetPVarInt(playerid, "isSurfing", 0);
		ClearAnimations(playerid);
		SendClientMessage(playerid, 0xFFFFFFFF, "Surfing stopped. Use \"/surf\" command to start with the surfing again.");
	} 
	return true;
} */

/* ----- */

public OnPlayerConnect(playerid)
{
	ApplyAnimation(playerid, "BSKTBALL", "null", 0.0, 0, 0, 0, 0, 0);

	if(gOPF[0]) CallLocalFunction("surfboard_OnPlayerConnect", "i", playerid);
	return true;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect surfboard_OnPlayerConnect

forward surfboard_OnPlayerConnect(playerid);



public OnPlayerDisconnect(playerid, reason)
{
	new
			sbid = GetPVarInt(playerid, "surfboardID") - 1;
	if(sbid != INVALID_SURFBOARD_ID)
	{
		StopSurfboard(sbid);
		RespawnSurfboard(sbid);
	}

	if(gOPF[1]) CallLocalFunction("surfboard_OnPlayerDisconnect", "ii", playerid, reason);
	return true;
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect surfboard_OnPlayerDisconnect

forward surfboard_OnPlayerDisconnect(playerid, reason);

public OnPlayerUpdate(playerid)
{
	new
			sbid = GetPVarInt(playerid, "surfboardID") - 1;
	if(sbid != INVALID_SURFBOARD_ID)
	{
		if(GetPVarInt(playerid, "fsurfing") != 1) return 1;
	
		new
				keys[3], Float:floatVal[4];
		GetPlayerPos(playerid, floatVal[0], floatVal[1], floatVal[2]);
		floatVal[3] = surfboardData[sbid][speed];
		GetPlayerKeys(playerid, keys[0], keys[1], keys[2]);
		GetXYInFrontOfPlayerOnSB(playerid, floatVal[0], floatVal[1], 50.0);
		surfboardGoTo[sbid][0] = floatVal[0];
		surfboardGoTo[sbid][1] = floatVal[1];
		surfboardGoTo[sbid][2] = surfboardData[sbid][position][2];
		
		if(keys[1] == KEY_UP)
		{
			if(GetPVarInt(playerid, "pendingsurfevent") == 1)
				return 1;
				
			if(floatVal[3] >= 0.0 && floatVal[3] < MAX_SURFBOARD_SPEED) surfboardData[sbid][speed] += 0.10;
			if(floatVal[3] >= MAX_SURFBOARD_SPEED) surfboardData[sbid][speed] = MAX_SURFBOARD_SPEED;
		}
		else if(keys[1] == KEY_DOWN)
		{
			if(GetPVarInt(playerid, "pendingsurfevent") == 1)
				return 1;
				
			if(floatVal[3] >= 0.0 && floatVal[3] < MAX_SURFBOARD_SPEED) surfboardData[sbid][speed] -= 0.10;
			if(floatVal[3] >= MAX_SURFBOARD_SPEED) surfboardData[sbid][speed] = MAX_SURFBOARD_SPEED;
		}
		if(keys[2] == KEY_LEFT)
		{
			if(GetPVarInt(playerid, "pendingsurfevent") == 1)
				return 1;
				
			surfboardData[sbid][speed] -= 0.01;
			surfboardData[sbid][position][5] += 1.5;
			SetObjectRot(surfboardData[sbid][objectID], surfboardData[sbid][position][3], surfboardData[sbid][position][4], surfboardData[sbid][position][5]);
			SetPlayerFacingAngle(playerid, surfboardData[sbid][position][5] + 270.0);
			surfboardGoTo[sbid][0] = floatVal[0];
			surfboardGoTo[sbid][1] = floatVal[1];
			surfboardGoTo[sbid][2] = surfboardData[sbid][position][2];
		}
		else if(keys[2] == KEY_RIGHT)
		{
			if(GetPVarInt(playerid, "pendingsurfevent") == 1)
				return 1;
				
			surfboardData[sbid][speed] -= 0.01;
			surfboardData[sbid][position][5] -= 1.5;
			SetObjectRot(surfboardData[sbid][objectID], surfboardData[sbid][position][3], surfboardData[sbid][position][4], surfboardData[sbid][position][5]);
			SetPlayerFacingAngle(playerid, surfboardData[sbid][position][5] + 270.0);
			surfboardGoTo[sbid][0] = floatVal[0];
			surfboardGoTo[sbid][1] = floatVal[1];
			surfboardGoTo[sbid][2] = surfboardData[sbid][position][2];
		}
		if(surfboardData[sbid][speed] > 0.010)
		{
			if(GetPVarInt(playerid, "pendingsurfevent") == 1)
				return 1;
				
			surfboardData[sbid][speed] -= 0.010;
			MoveObject(surfboardData[sbid][objectID], surfboardGoTo[sbid][0], surfboardGoTo[sbid][1], surfboardGoTo[sbid][2], surfboardData[sbid][speed]);
		}
		else StopSurfboard(sbid);
	}

	if(gOPF[2]) CallLocalFunction("surfboard_OnPlayerUpdate", "i", playerid);
	return true;
}

#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate surfboard_OnPlayerUpdate

forward surfboard_OnPlayerUpdate(playerid);



public OnGameModeInit()
{
	gOPF[0] = (funcidx("surfboard_OnPlayerConnect") != -1);
	gOPF[1] = (funcidx("surfboard_OnPlayerDisconnect") != -1);
	gOPF[2] = (funcidx("surfboard_OnPlayerUpdate") != -1);
	CallLocalFunction("surfboard_OnGameModeInit", "");
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit surfboard_OnGameModeInit

forward surfboard_OnGameModeInit();
