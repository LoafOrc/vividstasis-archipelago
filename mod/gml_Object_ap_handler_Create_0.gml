///@description Network connection data

//Maybe you can optimize this better? it works already for what it needs to be.
wss = network_socket_wss
ws = network_socket_ws
network_send_text = 2

var _filename = "ap.json";
var _buffer = buffer_load(_filename);

var _json_string = buffer_read(_buffer, buffer_string);
buffer_delete(_buffer);

global.ap_data = json_parse(_json_string);

global.secure = false
global.ap_socket = -1
global.ap_deathlink = false
global.ap_connected = false

show_debug_log(true);
ap_debug("initalizing")

ap_connect("localhost", 38281, "bongo", "", function(result) {
	ap_debug("connect callback fired! success = " + string(result.success))
    if(result.success == true) {
        // let game progress
    } else {
        // show error message ui to player
        // result.errors
    }

    ini_open(global.profile_file)
    var unsent_checks = ini_read_string("ap", "unsent_locations", "");
    
    if (string_length(unsent_checks) > 0)
    {
        var checks_split = split_string(",", unsent_checks, true);
        var locations = []

        for (var i = 0; i < array_length(checks_split); i++)
        {
            var s = real(checks_split[i]);
            array_push(locations, s)
        }
        
        _ap_send({
            cmd: "LocationChecks",
            locations: locations
        })
        ini_write_string("ap", "unsent_locations", "")
    }

    ini_close()

    for (var i = 0; i < array_length(global.song_list); i++) {
        var song = global.song_list[i];
        var apData = struct_get(global.ap_data, song.chart_id)

        if(is_undefined(apData)) {
            ap_debug("no ap data for song: " + song.chart_id, "warn")
            continue
        }

        song.ap = { 
            ss_rank_clear_locid: apData.ss_rank_location_id
        }

        if(!struct_exists(apData, "song_item_id")) {
            continue
        }

        song.ap.song_item_id = apData.song_item_id
        song.unlock = {
            type: 1,
            section: "ap",
            key: "item_" + string(apData.song_item_id),
            hint: "Unlock from Archipelago",
            per_difficulty: false,
            hidden: false,
            enc_type: 0,
            enc_hint: "Unlock from Archipelago"
        }
    }
})