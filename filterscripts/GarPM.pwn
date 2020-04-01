/*
	@ Author: [03]Garsino
	@ Last Updated: 22nd September 2010.
	@ Thanks to: Y_Less (sscanf2 and other help/info), Zeek (isnull), DracoBlue (dcmd) and SA:MP Dev Team
	@ Current Version: v1.2
	@ Version 1.2 Changes:
		- Added multicolour to the client messages.
		- Slightly fix in /pm so people can't write long messages and crash the server ....
*/
#include <a_samp>
#include <sscanf2>
#define isnull(%1) \
	((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1])))) // Credits To Zeek (I think)
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
new FALSE = false;
#define SendMSG(%0,%1,%2,%3) do{new _str[128]; format(_str,128,%2,%3); SendClientMessage(%0,%1,_str);}while(FALSE) // Credits to Y_Less
#define COLOUR_SYSTEM 	0xB60000FF
#define COLOUR_PM 		0xFFFF2AFF
#define COLOUR_INFO		0x00983BFF
#define LOG_PM // If defined it will log PMs, it not then it will not.
public OnPlayerCommandText(playerid, cmdtext[])
{
	dcmd(pm, 2, cmdtext);
	dcmd(reply, 5, cmdtext);
	dcmd(r, 1, cmdtext);
	dcmd(nopm, 4, cmdtext);
	return 0;
}
public OnFilterScriptInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    SetPVarInt(i, "LastMessage", INVALID_PLAYER_ID);
	}
	return 1;
}
public OnFilterScriptExit()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		    DeletePVar(i, "LastMessage");
			DeletePVar(i, "NoPM");
		}
	}
	return 1;
}
public OnPlayerConnect(playerid)
{
	SetPVarInt(playerid, "LastMessage", INVALID_PLAYER_ID);
	return 1;
}
stock pNick(playerid)
{
	new nick[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nick, MAX_PLAYER_NAME);
 	return nick;
}
dcmd_pm(playerid, params[])
{
		new id, msg[81];
		if(sscanf(params, "us[81]", id, msg)) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Usage: {FFFFFF}/pm (nick/id) (message)");
		if(msg[80]) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}Invalid PM Lenght. Your PM Must Be Between 1-80 Characters.");
		if(isnull(msg)) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}Invalid PM Lenght. Your PM Must Be Between 1-80 Characters.");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid Player!");
		//if(id == playerid) return SendClientMessage(playerid, COLOUR_SYSTEM, "You Can Not PM Yourself!");
		if(GetPVarInt(id, "NoPM") == 1) SendMSG(playerid, COLOUR_PM, "{FF0000}%s {009900}(%d) {FFFFFF}Is {FF0000}Not {FFFFFF}Accepting His PMs At The Moment.", pNick(id), id);
		else
		{
			SendMSG(playerid, COLOUR_PM, "PM Sent To {FF0000}%s {009900}(%d){FFFFFF}: %s", pNick(id), id, msg);
			SendMSG(id, COLOUR_PM, "PM From {FF0000}%s {009900}(%d){FFFFFF}: %s", pNick(playerid), playerid, msg);
			SendClientMessage(id, COLOUR_INFO, "{FFFFFF}Use {33CCCC}/reply (/r) {FFFFFF}To Quick Reply And {33CCCC}/nopm {FFFFFF}To {FF0000}Disable {FFFFFF}PMs.");
			SetPVarInt(id, "LastMessage", playerid);
			#if defined LOG_PM
				LogPM(playerid, id, params);
			#endif
		}
		return 1;
}
dcmd_reply(playerid, params[])
{
		new id = GetPVarInt(playerid, "LastMessage");
		if(isnull(params)) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Usage: {FFFFFF}/reply (message)");
		if(strlen(params) > 80) return SendClientMessage(playerid, COLOUR_SYSTEM, "{FF0000}Error! {FFFFFF}Invalid PM Lenght. Your PM Must Be Between 1-80 Characters.");
  		if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOUR_SYSTEM, "Invalid Player!");
		if(GetPVarInt(id, "NoPM") == 1) SendMSG(playerid, COLOUR_PM, "{FF0000}%s {009900}(%d) {FFFFFF}Is {FF0000}Not {FFFFFF}Accepting His PMs At The Moment.", pNick(id), id);
		else
		{
			SendMSG(playerid, COLOUR_PM, "PM Sent To {FF0000}%s {009900}(%d){FFFFFF}: %s", pNick(id), id, params);
			SendMSG(id, COLOUR_PM, "PM From {FF0000}%s {009900}(%d){FFFFFF}: %s", pNick(playerid), playerid, params);
			SendClientMessage(id, COLOUR_INFO, "{FFFFFF}Use {33CCCC}/reply (/r) {FFFFFF}To Quick Reply And {33CCCC}/nopm {FFFFFF}To {FF0000}Disable {FFFFFF}PMs.");
	        SetPVarInt(id, "LastMessage", playerid);
	        #if defined LOG_PM
				LogPM(playerid, id, params);
			#endif
        }
		return 1;
}
dcmd_r(playerid, params[]) return dcmd_reply(playerid, params);
dcmd_nopm(playerid, params[])
{
	#pragma unused params
	switch(GetPVarInt(playerid, "NoPM"))
	{
		case 1:
		{
		    SetPVarInt(playerid, "NoPM", 0);
			SendClientMessage(playerid, COLOUR_PM, "You Have {FF0000}Enabled {FFFF2A}Incomming PMs. Use {33CCCC}/nopm {FFFF2A}To Disable PMs.");
		}
		case 0:
		{
		    SetPVarInt(playerid, "NoPM", 1);
			SendClientMessage(playerid, COLOUR_PM, "You Have {FF0000}Disabled {FFFF2A}Incomming PMs. Use {33CCCC}/nopm {FFFF2A}To Enable PMs.");
		}
	}
	return 1;
}

stock LogPM(playerid, id, text[])
{
	new File:gFile, year, month, day, hour, minute, second, string[256];
	getdate(year, month, day);
	gettime(hour, minute, second);
	if(!fexist("GarPM.txt"))
	{
		gFile = fopen("GarPM.txt", io_write);
		fclose(gFile);
	}
	gFile = fopen("GarPM.txt", io_append);
	format(string, sizeof(string), "[Date: %02d/%02d/%02d || Time: %02d:%02d:%02d] PM From %s (%d) To %s (%d): %s\r\n", day, month, year, hour, minute, second, pNick(playerid), playerid, pNick(id), id, text);
	fwrite(gFile, string);
	fclose(gFile);
	return 1;
}
// © [03]Garsino 2010 - Keep The Credits!
