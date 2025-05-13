class_name UIHover extends Node
"""
	1、为Control的派生类添加UIHover类型子节点
	2、默认悬停更改缩放，可选颜色、位置偏移
	3、设置对应的悬停目标数值
"""

## 添加动画的属性
@export_flags("scale", "color", "offset") var anim_type = 1
var select: Array[int]
## 动画时间
@export var t_time: float = 0.3
## 动画类型
@export var t_type: Tween.TransitionType

@export_group("属性设置")
## 悬停时的[code]缩放[/code]
@export var hover_scale: Vector2 = Vector2(1.3, 1.3)
# 默认缩放比例
var default_scale: Vector2 = Vector2.ONE

## 悬停时的[code]颜色[/code]
@export var hover_color: Color
# 默认相对坐标
var default_color: Color = Color(1, 1, 1, 1)

## 悬停时的[code]位置偏移[/code]
@export var hover_offset: Vector2 = Vector2.ZERO
# 默认相对坐标
var default_pos: Vector2 = Vector2.ONE

# 控制的目标
var target: Control

func _ready() -> void:
	target = get_parent()
	target.mouse_entered.connect(enter_hover)
	target.mouse_exited.connect(exit_hover)
	call_deferred("reset_value")
	
	for i in range(0, 6): # TODO 只计算到了2^5
		var _pow = int(pow(2, i))
		if (anim_type & _pow) != 0:
			select.append(_pow)
			
			
func reset_value():
	target.pivot_offset = target.size * 0.5
	default_scale = target.scale
	default_color = target.self_modulate
	default_pos = target.position
	
func enter_hover():
	for i in select:
		if i == 1:
			add_tween("scale", hover_scale, t_time)
		elif i == 2:
			add_tween("self_modulate", hover_color, t_time)
		elif i == 4:
			add_tween("position", default_pos + hover_offset, t_time)
		
func exit_hover():
	for i in select:
		if i == 1:
			add_tween("scale", default_scale, t_time)
		elif i == 2:
			add_tween("self_modulate", default_color, t_time)
		elif i == 4:
			add_tween("position", default_pos, t_time)
	
func add_tween(property: String, value: Variant, time: float):
	if get_tree():
		var t = get_tree().create_tween()
		t.tween_property(target, property, value, time).set_trans(t_type)
