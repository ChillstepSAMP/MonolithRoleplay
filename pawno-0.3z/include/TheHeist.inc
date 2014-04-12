/*
        The Heist - an official product by Zachary Griffeth

        Developers
            - Skyrise

        Credits
            - Cessil - anti-cheat methods.

        FILE: THEHEIST.INC

        PLEASE FUCKING NOTE:
            -This is purely for my own learning.
            -All of this is useless and can be done in PAWN.
            -Don't mention it unless you want to actually contribute something to make it useful.

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

#if defined _TheHeist_INCLUDED
    #endinput
#endif
#define _TheHeist_INCLUDED
#pragma library TheHeist

#include <a_samp>
#include <YSI\y_hooks>

//Natives
native TH_ConnectPlayer(playerid);
native TH_VerifyPlayer(playerid);
native TH_DisconnectPlayer(playerid);
native TH_Total(playerid); /* Playerid is a param so the plugin has the admin's ID. */
native Init_TheHeist();
//native EmitPawnCallback();

//Callback hooks

/* Not using Y_Hooks on this or related, only main callbacks */
AC_SetPlayerHealth(playerid, Float:amount)
{
    if(amount > 99.0) amount = 99.0;
    if(amount < 0.0) amount = 0.0;
    
    DeletePVar(playerid,"healthSynched");
    SetPVarFloat(playerid,"playerHealth", amount);
    return SetPlayerHealth(playerid,amount);
}

#if defined _ALS_SetPlayerHealth
    #undef SetPlayerHealth
#else
    #define _ALS_SetPlayerHealth
#endif
#define SetPlayerHealth AC_SetPlayerHealth

AC_SetPlayerArmour(playerid, Float:amount)
{
    if(amount > 99.0) amount = 99.0;
    if(amount < 0.0) amount = 0.0;
    
    DeletePVar(playerid,"armourSynched");
    SetPVarFloat(playerid,"playerArmour", amount);
    return SetPlayerArmour(playerid,amount);
}

#if defined _ALS_SetPlayerArmour
    #undef SetPlayerArmour
#else
    #define _ALS_SetPlayerArmour
#endif
#define SetPlayerArmour AC_SetPlayerArmour

hook OnPlayerConnect(playerid)
{
    TH_ConnectPlayer(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid) 
{
    TH_DisconnectPlayer(playerid);
    return 1; 
}

hook OnGameModeInit()
{
    Init_TheHeist();
    return 1;
}

