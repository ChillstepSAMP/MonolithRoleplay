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

/* GLOBAL VARIABLES */
new
	/* SERVER */
	gSQLHandle,
	query[512], /* queries can get big */
	va_str[128],
	Text:AchievementTD[4],

	/* OBJECTS */ 
	MoneyPacket[MAX_MIDS][mpInfo],

	/* PLAYER */
	PlayerInfo[MAX_PLAYERS][pInfo],
	LoginStatus[MAX_PLAYERS],
	lastHealthUpdate[MAX_PLAYERS],
	healthUpdateFail[MAX_PLAYERS char],
	lastArmourUpdate[MAX_PLAYERS],
	armourUpdateFail[MAX_PLAYERS char],


	/* SYSTEMS */
	ATMInfo[MAX_ATMS][aInfo],
	Text3D:aLabels[MAX_ATMS],
	DoorInfo[MAX_DOORS][dInfo],
	Text3D:dLabels[MAX_DOORS],
	TreeInfo[MAX_TREES][tInfo],
	InfoEnum[MAX_INFOS][hEnum],
	TowerInfo[MAX_TOWERS][towerInfo],
	ao[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][attached_object_data],

	/* NPCS */
	npcFrank,
	npcJulio,
	npcJuan,

	/* Only allowing 64 spawned vehicles */
	user_spawned_vehs[64] = INVALID_VEHICLE_ID,
	LastVehUsed[MAX_VEHICLES][MAX_PLAYER_NAME]
;

new VehicleNames[(212 + 1)][255] = {
   	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Pereniel", "Sentinel", "Dumper", "Firetruck", "Trashmaster","Stretch","Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington","Bobcat", "Mr Whoopee","BF Injection",
 	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Artical Trailer", "Previon", "Coach", "Cabbie",
 	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer (Stones)", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider","Glendale",
 	"Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR3 50", "Walton", "Regina", "Comet", "BMX", "Burrito",
	"Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact",
 	"Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT", "Elegant", "Journey",
  	"Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt", "Tanker", "RoadTrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000",
  	"Cement Truck", "Tow Truck", "Fortune", "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
  	"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler","Intruder", "Primo", "Cargobob", "Tampa","Sunrise", "Merit", "Utility", "Nevada",
 	"Yosemite", "Windsor", "Monster A","Monster B", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
 	"Train Freight (Flat)", "Train Freight (Cabin)", "Kart", "Mower", "Duneride", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
 	"Newsvan", "Tug", "Trailer (Petrol)", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "Trailer (Freight Box)", "Trailer (Blank Article)", "Andromada", "Dodo",
 	"RC Cam", "Launch", "Police Car (LSPD)", "Police Car (SFPD)", "Police Car (LVPD)", "Police Ranger", "Picador", "S.W.A.T. Van", "Alpha","Phoenix", "Glendale",
    "Sadler", "Luggage Trailer (Box)", "Luggage Trailer (Flat)", "Stairs Trailer", "Boxville", "Farm Plow", "Utility Trailer (Generator)", "Invalid Vehicle"
};

new Float:LegalTruckPoints[17][3] = {
	{1837.99, -1832.87, 13.58},
	{1922.96, -1789.80, 12.94},
	{1339.20, -1765.12, 13.09},
	{2378.93, -2010.48, 13.12},
	{1017.82, -1931.38, 12.09},
	{1056.83, -1495.82, 13.10},
	{1024.70, -1367.63, 13.12},
	{1171.40, -881.68, 42.90},
	{1308.91, -870.57, 39.14},
	{2148.10, -1203.30, 23.42},
	{2391.54, -1510.43, 23.40},
	{2477.72, -1747.33, 13.12},
	{2476.53, -1527.52, 23.57},
	{1751.44, -1455.15, 13.11},
	{1584.00, -1414.47, 13.16},
	{1594.46, -1278.18, 17.01},
	{1246.58, -2057.52, 59.35}
};

new Float:IllegalTruckPoints[8][3] = {
	{2156.27, -1869.43, 13.12},
	{2261.26, -1938.67, 13.11},
	{933.46, -1623.77, 13.12},
	{998.69, -1104.96, 23.39},
	{2112.19, -1087.99, 24.15},
	{2171.04, -1432.64, 23.54},
	{2390.85, -1470.91, 23.52},
	{2733.47, -1944.11, 13.11}
};