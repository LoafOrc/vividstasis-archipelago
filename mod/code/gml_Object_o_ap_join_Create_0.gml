selected = 1;
if (variable_global_exists("aphost"))
    host = global.aphost;
else
    host = "archipelago.gg";
port = global.apport;
name = global.apname;
pass = global.appass;

if (global.ap_connected)
    result = "Connected! Press enter to disconnect";
else
    result = "Disconnected, press Enter to connect";

show_debug_log(true);
keyboard_string = "";
play_bgm(music_story_ambientstopmotion);