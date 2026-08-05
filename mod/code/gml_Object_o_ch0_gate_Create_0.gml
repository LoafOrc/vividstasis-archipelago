event_inherited();
image_speed = 0;
unlock_animation = 0;
unlocked = false;
ini_open(global.profile_file);

if (ini_read_real("ap", @@string@@("item_{0}", gate_ap_id), false))
{
    ini_close();
    instance_destroy(self);
}
else
{
    ini_close();
}

true_req = gate_req;

function interact()
{

}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2
}
