shader_type canvas_item;

uniform sampler2D noise;
uniform float step_width: hint_range(0.0, 1.0, 0.05) = 1.0;

void fragment() {
	vec4 noise_color = texture(noise, UV);
	vec4 current_color = texture(TEXTURE, UV);
	if(noise_color.r>step_width-0.1 && step_width!=1.0){
		COLOR.rgb=vec3(0.541,0.878,0.906);
	}
	COLOR.a = step(noise_color.r, step_width) * current_color.a;
	//COLOR.a = step(noise_color.r, (cos(TIME) + 1.0) / 2.0) * current_color.a;
}