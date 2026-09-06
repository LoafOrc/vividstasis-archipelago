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
        ap_run_through_queue();
    }
}