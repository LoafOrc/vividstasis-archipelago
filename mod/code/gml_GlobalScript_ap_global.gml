// im keeping all of these in one file atm because i dont want to keep adding entries to the global script inits

function ap_debug(msg, level = "info") {
    show_debug_message("ap " + level + ": " + msg);
    
    var _file = file_text_open_append(working_directory + "ap_log.txt");

    file_text_write_string(_file, "[" + level +"]" + ": " + msg);
    file_text_writeln(_file);
    
    file_text_close(_file);
}

wss = network_socket_wss
ws = network_socket_ws
global.network_send_text = 2
global.ap_message_preconnect_queue = []
// current checks by the user
global.ap_location_checks = []
// current scouts
global.ap_location_scouts = {}
global.ap_slotinfo = {}
global.ap_gamedata = {}
global.ap_self = {}
global.ap_slot = -1
global.ap_callbacks = {}
global.ap_deathlink_primed = true

if (file_exists(working_directory + "ap_log.txt")) {
    file_delete(working_directory + "ap_log.txt");
}
show_debug_message("log file is at: " + working_directory + "ap_log.txt");

// address in most cases is archipelago.gg and uses secure websockets (with exception of localhost/loopback, which uses insecure websockets
// password is usually empty
// returns a async request id
// callback is a function that takes in one argument: results
//  if results.success is true, everything is good!
//  if results.success is false, results.errors will be populated:
//   one or more of the archipelago error codes: "InvalidSlot", "InvalidGame", "IncompatibleVersion", "InvalidPassword", or "InvalidItemsHandling"
//   or "ConnectFailed"
function ap_connect(address, port, name, password, callback) {
    ap_debug("trying to connect to " + address + ":" + string(port))
    global._ap_connection_callback = callback

    if(address == "localhost" || address == "127.0.0.1") {
        global.ap_socket = network_create_socket(ws) // insecure
    } else {
        global.ap_socket = network_create_socket(wss) // secure
    } else {
        global.ap_socket = network_create_socket(ws) // unsecure
    }

    var success = network_connect_raw_async(global.ap_socket, address, port)

    if(success < 0) {
        ap_debug(string("establishing connection failed! isConnected = {0}; success = {1}", isConnected, success), "error")
        callback({
            success: false,
            errors: ["ConnectFailed"]
        });
        return;
    }

    _ap_send({
        cmd: "Connect",
        password: password,
        game: "vivid/stasis",
        name: name,
        uuid: int64(69420),
        items_handling: int64(4 + 2 + 1), // 0b111, https://github.com/ArchipelagoMW/Archipelago/blob/main/docs/network%20protocol.md#items_handling-flags
        tags: [],
        version: { // archipelago version
            class: "Version",
            major: int64(0),
            minor: int64(5),
            build : int64(1)
        },
        slot_data: true
    })
}

function ap_disconnect() {
    ap_debug("disconnecting!", "warn")
    if(global.ap_socket != -1) {
        network_destroy(global.ap_socket)
    }
    global.ap_socket = -1
    global.ap_connected = false
}

function ap_struct_get_values() {

}

function ap_goal() {
    _ap_send({
        cmd: "StatusUpdate",
        status: 30 // 30 is GOAL
    });
}


function ap_send_deathlink(reason) {
    if(!global.ap_deathlink_primed || global.op_ap_deathlinkoverride) {
        return;
    }
    ap_debug("sending deathlink: " + reason, "debug")
    var _player_name = struct_get(global.ap_slotinfo, string(global.ap_slot)).name
    _ap_send({
        cmd: "Bounce",
        tags: ["DeathLink"],
        slots: [],
        games: [],
        data: {
            time: unix_timestamp() + 10,
            cause: string_replace(reason, "<player>", _player_name),
            source: _player_name
        }
    })
    global.ap_deathlink_primed = false
}

function ap_check(location_id) {
    // vivid/stasis specific
    // write to save to be able to recover from later
    ini_open(global.profile_file);
    array_push(global.ap_location_checks, location_id);
    ini_write_string("ap", "all_locations", string_join_ext(",", global.ap_location_checks));
    ini_close();

    if(!global.ap_connected) {
        ap_debug("is disconnected! storing location check to try again when we reconnect");
        
        return;
    }

    ap_debug("checked location: " + string(location_id), "debug")
    _ap_send({
        cmd: "LocationChecks",
        locations: [location_id]
    })
}

function ap_scout(location_ids) {
    ap_debug("scouting: " + string(array_length(location_ids)), "debug");
    _ap_send({
        cmd: "LocationScouts",
        locations: location_ids
    })
}

function _ap_send(data) {
    if(!global.ap_connected) {
        ap_debug("queued command: " + data.cmd, "debug");
        array_push(global.ap_message_preconnect_queue, data);
        return;
    }

    ap_debug("sending command: " + data.cmd, "debug")
    _ap_send_arr([data])
}

function _ap_send_arr(arr) {
    aa = json_stringify(arr)

    buffer = buffer_create(string_byte_length(aa), buffer_fixed,1)
    buffer_seek(buffer, buffer_seek_start, 0)
    buffer_write(buffer,buffer_text,aa)

    network_send_raw(global.ap_socket, buffer, buffer_tell(buffer), global.network_send_text)
}