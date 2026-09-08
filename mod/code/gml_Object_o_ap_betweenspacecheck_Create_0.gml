event_inherited();

function set_id(loc_id) {
    self.loc_id = loc_id;
    if (struct_exists(global.ap_bsdata, loc_id)) {
        self.ap_loc = struct_get(global.ap_self.locations, struct_get(global.ap_bsdata, loc_id));
    }
    else
    {
        // this check doesn't exist - destroy and exit
        show_debug_message("destroying " + loc_id);
        instance_destroy(id);
        return;
    }
       
    if (self.ap_loc.is_checked())
        instance_destroy(id);
}

function interact()
{
    global.ap_logger.debug("interact with apcheck: " + self.loc_id + " (" + string(self.ap_loc.id) + ")");
    
    if (variable_global_exists("_ap_socket")) {
        ap_check(self.ap_loc);
        ap_run_through_queue();
        instance_destroy(id);
    }
    else
    {
        global.ap_logger.error("check can't send due to incomplete scouting information (are you online?): " + self.loc_id + " (" + string(self.ap_loc_id) + ")");
        play_se(buzzer);
    }
}
