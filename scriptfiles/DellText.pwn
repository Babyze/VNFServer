/*
Filterscript generated using Zamaroht's TextDraw Editor Version 1.0.
Designed for SA-MP 0.3a.

Time and Date: 2012-11-18 @ 17:50:17

Instructions:
1- Compile this file using the compiler provided with the sa-mp server package.
2- Copy the .amx file to the filterscripts directory.
3- Add the filterscripts in the server.cfg file (more info here:
http://wiki.sa-mp.com/wiki/Server.cfg)
4- Run the server!

Disclaimer:
You have full rights over this file. You can distribute it, modify it, and
change it as much as you want, without having to give any special credits.
*/

#include <a_samp>

new Text:Textdraw0;

public OnFilterScriptInit()
{
	print("Textdraw file generated by");
	print("    Zamaroht's textdraw editor was loaded.");

	// Create the textdraws:
	Textdraw0 = TextDrawCreate(20.000000, 322.000000, "Sponsored by DELL");
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.500000, 1.399999);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawSetProportional(Textdraw0, 1);
	TextDrawSetShadow(Textdraw0, 1);
	TextDrawUseBox(Textdraw0, 1);
	TextDrawBoxColor(Textdraw0, 255);
	TextDrawTextSize(Textdraw0, 176.000000, 53.000000);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(IsPlayerConnected(i))
		{
			TextDrawShowForPlayer(i, Textdraw0);
		}
	}
	return 1;
}

public OnFilterScriptExit()
{
	TextDrawHideForAll(Textdraw0);
	TextDrawDestroy(Textdraw0);
	return 1;
}

public OnPlayerConnect(playerid)
{
	TextDrawShowForPlayer(playerid, Textdraw0);
	return 1;
}
