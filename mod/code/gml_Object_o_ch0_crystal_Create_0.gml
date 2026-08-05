event_inherited();

// don't destroy crystals; replace all with respective AP checks
//if (global.c0_collected_crystals[pickup_id])
//    instance_destroy(id);

function interact()
{
    global.c0_collected_crystals[pickup_id] = true;
    var collected_crystals = "";
    
    for (var i = 0; i < array_length(global.c0_crystals); i++)
    {
        if (global.c0_collected_crystals[i])
        {
            if (string_length(collected_crystals) > 0)
                collected_crystals += ",";
            
            collected_crystals += string(i);
        }
    }
    
    ini_open(global.profile_file);
    ini_write_string("betweenspace", "crystals", collected_crystals);
    ini_close();
    var quantity = global.c0_crystals[pickup_id];
    global.scapecrystals += quantity;
    global.total_scapecrystals += quantity;
    obj_player_actor.crystal_gain_popup = @@string@@("+{0}", quantity);
    
    with (obj_player_actor)
        event_user(0);
    
    instance_destroy(id);
}
