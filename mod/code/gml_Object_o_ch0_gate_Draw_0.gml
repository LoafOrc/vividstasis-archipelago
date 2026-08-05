event_inherited();
draw_set_color(c_fuchsia);
draw_set_font(global.default_font);
draw_set_halign(fa_center);
draw_text_o(x + 24, y + 23, "AP");
draw_sprite_ext(sp_ch0_crystal_gate, 1, x, y, 1, 1, 0, c_white, unlock_animation);
