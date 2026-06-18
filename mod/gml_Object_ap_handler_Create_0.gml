///@description Network connection data

//Maybe you can optimize this better? it works already for what it needs to be.
wss = network_socket_wss
ws = network_socket_ws
network_send_text = 2

function load_json_from_file(_filename) {
    var _buffer = buffer_load(_filename);

    var _json_string = buffer_read(_buffer, buffer_string);
    buffer_delete(_buffer);
    return json_parse(_json_string)
}

global.ap_data = load_json_from_file("ap.json");
global.ap_bsdata = load_json_from_file("ap_bs_flat.json");

global.secure = false
global.ap_socket = -1
global.ap_deathlink = false
global.ap_connected = false

show_debug_log(true);
ap_debug("initalizing")

if (global.ap_attemptconnect)
{
    ap_connect(global.aphost, global.apport, global.apname, global.appass, function(result) {
        ap_debug("connect callback fired! success = " + string(result.success))
        if(result.success == true) {
            play_se(sfx_solve_puzzle);
            // let game progress
        } else {
            play_se(buzzer);
            // show error message ui to player
            // result.errors
            return;
        }

        global.ap_attemptconnect = false;
        ini_open(global.profile_file)
        var prev_checks = ini_read_string("ap", "all_locations", "");
        ini_close()
        
        if (string_length(prev_checks) > 0)
        {
            var checks_split = split_string(",", prev_checks, true);

            for (var i = 0; i < array_length(checks_split); i++)
            {
                var s = real(checks_split[i]);
                array_push(global.ap_location_checks, s)
            }
            
            _ap_send({
                cmd: "LocationChecks",
                locations: global.ap_location_checks
            })
        }

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


        var _keys = struct_get_names(global.ap_bsdata);
        var _count = array_length(_keys);
        
        var _values = array_create(_count);
        
        for (var i = 0; i < _count; i++) {
            _values[i] = int64(struct_get(global.ap_bsdata, _keys[i]));
        }

        ap_scout(_values)
    })
}