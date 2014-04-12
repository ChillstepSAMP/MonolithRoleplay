// Credits to: pds2k12

//=================================[Includes]=================================//

#include <a_samp>

//=================================[Variable]=================================//

static
    _pLastFlyTick[ MAX_PLAYERS ]
;

//=================================[Callback]=================================//

public OnPlayerUpdate(playerid)
{
    static  
        Float:Positions[ 3 ], 
        Float:Velocity[ 3 ], 
        PlayerKeys[ 3 ]
    ; 

    GetPlayerPos( playerid, Positions[ 0 ], Positions[ 1 ], Positions[ 2 ] ), GetPlayerVelocity(playerid, Velocity[ 0 ], Velocity[ 1 ], Velocity[ 2 ] ),
    GetPlayerKeys( playerid, PlayerKeys[ 0 ], PlayerKeys[ 1 ], PlayerKeys[ 2 ] );

    if( gettime( ) - _pLastFlyTick[ playerid ] > 1 )
    {
        if( IsPlayerUsingFlyAnim ( playerid )  && !IsPlayerInWater( playerid ) && PlayerKeys[ 1 ] == KEY_UP && (Positions[ 2 ] >= 15.0) && 
        (Velocity[ 0 ] >= -0.9  || Velocity[ 1 ] >= -0.9 || Velocity[ 0 ] >= 0.9  || Velocity[ 1 ] >= 0.9) )
        {
            CallLocalFunction( "OnPlayerFly", "i", playerid );
        }
        _pLastFlyTick[playerid] = gettime( );
    }  

    #if defined FLY_OnPlayerUpdate
        FLY_OnPlayerUpdate( playerid );
    #endif
    return true;
}

//=================================[ALS Hook]=================================//

#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate FLY_OnPlayerUpdate

//=================================[Forwards]=================================//

#if defined FLY_OnPlayerUpdate
    forward FLY_OnPlayerUpdate( playerid );
#endif
forward OnPlayerFly( playerid );

//==================================[Stocks]==================================//

static stock IsPlayerUsingFlyAnim( playerid ) 
{
    switch( GetPlayerAnimationIndex( playerid ) )
    {
        case 1538, 1542, 1544, 1250, 1062, 1539, 958, 962: return true;
    }
    return false;
}

static stock IsPlayerInWater( playerid ) //Credits to Synchro for his coords function.
{
    static 
        Float:fX, 
        Float:fY, 
        Float:fZ
    ;
    GetPlayerPos( playerid, fX, fY, fZ );

    if((fX >= 2044.6 && fX <= 2192.984 && fY >= 1206.358 && fY <= 1376.552) && fZ < 0xA) return true;
    else if((fX >= 2048.504 && fX <= 2185.174 && fY >= 1063.239 && fY <= 1202.49) && fZ < 0xA) return true;
    else if((fX >= 2204.698 && fX <= 2204.698 && fY >= 1426.837 && fY <= 1430.705) && fZ < 0xA) return true;
    else if((fX >= 2032.885 && fX <= 2114.887 && fY >= 1852.325 && fY <= 1991.575) && fZ < 0xC) return true;
    else if((fX >= 2517.086 && fX <= 2606.897 && fY >= 2316.493 && fY <= 2420.93) && fZ < 0x16) return true;
    else if((fX >= 2554.5996 && fX <= 2507.7683 && fY >= 1548.6178 && fY <= 1588.9154) && fZ < 0xF) return true;
    else if((fX >= -2043.628 && fX <= -1973.561 && fY >= -980.9415 && fY <= -724.0283) && fZ < 0x20) return true;
    else if((fX >= -2753.912 && fX <= -2665.071 && fY >= -522.3632 && fY <= -380.3444) && fZ < 0x05) return true;
    else if((fX >= 1219.864 && fX <= 1292.118 && fY >= -2435.881 && fY <= -2325.344) && fZ < 0xF) return true;
    else if((fX >= 1923.388 && fX <= 2010.854 && fY >= -1223.924 && fY <= -1168.656) && fZ < 0x16) return true;
    else if((fX >= 1269.301 && fX <= 1314.935 && fY >= -837.0452 && fY <= -781.7769) && fZ < 0x5A) return true;
    else if((fX >= 1087.3953 && fX <= 1102.3138 && fY >= -682.6734 && fY <= -663.0043) && fZ < 0x71) return true;
    else if((fX >= 1268.6118 && fX <= 1291.8774 && fY >= -784.2910 && fY <= -764.6104) && fZ < 0x43D) return true;
    else if(fZ < 0xF) return true;
    else return false;
}