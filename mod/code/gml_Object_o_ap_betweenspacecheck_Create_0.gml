event_inherited();

function lt_aploc()
{
    return (function()
    {
        __CoroutineBegin(function()
        {
            global.canInteract = false;
            if (variable_global_exists("ap_last_scoutinfo")) {
            strings = ["Collected " + global.ap_last_scoutinfo.name];
            } 
            else 
            {
                strings = [];
            }
        });
        __CoroutineForEach(function(arg0)
        {
            str = arg0;
        });
        __CoroutineForEachIn(function()
        {
            return strings;
        });
        __CoroutineThen(function()
        {
            obj_rpg_controller.dialogue(str);
        });
        __CoroutineAwait(function()
        {
            return obj_rpg_controller.dial();
        });
        __CoroutineThen(function()
        {
        });
        __CoroutineEndLoop(function()
        {
            obj_rpg_controller.destroyDialogueBox();
            global.canInteract = true;
        });
        return __CoroutineEnd();
    })();
}

function set_id(loc_id) {
    self.ap_loc_id = struct_get(global.ap_bsdata, loc_id);
    
    if (array_contains(global.ap_location_checks, self.ap_loc_id))
        instance_destroy(id);
}

function interact()
{
    ap_debug("interact with apcheck: " + self.loc_id + " (" + string(self.ap_loc_id) + ")", "debug");
    global.ap_last_scoutinfo = struct_get(global.ap_location_scouts, string(self.ap_loc_id));
    ap_check(self.ap_loc_id);
    
    with (obj_player_actor)
        var coroutine = lt_aploc();
    
    instance_destroy(id);
}
