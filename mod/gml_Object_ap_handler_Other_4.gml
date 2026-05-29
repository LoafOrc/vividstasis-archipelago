// I'm using a RoomStart event as to avoid editing: gml_Object_o_2023results_Create_0 while there isn't a proper modloader/patching framework

var current_room_name = room_get_name(room);
if(current_room_name == "scene_results_2023") {
    var grade = get_score_grade(global.currentscore)
    if(grade <= 4) { // SS is 4
        ap_check(global.song_list[global.song_id_last].ap.ss_rank_clear_locid)
    }
}