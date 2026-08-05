var current_room_name = room_get_name(room);
if(current_room_name == "scene_results_2023") {
    var grade = get_score_grade(global.currentscore)
    if(global.song_list[global.song_id_last].chart_id = "plaudite") {
        ap_goal();
        return;
    }
    if(grade <= 4) { // SS is 4
        loc_id = global.song_list[global.song_id_last].ap.ss_rank_clear_locid
        ap_check(loc_id);
        global.ap_last_scoutinfo = struct_get(global.ap_location_scouts, string(loc_id));
        ss_ap_scout_text();
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