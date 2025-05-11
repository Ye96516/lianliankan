shader_type canvas_item;
// 圆角参数（0-0.5比例）
uniform float radius : hint_range(0, 0.5) = 0.15;
// 四角独立开关
uniform bool corner_top_left = true;
uniform bool corner_top_right = true;
uniform bool corner_bottom_left = true;
uniform bool corner_bottom_right = true;
// 抗锯齿参数
uniform float antialias : hint_range(0, 0.1) = 0.005;

void fragment() {
    vec2 uv = UV;
    vec4 color = texture(TEXTURE, uv);

    // 计算四个角的距离场[1](@ref)
    vec2 corner_distances = vec2(
        (corner_top_left ? length(max(vec2(radius) - uv, vec2(0.0))) : 1.0),
        (corner_top_right ? length(max(uv - vec2(1.0 - radius, radius), vec2(0.0))) : 1.0)
    );
    vec2 corner_distances2 = vec2(
        (corner_bottom_left ? length(max(uv - vec2(radius, 1.0 - radius), vec2(0.0))) : 1.0),
        (corner_bottom_right ? length(max(uv - vec2(1.0 - radius, 1.0 - radius), vec2(0.0))) : 1.0)
    );

    // 获取最小有效距离[4](@ref)
    float min_distance = min(
        min(corner_distances.x, corner_distances.y),
        min(corner_distances2.x, corner_distances2.y)
    );

    // 抗锯齿处理[3](@ref)
    float alpha = smoothstep(radius + antialias, radius - antialias, min_distance);
    COLOR = color * vec4(1.0, 1.0, 1.0, alpha);
}