// AP MOD START
instance_create_layer(0, 0, "Instances", o_ap_handler);
// AP MOD END
global.banned = false;
global.offline = false;
global.multiplayerLobby = false;
global.draw_distance = 1250;
global.is_da25_qualifier = false;
global.ch0_temp_flags = [false];
register_packet_types();
checkfile = "song_information_22public.vsd";
ver = file_text_open_read("ver");
global.version_number = file_text_readln(ver);
file_text_close(ver);
CreateSongDictionary();
create_final_landing();
global.from_start = true;
global.gamefps = 60;
global.fade_in_track = false;
global.soundscan_arcade_vice_level = 0;
global.transition_occuring = false;
global.do_shatter_menu = false;
global.show_unlock_animation = false;
global.locks_confirmed = [false, false, false];
global.decrypt_mode = global.decrypt_styles[0];
global.boost_mode = 0;
global.song_shatter = false;
global.transferred_points = 0;
global.in_betweenspace = false;
global.failed = false;
global.skip_fc_indicator = false;
global.is_ver3 = true;
global.course_mode = false;

if (!directory_exists("backups"))
    directory_create("backups");

var now = date_current_datetime();
var now_timestamp = @@string@@("{0}_{1}_{2}_{3}_{4}_{5}", date_get_year(now), date_get_month(now), date_get_day(now), date_get_hour(now), date_get_minute(now), date_get_second(now));

if (file_exists("profile"))
{
    file_copy("profile", @@string@@("backups\\profile_{0}", now_timestamp));
    ini_open("profile");
    global.go_to_prologue = ini_read_real("profile", "initialized", 0) != 0;
    ini_write_real("profile", "is_v5_save", true);
    debug("YEAH?!", global.go_to_prologue);
    ini_close();
}
else
{
    ini_open("profile");
    ini_write_real("profile", "is_v5_save", true);
    ini_close();
    global.go_to_prologue = false;
}

if (file_exists("highscore_table"))
    file_copy("highscore_table", @@string@@("backups\\highscore_table_{0}", now_timestamp));

if (file_exists("system"))
    file_copy("system", @@string@@("backups\\system_{0}", now_timestamp));

blacklist = http_get_file("https://shrinereport.xyz/blacklist.vsd", "blacklist.vsd");
syncing = false;
global.new_info_filename = false;
fail_sync = false;
event_user(0);
