shader_type canvas_item;

uniform sampler2D screen: hint_screen_texture;

void fragment() {
	vec4 screen_color = texture(screen, SCREEN_UV);
	screen_color = 1.0 - screen_color;
	screen_color.a = 1.0;
	COLOR = screen_color * texture(TEXTURE, UV).a;
}
