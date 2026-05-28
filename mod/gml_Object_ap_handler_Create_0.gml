///@description Network connection data

//Maybe you can optimize this better? it works already for what it needs to be.
wss = network_socket_wss
ws = network_socket_ws
network_send_text = 2

global.secure = false
global.ap_socket = -1

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
})