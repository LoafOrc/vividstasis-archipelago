selected = 1;

function transition_to(room) {
	global.ap_next_room = room;
	with (instance_create_depth(160, 90, -1000, o_transition_diamond)) {
		TweenEasyFade(0, 1, 0, 60, EaseOutQuint);
		TweenEasyRotate(-45, 315, 0, 60, EaseOutExpo);
		TweenEasyScale(1, 1, 320, 180, 0, 60, EaseOutQuad);
		color = 16777215;
		next_room = global.ap_next_room;
		alarm[0] = 60;
	}
}

ini_open(global.profile_file);
settings = new APConnectionSettings(
	ini_read_string("ap_global", "host", "archipelago.gg"),
	ini_read_string("ap_global", "port", ""),
	ini_read_string("ap_global", "name", ""),
	ini_read_string("ap_global", "pass", ""),
);
ini_close();

if (is_ap_connected()) {
    result = "Connected! Press Enter to disconnect";
} else {
    result = "Disconnected, press Enter to connect";
}
global.ap_logger.debug("o_ap_join, is_ap_connected()? {0}", is_ap_connected());

keyboard_string = settings.address;
play_bgm(music_story_ambientstopmotion);