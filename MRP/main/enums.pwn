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

enum pInfo {
	pUserID,
	pStaff,
	pMod,
	pLevel, /* ((50 * (LEVEL) * (LEVEL) * (LEVEL) - 150 * (LEVEL) * (LEVEL) + 600 * (LEVEL)) / 5) */
	pXP,
	pDisabled,
	pUserIp[16],
	Float:pPosX,
	Float:pPosY,
	Float:pPosZ,
	Float:pPosA,
	pModel,
	pVW,
	pInt,
	pCreated,
	pClass,
	pState,
	Float:pHealth,
	Float:pArmour,
	pSex,
	pACLock,
	pMoneyOnHand,
	pBankMoney,
	pAdminName[MAX_PLAYER_NAME],
	pPrisoned,
	pPrisonTime,
	pJob,
	pVIP,
	pAccent[12],
	pACBanned,
	pGPS,
	pTotalPay,
	pBills,

	/* Achievements */
	pAchievementPoints,
	pAchievementRiskTaker,
	pAchievementRichMcRich,
	pAchievementFirstCar,
	pAchievementFirstBiz,
	pAchievementFirstHouse,
	pAchievementFirstFaction,
	pAchievementMeetAndGreet,

	/* these are unsaved */
	pCheckPoint,
	pTruck,
	pDeveloper,

	/* Connection related tracking */
	pConnectedTotal, // Saved 
	pConnectedMinutes, // Saved
	pConnectedSeconds, // Not Saved 

	/* UNSAVED */
	uLastVeh,
	uHasCompleted,
	TruckerStage,

	Text3D:nameTag,
	Text:pTDInfo,
	pTDTime,

	/* Job Related */
	usingTreeID,
};

enum mpInfo {
	mID,
	mCash,
	mUsed,
	mTimer,
	mLifeSpan,
};

enum aInfo {
	aID,
	aMoney,
	aDisabled,
	Float:aPosX,
	Float:aPosY,
	Float:aPosZ,
	aRange,
	aVW,
	aInt,
	aPickup,
};

enum dInfo {
	dID,
	dName[64],
	dOwner[24],
	dOwnable,
	Float:dExteriorX,
	Float:dExteriorY,
	Float:dExteriorZ,
	Float:dExteriorA,
	Float:dInteriorX,
	Float:dInteriorY,
	Float:dInteriorZ,
	Float:dInteriorA,
	dInt,
	dVW,
	dStaff,
	dVIP,
	dMod,
	dDisabled,
	dRange,
	dIntx,
	dVWx,
	dPickup,
};

enum tInfo {
	treeID,
	treeType,
	Float:treePos[3],
	Text3D:treeLabel,
};

enum hEnum {
	infoID,
	infoPickup,
	infoStr[64],
	Float:infoPos[3],
	Text3D:infoLabel,
};

enum towerInfo {
	tID,
	Float:tPos[3],
	tRange,
	tOwner[32],
	tAttached,
	Text3D:towerLabel,
};

enum attached_object_data {
	aoID,
	aoModel,
	aoBone,
	Float:ao_x,
	Float:ao_y,
	Float:ao_z,
	Float:ao_rx,
	Float:ao_ry,
	Float:ao_rz,
	Float:ao_sx,
	Float:ao_sy,
	Float:ao_sz
};