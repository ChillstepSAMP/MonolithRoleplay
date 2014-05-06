/*
		DataInsert - an official product by Zachary Griffeth

		Developers
			- Zachary Griffeth (Skyrise)

		FILE: FINSERT.PWN

        Copyright (c) 2014 Zachary Griffeth

        YOU MAY NOT UNDER ANY CIRCUMSTANCE:
        use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
        the Software WITHOUT EXPRESS WRITTEN PERMISSION FROM COPYRIGHT OWNER.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
        FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
        COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
        IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
        CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

        ALL RIGHTS OF INCLUDES/SOURCES ARE TO THEIR RESPECTIVE OWNERS.
*/

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <zcmd>

#define SQL_SERVER 	"localhost"
#define SQL_USER	"root"
#define SQL_DB		"test"
#define SQL_PASS	""

#define DIALOG_TELEPORT       (800)
#define DIALOG_TELEPORT_2     (801)
#define DIALOG_TELEPORT_3     (802)
#define DIALOG_TELEPORT_4     (804)
#define DIALOG_TELEPORT_5     (805)
#define DIALOG_TELEPORT_6     (806)
#define DIALOG_TELEPORT_7     (807)
#define DIALOG_TELEPORT_8     (808)
#define DIALOG_TELEPORT_9     (809)
#define DIALOG_TELEPORT_10    (810)
#define DIALOG_TELEPORT_11    (811)
#define DIALOG_TELEPORT_12    (812)
#define DIALOG_TELEPORT_13    (813)
#define DIALOG_TELEPORT_14    (814)
#define DIALOG_TELEPORT_15    (815)
#define DIALOG_TELEPORT_16    (816)
#define DIALOG_TELEPORT_17    (817)
#define DIALOG_TELEPORT_18    (818)
#define DIALOG_TELEPORT_19	  (819)

forward MySQL_Finish();

new fSQLHandle = 1;

public OnFilterScriptInit()
{
    //fSQLHandle = mysql_connect( SQL_SERVER, SQL_USER, SQL_DB, SQL_PASS );
    //mysql_log();
	print("\n--------------------------------------");
	print(" Skyrise's Resources Library");
	print(" MySQL Data Insertion, by Skyrise.");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

CMD:insert(playerid, params[]) 
{
	new query[128], escapedstring[128], rows;
	if(!sscanf(params, "I(-1)s[128]", rows, query)) {
		if(rows != -1) {
			mysql_real_escape_string(query, escapedstring, fSQLHandle);
			for(new i = 0; i < rows; i++) {
				mysql_function_query(fSQLHandle, escapedstring, false, "MySQL_Finish", "");
			}
		}
		else {
			mysql_real_escape_string(query, escapedstring, fSQLHandle);
			mysql_function_query(fSQLHandle, escapedstring, false, "MySQL_Finish", "");
		}
		SendClientMessage(playerid, -1, "Query sent.");
	}
	else {
		SendClientMessage(playerid, -1, "Please enter a query.");
	}
	return 1;
}

CMD:teleports(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
	return 1;
}

// Emmet
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_TELEPORT:
		{
			if (response)
			{
				switch (listitem)
				{
				   	case 0: ShowPlayerDialog(playerid, DIALOG_TELEPORT_2, DIALOG_STYLE_LIST, "24/7's", "24/7 Interior 1\n24/7 Interior 2\n24/7 Interior 3\n24/7 Interior 4\n24/7 Interior 5\n24/7 Interior 6\nBack", "Select", "Cancel");
					case 1: ShowPlayerDialog(playerid, DIALOG_TELEPORT_3, DIALOG_STYLE_LIST, "Airports", "Francis Ticket Sales Airport\nFrancis Baggage Claim Airport\nAndromada Cargo Hold\nShamal Cabin\nLS Airport Baggage Claim\nInterernational Airport\nAbandoned AC Tower\nBack", "Select", "Cancel");
					case 2: ShowPlayerDialog(playerid, DIALOG_TELEPORT_4, DIALOG_STYLE_LIST, "Ammunations", "Ammunation 1\nAmmunation 2\nAmmunation 3\nAmmunation 4\nAmmunation 5\nBooth Ammunation\nRange Ammunation\nBack", "Select", "Cancel");
					case 3: ShowPlayerDialog(playerid, DIALOG_TELEPORT_5, DIALOG_STYLE_LIST, "Houses", "B Dup's Apartment\nB Dup's Crack Palace\nOG Loc's House\nRyder's house\nSweet's house\nMadd Dogg's Mansion\nBig Smoke's Crack Palace\nBack", "Select", "Cancel");
					case 4: ShowPlayerDialog(playerid, DIALOG_TELEPORT_6, DIALOG_STYLE_LIST, "More Houses", "Johnson House\nAngel Pine Trailer\nSafe House\nSafe House 2\nSafe House 3\nSafe House 4\nVerdant Bluffs Safehouse\nWillowfield Safehouse\nThe Camel's Toe Safehouse\nBack", "Select", "Cancel");
					case 5: ShowPlayerDialog(playerid, DIALOG_TELEPORT_7, DIALOG_STYLE_LIST, "Mission Interiors", "Atrium\nBurning Desire Building\nColonel Furhberger\nWelcome Pump\nWu Zi Mu's Apartement\nJizzy's\nDillimore Gas Station\nJefferson Motel\nLiberty City\nSherman Dam\nBack", "Select", "Cancel");
					case 6: ShowPlayerDialog(playerid, DIALOG_TELEPORT_8, DIALOG_STYLE_LIST, "Stadiums", "RC War Arena\nRacing Stadium\nRacing Stadium 2\nBloodbowl Stadium\nKickstart Stadium\nBack", "Select", "Cancel");
					case 7: ShowPlayerDialog(playerid, DIALOG_TELEPORT_9, DIALOG_STYLE_LIST, "Casinos", "Caligulas Casino\n4 Dragons Casino\nRedsands Casino\n4 Dragons Managerial Suite\nInside Track Betting\nCaligulas Roof\nRosenberg's Caligulas Office\n4 Dragons Janitors Office\nBack", "Select", "Cancel");
					case 8: ShowPlayerDialog(playerid, DIALOG_TELEPORT_10, DIALOG_STYLE_LIST, "Shops", "Tattoo\nBurger Shot\nWell Stacked Pizza\nCluckin' Bell\nRusty Donut's\nZero's RC Shop\nSex Shop\nBack", "Select", "Cancel");
					case 9: ShowPlayerDialog(playerid, DIALOG_TELEPORT_11, DIALOG_STYLE_LIST, "Garages","Loco Low Co.\nWheel Arch Angels\nTransfender\nDoherty Garage\nBack", "Select", "Cancel");
					case 10: ShowPlayerDialog(playerid, DIALOG_TELEPORT_12, DIALOG_STYLE_LIST, "Girlfriend Houses","Denises Bedroom\nHelena's Barn\nBarbara's Love Nest\nKatie's Lovenest\nMichelle's Love Nest\nMillie's Bedroom\nBack", "Select", "Cancel");
					case 11: ShowPlayerDialog(playerid, DIALOG_TELEPORT_13, DIALOG_STYLE_LIST, "Clothing/Barber Shops","Barber Shop\nPro-Laps\nVictim\nSubUrban\nReece's Barber Shop\nZip\nDidier Sachs\nBinco\nBarber Shop 2\nWardrobe\nBack", "Select", "Cancel");
					case 12: ShowPlayerDialog(playerid, DIALOG_TELEPORT_14, DIALOG_STYLE_LIST, "Resturants & Clubs","Brothel\nBrothel 2\nThe Big Spread Ranch\nDinner\nWorld Of Coq\nThe Pig Pen\nClub\nJay's Diner\nSecret Valley Diner\nFanny Batter's Whore House\nTen Green Bottles\nBack", "Select", "Cancel");
					case 13: ShowPlayerDialog(playerid, DIALOG_TELEPORT_15, DIALOG_STYLE_LIST, "No Category","Blastin' Fools Records\nWarehouse\nWarehouse 2\nBudget Inn Motel Room\nLil' Probe Inn\nCrack Den\nMeat Factory\nBike School\nDriving School\nPalomino Creek Bank\nBetting Shop\nBack", "Select", "Cancel");
					case 14: ShowPlayerDialog(playerid, DIALOG_TELEPORT_16, DIALOG_STYLE_LIST, "Burglary Houses","Burglary House 1\nBurglary House 2\nBurglary House 3\nBurglary House 4\nBurglary House 5\nBurglary House 6\nBurglary House 7\nBurglary House 8\nBurglary House 9\nBurglary House 10\nBack", "Select", "Cancel");
					case 15: ShowPlayerDialog(playerid, DIALOG_TELEPORT_17, DIALOG_STYLE_LIST, "Burglary Houses 2","Burglary House 11\nBurglary House 12\nBurglary House 13\nBurglary House 14\nBurglary House 15\nBurglary House 16\nBack", "Select", "Cancel");
					case 16: ShowPlayerDialog(playerid, DIALOG_TELEPORT_18, DIALOG_STYLE_LIST, "Gyms","Los Santos Gym\nSan Fierro Gym\nLas Venturas Gym\nBack", "Select", "Cancel");
					case 17: ShowPlayerDialog(playerid, DIALOG_TELEPORT_19, DIALOG_STYLE_LIST, "Departments","SF Police Department\nLS Police Department\nLV Police Department\nPlanning Department\nBack", "Select", "Cancel");
					case 18: ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
				}
			}
			return 1;
		}
		case DIALOG_TELEPORT_2:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, -25.884499,-185.868988,1003.549988); SetPlayerInterior(playerid, 17); }
				else if (listitem == 1) { SetPlayerPos(playerid, -6.091180,-29.271898,1003.549988); SetPlayerInterior(playerid, 10); }
				else if (listitem == 2) { SetPlayerPos(playerid, -30.946699,-89.609596,1003.549988); SetPlayerInterior(playerid, 18); }
				else if (listitem == 3) { SetPlayerPos(playerid, -25.132599,-139.066986,1003.549988); SetPlayerInterior(playerid, 16); }
				else if (listitem == 4) { SetPlayerPos(playerid, -27.312300,-29.277599,1003.549988); SetPlayerInterior(playerid, 4); }
				else if (listitem == 5) { SetPlayerPos(playerid, -26.691599,-55.714897,1003.549988); SetPlayerInterior(playerid, 6); }
				else if (listitem == 6) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_3:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, -1827.147338,7.207418,1061.143554); SetPlayerInterior(playerid, 14); }
				else if (listitem == 1) { SetPlayerPos(playerid, -1855.568725,41.263156,1061.143554); SetPlayerInterior(playerid, 14); }
				else if (listitem == 2) { SetPlayerPos(playerid, 315.856170,1024.496459,1949.797363); SetPlayerInterior(playerid, 9); }
				else if (listitem == 3) { SetPlayerPos(playerid, 2.384830,33.103397,1199.849976); SetPlayerInterior (playerid, 1); }
				else if (listitem == 4) { SetPlayerPos(playerid, -1870.80,59.81,1056.25); SetPlayerInterior(playerid, 14); }
				else if (listitem == 5) { SetPlayerPos(playerid, -1830.81,16.83,1061.14); SetPlayerInterior(playerid, 14); }
				else if (listitem == 6) { SetPlayerPos(playerid, 419.8936, 2537.1155, 10); SetPlayerInterior(playerid, 10); }
				else if (listitem == 7) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_4:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 286.148987,-40.644398,1001.569946); SetPlayerInterior(playerid, 1); }
				else if (listitem == 1) { SetPlayerPos(playerid, 286.800995,-82.547600,1001.539978); SetPlayerInterior(playerid, 4); }
				else if (listitem == 2) { SetPlayerPos(playerid, 296.919983,-108.071999,1001.569946); SetPlayerInterior(playerid, 6); }
				else if (listitem == 3) { SetPlayerPos(playerid, 314.820984,-141.431992,999.661987); SetPlayerInterior(playerid, 7); }
				else if (listitem == 4) { SetPlayerPos(playerid, 316.524994,-167.706985,999.661987); SetPlayerInterior(playerid, 6); }
				else if (listitem == 5) { SetPlayerPos(playerid, 302.292877,-143.139099,1004.062500); SetPlayerInterior(playerid, 7); }
				else if (listitem == 6) { SetPlayerPos(playerid, 280.795104,-135.203353,1004.062500); SetPlayerInterior(playerid, 7); }
				else if (listitem == 7) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_5:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 1527.0468, -12.0236, 1002.0971); SetPlayerInterior(playerid, 3); }
				else if (listitem == 1) { SetPlayerPos(playerid, 1523.5098, -47.8211, 1002.2699); SetPlayerInterior(playerid, 2); }
				else if (listitem == 2) { SetPlayerPos(playerid, 512.9291, -11.6929, 1001.5653); SetPlayerInterior(playerid, 3); }
				else if (listitem == 3) { SetPlayerPos(playerid, 2447.8704, -1704.4509, 1013.5078); SetPlayerInterior(playerid, 2); }
				else if (listitem == 4) { SetPlayerPos(playerid, 2527.0176, -1679.2076, 1015.4986); SetPlayerInterior(playerid, 1); }
				else if (listitem == 5) { SetPlayerPos(playerid, 1267.8407, -776.9587, 1091.9063); SetPlayerInterior(playerid, 5); }
				else if (listitem == 6) { SetPlayerPos(playerid, 2536.5322, -1294.8425, 1044.125); SetPlayerInterior(playerid, 2); }
				else if (listitem == 7) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_6:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 2496.0549, -1695.1749, 1014.7422); SetPlayerInterior(playerid, 3); }
				else if (listitem == 1) { SetPlayerPos(playerid, 1.1853, -3.2387, 999.4284); SetPlayerInterior(playerid, 2); }
				else if (listitem == 2) { SetPlayerPos(playerid, 2233.6919, -1112.8107, 1050.8828); SetPlayerInterior(playerid, 5); }
				else if (listitem == 3) { SetPlayerPos(playerid, 2194.7900, -1204.3500, 1049.0234); SetPlayerInterior(playerid, 6); }
				else if (listitem == 4) { SetPlayerPos(playerid, 2319.1272, -1023.9562, 1050.2109); SetPlayerInterior(playerid, 9); }
				else if (listitem == 5) { SetPlayerPos(playerid, 2262.4797,-1138.5591,1050.6328); SetPlayerInterior(playerid, 10); }
				else if (listitem == 6) { SetPlayerPos(playerid, 2365.1089, -1133.0795, 1050.875); SetPlayerInterior(playerid, 8); }
				else if (listitem == 7) { SetPlayerPos(playerid, 2282.9099, -1138.2900, 1050.8984); SetPlayerInterior(playerid, 11); }
				else if (listitem == 8) { SetPlayerPos(playerid, 2216.1282, -1076.3052, 1050.4844); SetPlayerInterior(playerid, 1); }
				else if (listitem == 9) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_7:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 1726.18,-1641.00,20.23); SetPlayerInterior(playerid, 18); }
				else if (listitem == 1) { SetPlayerPos(playerid, 2338.32,-1180.61,1027.98); SetPlayerInterior(playerid, 5); }
				else if (listitem == 2) { SetPlayerPos(playerid, 2807.63,-1170.15,1025.57); SetPlayerInterior(playerid, 8); }
				else if (listitem == 3) { SetPlayerPos(playerid, 681.66,-453.32,-25.61); SetPlayerInterior(playerid, 1); }
				else if (listitem == 4) { SetPlayerPos(playerid, -2158.72,641.29,1052.38); SetPlayerInterior(playerid, 1); }
				else if (listitem == 5) { SetPlayerPos(playerid, -2637.69,1404.24,906.46); SetPlayerInterior(playerid, 3); }
				else if (listitem == 6) { SetPlayerPos(playerid, 664.19,-570.73,16.34); SetPlayerInterior(playerid, 0); }
				else if (listitem == 7) { SetPlayerPos(playerid, 2220.26,-1148.01,1025.80); SetPlayerInterior(playerid, 15); }
				else if (listitem == 8) { SetPlayerPos(playerid, -750.80,491.00,1371.70); SetPlayerInterior(playerid, 1); }
				else if (listitem == 9) { SetPlayerPos(playerid, -944.2402, 1886.1536, 5.0051); SetPlayerInterior(playerid, 17); }
				else if (listitem == 10) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_8:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, -1079.99,1061.58,1343.04); SetPlayerInterior(playerid, 10); }
				else if (listitem == 1) { SetPlayerPos(playerid, -1395.958,-208.197,1051.170); SetPlayerInterior(playerid, 7); }
				else if (listitem == 2) { SetPlayerPos(playerid, -1424.9319,-664.5869,1059.8585); SetPlayerInterior(playerid, 4); }
				else if (listitem == 3) { SetPlayerPos(playerid, -1394.20,987.62,1023.96); SetPlayerInterior(playerid, 15); }
				else if (listitem == 4) { SetPlayerPos(playerid, -1410.72,1591.16,1052.53); SetPlayerInterior(playerid, 14); }
				else if (listitem == 5) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_9:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 2233.8032,1712.2303,1011.7632); SetPlayerInterior(playerid, 1); }
				else if (listitem == 1) { SetPlayerPos(playerid, 2016.2699,1017.7790,996.8750); SetPlayerInterior(playerid, 10); }
				else if (listitem == 2) { SetPlayerPos(playerid, 1132.9063,-9.7726,1000.6797); SetPlayerInterior(playerid, 12); }
				else if (listitem == 3) { SetPlayerPos(playerid, 2003.1178, 1015.1948, 33.008); SetPlayerInterior(playerid, 11); }
				else if (listitem == 4) { SetPlayerPos(playerid, 830.6016, 5.9404, 1004.1797); SetPlayerInterior(playerid, 3); }
				else if (listitem == 5) { SetPlayerPos(playerid, 2268.5156, 1647.7682, 1084.2344); SetPlayerInterior(playerid, 1); }
				else if (listitem == 6) { SetPlayerPos(playerid, 2182.2017, 1628.5848, 1043.8723); SetPlayerInterior(playerid, 2); }
				else if (listitem == 7) { SetPlayerPos(playerid, 1893.0731, 1017.8958, 31.8828); SetPlayerInterior(playerid, 10); }
				else if (listitem == 8) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_10:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, -203.0764,-24.1658,1002.2734); SetPlayerInterior(playerid, 16); }
				else if (listitem == 1) { SetPlayerPos(playerid, 365.4099,-73.6167,1001.5078); SetPlayerInterior(playerid, 10); }
				else if (listitem == 2) { SetPlayerPos(playerid, 372.3520,-131.6510,1001.4922); SetPlayerInterior(playerid, 5); }
				else if (listitem == 3) { SetPlayerPos(playerid, 365.7158,-9.8873,1001.8516); SetPlayerInterior(playerid, 9); }
				else if (listitem == 4) { SetPlayerPos(playerid, 378.026,-190.5155,1000.6328); SetPlayerInterior(playerid, 17); }
				else if (listitem == 5) { SetPlayerPos(playerid, -2240.1028, 136.973, 1035.4141); SetPlayerInterior(playerid, 6); }
				else if (listitem == 6) { SetPlayerPos(playerid, -100.2674, -22.9376, 1000.7188); SetPlayerInterior(playerid, 3); }
				else if (listitem == 7) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_11:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 616.7820,-74.8151,997.6350); SetPlayerInterior(playerid, 2); }
				else if (listitem == 1) { SetPlayerPos(playerid, 615.2851,-124.2390,997.6350); SetPlayerInterior(playerid, 3); }
				else if (listitem == 2) { SetPlayerPos(playerid, 617.5380,-1.9900,1000.6829); SetPlayerInterior(playerid, 1); }
				else if (listitem == 3) { SetPlayerPos(playerid, -2041.2334, 178.3969, 28.8465); SetPlayerInterior(playerid, 1); }
				else if (listitem == 4) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_12:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 245.2307, 304.7632, 999.1484); SetPlayerInterior(playerid, 1); }
				else if (listitem == 1) { SetPlayerPos(playerid, 290.623, 309.0622, 999.1484); SetPlayerInterior(playerid, 3); }
				else if (listitem == 2) { SetPlayerPos(playerid, 322.5014, 303.6906, 999.1484); SetPlayerInterior(playerid, 5); }
				else if (listitem == 3) { SetPlayerPos(playerid, 269.6405, 305.9512, 999.1484); SetPlayerInterior(playerid, 2); }
				else if (listitem == 4) { SetPlayerPos(playerid, 306.1966, 307.819, 1003.3047); SetPlayerInterior(playerid, 4); }
				else if (listitem == 5) { SetPlayerPos(playerid, 344.9984, 307.1824, 999.1557); SetPlayerInterior(playerid, 6); }
				else if (listitem == 6) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_13:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 418.4666, -80.4595, 1001.8047); SetPlayerInterior(playerid, 3); }
				else if (listitem == 1) { SetPlayerPos(playerid, 206.4627, -137.7076, 1003.0938); SetPlayerInterior(playerid, 3); }
				else if (listitem == 2) { SetPlayerPos(playerid, 225.0306, -9.1838, 1002.218); SetPlayerInterior(playerid, 5); }
				else if (listitem == 3) { SetPlayerPos(playerid, 204.1174, -46.8047, 1001.8047); SetPlayerInterior(playerid, 1); }
				else if (listitem == 4) { SetPlayerPos(playerid, 414.2987, -18.8044, 1001.8047); SetPlayerInterior(playerid, 2); }
				else if (listitem == 5) { SetPlayerPos(playerid, 161.4048, -94.2416, 1001.8047); SetPlayerInterior(playerid, 18); }
				else if (listitem == 6) { SetPlayerPos(playerid, 204.1658, -165.7678, 1000.5234); SetPlayerInterior(playerid, 14); }
				else if (listitem == 7) { SetPlayerPos(playerid, 207.5219, -109.7448, 1005.1328); SetPlayerInterior(playerid, 15); }
				else if (listitem == 8) { SetPlayerPos(playerid, 411.9707, -51.9217, 1001.8984); SetPlayerInterior(playerid, 12); }
				else if (listitem == 9) { SetPlayerPos(playerid, 256.9047, -41.6537, 1002.0234); SetPlayerInterior(playerid, 14); }
				else if (listitem == 10) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_14:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 974.0177, -9.5937, 1001.1484); SetPlayerInterior(playerid, 3); }
				else if (listitem == 1) { SetPlayerPos(playerid, 961.9308, -51.9071, 1001.1172); SetPlayerInterior(playerid, 3); }
				else if (listitem == 2) { SetPlayerPos(playerid, 1212.0762,-28.5799,1000.9531); SetPlayerInterior(playerid, 3); }
				else if (listitem == 3) { SetPlayerPos(playerid, 454.9853, -107.2548, 999.4376); SetPlayerInterior(playerid, 5); }
				else if (listitem == 4) { SetPlayerPos(playerid, 445.6003, -6.9823, 1000.7344); SetPlayerInterior(playerid, 1); }
				else if (listitem == 5) { SetPlayerPos(playerid, 1204.9326,-8.1650,1000.9219); SetPlayerInterior(playerid, 2); }
				else if (listitem == 6) { SetPlayerPos(playerid, 490.2701,-18.4260,1000.6797); SetPlayerInterior(playerid, 17); }
				else if (listitem == 7) { SetPlayerPos(playerid, 449.0172, -88.9894, 999.5547); SetPlayerInterior(playerid, 4); }
				else if (listitem == 8) { SetPlayerPos(playerid, 442.1295, -52.4782, 999.7167); SetPlayerInterior(playerid, 6); }
				else if (listitem == 9) { SetPlayerPos(playerid, 748.4623, 1438.2378, 1102.9531); SetPlayerInterior(playerid, 6); }
				else if (listitem == 10) { SetPlayerPos(playerid, 502.9261,-71.1631,998.7578); SetPlayerInterior(playerid, 11); }
				else if (listitem == 11) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_15:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 1037.8276, 0.397, 1001.2845); SetPlayerInterior(playerid, 3); }
				else if (listitem == 1) { SetPlayerPos(playerid, 1290.4106, 1.9512, 1001.0201); SetPlayerInterior(playerid, 18); }
				else if (listitem == 2) { SetPlayerPos(playerid, 1411.4434,-2.7966,1000.9238); SetPlayerInterior(playerid, 1); }
				else if (listitem == 3) { SetPlayerPos(playerid, 446.3247, 509.9662, 1001.4195); SetPlayerInterior(playerid, 12); }
				else if (listitem == 4) { SetPlayerPos(playerid, -227.5703, 1401.5544, 27.7656); SetPlayerInterior(playerid, 18); }
				else if (listitem == 5) { SetPlayerPos(playerid, 318.5645, 1118.2079, 1083.8828); SetPlayerInterior(playerid, 5); }
				else if (listitem == 6) { SetPlayerPos(playerid, 963.0586, 2159.7563, 1011.0303); SetPlayerInterior(playerid, 1); }
				else if (listitem == 7) { SetPlayerPos(playerid, 1494.8589, 1306.48, 1093.2953); SetPlayerInterior(playerid, 3); }
				else if (listitem == 8) { SetPlayerPos(playerid, -2031.1196, -115.8287, 1035.1719); SetPlayerInterior(playerid, 3); }
				else if (listitem == 9) { SetPlayerPos(playerid, 2309, -13, 26); SetPlayerInterior(playerid,0); }
				else if (listitem == 10) { SetPlayerPos(playerid, 830.4812,6.4477,1004.1797); SetPlayerInterior(playerid, 3); }
				else if (listitem == 11) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_16:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 234.6087, 1187.8195, 1080.2578); SetPlayerInterior(playerid, 3); }
				else if (listitem == 1) { SetPlayerPos(playerid, 225.5707, 1240.0643, 1082.1406); SetPlayerInterior(playerid, 2); }
				else if (listitem == 2) { SetPlayerPos(playerid, 224.288, 1289.1907, 1082.1406); SetPlayerInterior(playerid, 1); }
				else if (listitem == 3) { SetPlayerPos(playerid, 239.2819, 1114.1991, 1080.9922); SetPlayerInterior(playerid, 5); }
				else if (listitem == 4) { SetPlayerPos(playerid, 295.1391, 1473.3719, 1080.2578); SetPlayerInterior(playerid, 15); }
				else if (listitem == 5) { SetPlayerPos(playerid, 261.1165, 1287.2197, 1080.2578); SetPlayerInterior(playerid, 4); }
				else if (listitem == 6) { SetPlayerPos(playerid, 24.3769, 1341.1829, 1084.375); SetPlayerInterior(playerid, 10); }
				else if (listitem == 7) { SetPlayerPos(playerid, -262.1759, 1456.6158, 1084.3672); SetPlayerInterior(playerid, 4); }
				else if (listitem == 8) { SetPlayerPos(playerid, 22.861, 1404.9165, 1084.4297); SetPlayerInterior(playerid, 5); }
				else if (listitem == 9) { SetPlayerPos(playerid, 140.3679, 1367.8837, 1083.8621); SetPlayerInterior(playerid, 5); }
				else if (listitem == 10) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_17:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 234.2826, 1065.229, 1084.2101); SetPlayerInterior(playerid, 6); }
				else if (listitem == 1) { SetPlayerPos(playerid, -68.5145, 1353.8485, 1080.2109); SetPlayerInterior(playerid, 6); }
				else if (listitem == 2) { SetPlayerPos(playerid, -285.2511, 1471.197, 1084.375); SetPlayerInterior(playerid, 15); }
				else if (listitem == 3) { SetPlayerPos(playerid, -42.5267, 1408.23, 1084.4297); SetPlayerInterior(playerid, 8); }
				else if (listitem == 4) { SetPlayerPos(playerid, 84.9244, 1324.2983, 1083.8594); SetPlayerInterior(playerid, 9); }
				else if (listitem == 5) { SetPlayerPos(playerid, 260.7421, 1238.2261, 1084.2578); SetPlayerInterior(playerid, 9); }
				else if (listitem == 6) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_18:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 765, 0, 1000); SetPlayerInterior(playerid, 5); }
				else if (listitem == 1) { SetPlayerPos(playerid, 771.8632,-40.5659,1000.6865); SetPlayerInterior(playerid, 6); }
				else if (listitem == 2) { SetPlayerPos(playerid, 774.0681,-71.8559,1000.6484); SetPlayerInterior(playerid, 7); }
				else if (listitem == 3) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
		case DIALOG_TELEPORT_19:
		{
			if (response)
			{
				if (listitem == 0) { SetPlayerPos(playerid, 246.40,110.84,1003.22); SetPlayerInterior(playerid, 10); }
				else if (listitem == 1) { SetPlayerPos(playerid, 246.6695, 65.8039, 1003.6406); SetPlayerInterior(playerid, 6); }
				else if (listitem == 2) { SetPlayerPos(playerid, 288.4723, 170.0647, 1007.1794); SetPlayerInterior(playerid, 3); }
				else if (listitem == 3) { SetPlayerPos(playerid, 386.5259, 173.6381, 1008.3828); SetPlayerInterior(playerid, 3); }
				else if (listitem == 4) { ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel"); }
			}
			else ShowPlayerDialog(playerid, DIALOG_TELEPORT, DIALOG_STYLE_LIST, "Teleport", "24/7's\nAirports\nAmmunations\nHouses\nMore Houses\nMission Interiors\nStadiums\nCasinos\nShops\nGarages\nGirlfriend Houses\nClothing/Barber Shops\nRestaurants / Clubs\nNo Category\nBurglary Houses\nBurglary Houses 2\nGyms\nPolice Departments", "Select", "Cancel");
			return 1;
		}
	}
	return 1;
}

public MySQL_Finish() 
{
	return (!mysql_affected_rows(fSQLHandle)) ? print("[RESOURCE DEBUG] Failed to affect rows.") : (1);
}
