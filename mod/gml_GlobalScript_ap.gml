// im keeping all of these in one file atm because i dont want to keep adding entries to the global script inits

function ap_debug(msg, level = "info") {
    show_debug_message("ap " + level + ": " + msg);
}

wss = network_socket_wss
ws = network_socket_ws
network_send_text = 2

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

    if(address == "archipelago.gg") {
        global.ap_socket = network_create_socket(wss) // secure
    } else {
        global.ap_socket = network_create_socket(ws) // unsecure
    }

    var isConnected = network_connect_raw(global.ap_socket, address, port)

    /*
    https://www.reddit.com/r/gamemaker/comments/50c0k1/network_connect_raw_only_returning_0/
    ???
    if(!isConnected) {
        ap_debug("establishing connection failed!", "error")
        callback({
            success: false,
            errors: ["ConnectFailed"]
        });
        return;
    }
    */

    global._ap_connection_callback = callback

    _ap_send({
        cmd: "Connect",
        password: password,
        game: "vivid/stasis",
        name: name,
        uuid: int64(999999),
        items_handling: int64(3), // this is 0b011: https://github.com/ArchipelagoMW/Archipelago/blob/main/docs/network%20protocol.md#items_handling-flags
        tags: [],
        version: { // archipelago version
            class: "Version",
            major: int64(0),
            minor: int64(5),
            build : int64(1)
        }
    })
}

function _ap_send(data) {
    ap_debug("sending command: " + data.cmd, "debug")
    var arr = [data]
    aa = json_stringify(arr)

    buffer = buffer_create(string_byte_length(aa), buffer_fixed,1)
    buffer_seek(buffer, buffer_seek_start, 0)
    buffer_write(buffer,buffer_text,aa)

    network_send_raw(global.ap_socket, buffer, buffer_tell(buffer), network_send_text)
}