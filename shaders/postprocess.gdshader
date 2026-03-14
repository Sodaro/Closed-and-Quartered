shader_type canvas_item;

global uniform vec3 bg_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform sampler2D noise;

const float speed = 0.2;
const float min_noise = 0.05;
const float noise_amplitude = 0.01;
const float scroll_speed = 0.005;


void fragment() {
    vec3 col = texture(screen_texture, SCREEN_UV).xyz * 1.0;
	float t = TIME;
	vec2 uv = vec2(mod(UV.x + t * scroll_speed, 1), mod(UV.y + t * 0.001, 1));
	float alpha = (sin(t) + 1.0) * 0.5 * noise_amplitude; //0 to 1
	COLOR.xyz = col;
	//
	//COLOR.rgb = bg_color;
	//COLOR.a = 0.5 + (alpha + min_noise) * texture(noise, uv).r;
	// Called for every pixel the material is visible on.
}