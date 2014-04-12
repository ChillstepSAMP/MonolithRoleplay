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

	Credits
		The SA-MP team for making it all possible, of course.
		CompuPhase and the copyright holder for Pawn (or Small)
		Scaleta (copyright holder & developer)
		Chaprnks for the general idea.
		Lordz for his help on hooking
*/

//#define DEBUG_ADVDAMAGE
//#define _AdvModifiers
#define MELEE_DAMAGE 9.0

public OnPlayerConnect(playerid)
{
    SetPlayerTeam(playerid, 1);
    #if defined SPC_OnPlayerConnect
    	return SPC_OnPlayerConnect(playerid); //This is being done to get this include compatible with the scripts using it. So in case if those scripts too use the same callback, it would call it.
    #else
   		return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect SPC_OnPlayerConnect

#if defined SPC_OnPlayerConnect
forward SPC_OnPlayerConnect(playerid);
#endif


public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	new Float:damage;
	if(issuerid != INVALID_PLAYER_ID) { /* will keep damage for falling from adding in here */
		switch(weaponid) {
			case WEAPON_BRASSKNUCKLE: damage = MELEE_DAMAGE;
			case WEAPON_GOLFCLUB: damage = MELEE_DAMAGE;
			case WEAPON_NITESTICK: damage = MELEE_DAMAGE;
			case WEAPON_KNIFE: damage = MELEE_DAMAGE;
			case WEAPON_BAT: damage = MELEE_DAMAGE;
			case WEAPON_SHOVEL: damage = MELEE_DAMAGE;
			case WEAPON_POOLSTICK: damage = MELEE_DAMAGE;
			case WEAPON_KATANA: damage = MELEE_DAMAGE;
			case WEAPON_CHAINSAW: damage = 0.0; // job-based weapon
			case WEAPON_DILDO: damage = MELEE_DAMAGE;
			case WEAPON_DILDO2: damage = MELEE_DAMAGE;
			case WEAPON_VIBRATOR: damage = MELEE_DAMAGE;
			case WEAPON_VIBRATOR2: damage = MELEE_DAMAGE;
			case WEAPON_FLOWER: damage = MELEE_DAMAGE;
			case WEAPON_CANE: damage = MELEE_DAMAGE;
			case WEAPON_GRENADE: damage = 85.0;
			case WEAPON_TEARGAS: damage = 20.0;
			case WEAPON_MOLTOV: damage = 25.0;
			case WEAPON_COLT45: damage = 15.0;
			case WEAPON_SILENCED: damage = 25.0;
			case WEAPON_DEAGLE: damage = 55.0;
			case WEAPON_SHOTGUN: damage = 50.0;
			case WEAPON_SAWEDOFF: damage = 35.0;
			case WEAPON_SHOTGSPA: damage = 45.0;
			case WEAPON_UZI: damage = 10.0;
			case WEAPON_MP5: damage = 15.0;
			case WEAPON_AK47: damage = 35.0;
			case WEAPON_M4: damage = 30.0;
			case WEAPON_TEC9: damage = 10.0;
			case WEAPON_RIFLE: damage = 65.0;
			case WEAPON_SNIPER: damage = 75.0;
			case WEAPON_ROCKETLAUNCHER: damage = 100.0;
			case WEAPON_HEATSEEKER: damage = 100.0;
			case WEAPON_FLAMETHROWER: damage = 25.0;
			case WEAPON_MINIGUN: damage = 1.0; /* troll */
			default: damage = MELEE_DAMAGE;
		}

		new Float:armour, Float:hp;
		GetPlayerArmour(playerid, armour);
		GetPlayerHealth(playerid, hp);
		if(armour > 0 && (armour - damage <= 0)) 
			SetPlayerArmour(playerid, 0.0);
		else if(armour > 0 && (armour - damage > 0)) {
			SetPlayerArmour(playerid, armour-damage);
		}
		else {
			SetPlayerArmour(playerid, 0.0); /* just in case */
			SetPlayerHealth(playerid, hp-damage);
		}
		#if defined DEBUG_ADVDAMAGE
			printf("[DEBUG-Z] %i, %i : %.2f, %i, %i", playerid, issuerid, damage, weaponid, bodypart);
		#endif
	}
	#if defined SPC_OnPlayerTakeDamage
    	return SPC_OnPlayerTakeDamage(playerid, issuerid, amount, weaponid, bodypart); //This is being done to get this include compatible with the scripts using it. So in case if those scripts too use the same callback, it would call it.
    #else
   		return 1;
    #endif
}

#if defined _ALS_OnPlayerTakeDamage
    #undef OnPlayerTakeDamage
#else
    #define _ALS_OnPlayerTakeDamage
#endif

#define OnPlayerTakeDamage SPC_OnPlayerTakeDamage

#if defined SPC_OnPlayerTakeDamage
forward SPC_OnPlayerTakeDamage(playerid, issuerid, amount, weaponid, bodypart);
#endif

public OnGameModeInit()
{
	EnableVehicleFriendlyFire();
	#if defined SPC_OnGameModeInit
		return SPC_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit SPC_OnGameModeInit

#if defined SPC_OnGameModeInit
	forward SPC_OnGameModeInit();
#endif