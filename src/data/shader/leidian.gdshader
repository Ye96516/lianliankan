shader_type canvas_item;

uniform bool is_disabled=false;

void fragment() {
	vec2 uv=vec2(UV.y,UV.x);
	uv.y+=TIME;
	uv.y=fract(uv.y);
	COLOR=texture(TEXTURE,uv);
	COLOR=vec4(COLOR.r+20.0,COLOR.g,COLOR.b,COLOR.a);
}