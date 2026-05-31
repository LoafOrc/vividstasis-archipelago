// im keeping all of these in one file atm because i dont want to keep adding entries to the global script inits

function ap_debug(msg, level = "info") {
    show_debug_message("ap " + level + ": " + msg);
}

wss = network_socket_wss
ws = network_socket_ws
network_send_text = 2
global.ap_message_preconnect_queue = []
global.ap_unsent_location_checks = []

// address in most cases is archipelago.gg
// password is usually empty
// returns a async request id
// callback is a function that takes in one argument: results
//  if results.success is true, everything is good!
//  if results.success is false, results.errors will be populated:
//   one or more of the archipelago error codes: "InvalidSlot", "InvalidGame", "IncompatibleVersion", "InvalidPassword", or "InvalidItemsHandling"
//   or "ConnectFailed"
function ap_connect(address, port, name, password, callback) {
    ap_debug("trying to connect to " + address + ":" + string(port) + " as " + name)
    global._ap_connection_callback = callback

    if(address == "archipelago.gg") {
        global.ap_socket = network_create_socket(wss) // secure
    } else {
        global.ap_socket = network_create_socket(ws) // unsecure
    }

    var success = network_connect_raw_async(global.ap_socket, address, port)

    if(success < 0) {
        ap_debug("establishing connection failed! isConnected = " + string(isConnected), "error")
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
        uuid: int64(999999),
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

function ap_check(location_id) {
    if(!global.ap_connected) {
        ap_debug("is disconnected! storing location check to try again when we reconnect");
        array_push(global.ap_unsent_location_checks, location_id);
        // vivid/stasis specific
        ini_open(global.profile_file);
        ini_write_string("ap", "unsent_locations", string_join_ext(",", global.ap_unsent_location_checks));
        ini_close();
        return;
    }

    _ap_send({
        cmd: "LocationChecks",
        locations: [location_id]
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

    network_send_raw(global.ap_socket, buffer, buffer_tell(buffer), network_send_text)
}