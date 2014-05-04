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

	This file will include the entire gamemode together.

	Most of the original code was designed for The Heist and is incomplete.
	Some features have been removed, as the continual use of the script within the project.

	This script has been re-licensed and is no longer subject to the one from The Heist.

	Other than myself (and Shane for the EXP formula), the only other contributor was Brad and his code was removed.
*/

/* for YSI related includes... */
#define MODE_NAME "Monolith Roleplay"

/* SA-MP's Base Include */
#include <a_samp>

/* Zeex's Command Processor */
#include <zcmd>

/* Y_Less' SSCANF */
#include <sscanf2>

/* Y_Less' YSI Library */
#include <YSI\y_iterate>
#include <YSI\y_timers>
#include <YSI\y_hooks>
#include <YSI\y_flooding>
//#include <YSI\y_svar>

/* BlueG's MySQL */
#include <a_mysql>

/* Icognito's Plugins */
#include <streamer>
#include <gvar>

/* Scaleta's SPC Library
		I personally prefer the 'older' version of handling damage, which is defined.
*/
#define damageversion "13D"
#include <SPC>

/* Slice's TimerFix */
#include <timerfix>

#define _Alpha
#define MRP_DEBUG
#define VERSION	"v0.9-alpha"

/* Performance related */
#undef MAX_PLAYERS
#define MAX_PLAYERS 100

main()
{
	print("\n---------------------------------------------");
	print("Monolith RP (Public Release) by Scaleta!");
	print("---------------------------------------------\n");
}

// INIT MAIN //
#include "../MRP/main/config.pwn"
#include "../MRP/main/enums.pwn"
#include "../MRP/main/global.pwn"
#include "../MRP/main/colors.pwn"
#include "../MRP/main/callbacks.pwn"
#include "../MRP/main/functions.pwn"
#include "../MRP/main/tasks.pwn"


// INIT PLAYER //
#include "../MRP/player/acommands.pwn"
#include "../MRP/player/commands.pwn"
#include "../MRP/player/anims.pwn"
#include "../MRP/player/jobs.pwn" // -- not completely functioning or tested at all.
