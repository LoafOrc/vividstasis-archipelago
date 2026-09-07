enum Grade {
	VS,
	VPlus,
	V,
	SSPlus,
	SS,
	SPlus,
	S,
	AA,
	A,
	B,
	C,
	D,
	E
}

var current_room_name = room_get_name(room);
var target = 13;
if(current_room_name == "scene_results_2023") {
    var grade = get_score_grade(global.currentscore);
	global.ap_logger.debug("reached results screen. currentscore = {0}, grade = {1}, target = {2}", global.currentscore, grade, target);
    if(global.song_list[global.song_id_last].chart_id = "plaudite") {
        ap_goal();
        return;
    }
    if(grade <= target) { // SS is 4
		global.ap_logger.debug("reached rank requirement");
        var location = global.song_list[global.song_id_last].ap.rank_clear_loc
        ap_check(location);
    }
}

if(string_starts_with(current_room_name, "rpg_")) {
    with(o_ch0_acvortex) {
        instance_destroy();
    }
    with(o_ch0_stargate) {
        instance_destroy();
    }
    with(o_ch0_finallandinggate) {
        instance_destroy();
    }
    with(o_ch0_void_portal) {
        instance_destroy();
    }
    with(o_ch0_l2_portal) {
        instance_destroy();
    }
    with(o_trigger_zone_warp) {
        if(warpRoom = rpg_hub_5 | warpRoom = rpg_hubchrono) {
            instance_destroy();
        }
    }
    
    with(o_ch0_song) {
        check = instance_create_layer(x, y, "Instances", o_ap_betweenspacecheck);
        check.set_id("song_" + string(song_id));
        instance_destroy();
    }
    
    with(o_ch0_tablet) {
        check = instance_create_layer(x, y, "Instances", o_ap_betweenspacecheck);
        check.set_id("tablet_" + string(tablet_id));
        instance_destroy();
    }
    
    with(o_ch0_crystal) {
        check = instance_create_layer(x, y, "Instances", o_ap_betweenspacecheck);
        check.set_id("gem_" + string(pickup_id));
        instance_destroy();
    }
}

ap_run_through_queue();