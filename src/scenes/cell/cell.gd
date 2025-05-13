@tool
class_name Cell
extends PanelContainer

const 白色64 = preload("res://art/cell/白色64.png")
const 蓝灰色64 = preload("res://art/cell/蓝灰色64.png")
const 黑色64 = preload("res://art/cell/黑色64.png")
const 橙色64 = preload("res://art/cell/橙色64.png")
const 火龙果 = preload("res://art/cell/火龙果.png")
const 橘子 = preload("res://art/cell/橘子.png")
const 葡萄 = preload("res://art/cell/葡萄.png")
const 西瓜 = preload("res://art/cell/西瓜.png")
const 黄瓜 = preload("res://art/cell/黄瓜.png")
const 幻橘子 = preload("res://art/cell/幻橘子.png")
const 幻火龙果 = preload("res://art/cell/幻火龙果.png")
const 幻葡萄 = preload("res://art/cell/幻葡萄.png")

@export var cell_pic:TextureRect
@export_enum("白色64", "黑色64", "橙色64","蓝灰色64","火龙果",
			"橘子","葡萄","西瓜","黄瓜","幻橘子","幻火龙果","幻葡萄") var type: String:
	set(v):
		type=v
		if not is_instance_valid(cell_pic):return
		match v:
			"白色64":
				cell_pic.texture=白色64
			"黑色64":
				cell_pic.texture=黑色64
			"橙色64":
				cell_pic.texture=橙色64
			"蓝灰色64":
				cell_pic.texture=蓝灰色64
			"火龙果":
				cell_pic.texture=火龙果
			"橘子":
				cell_pic.texture=橘子
			"葡萄":
				cell_pic.texture=葡萄
			"西瓜":
				cell_pic.texture=西瓜
			"黄瓜":
				cell_pic.texture=黄瓜
			"幻火龙果":
				cell_pic.texture=幻火龙果
			"幻橘子":
				cell_pic.texture=幻橘子
			"幻葡萄":
				cell_pic.texture=幻葡萄
				

var cell_pos:Vector2
var is_disabled:bool

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	self.pivot_offset=Vector2(Global.init_data.size/2,Global.init_data.size/2)
	var pos:Vector2=self.position+self.pivot_offset
	#print(pos)
	cell_pos=Global.format_cell(pos)
	#print(cell_pos)
	Global.cell_pos_arry.append(cell_pos)

#var i:=0
func _on_gui_input(event: InputEvent) -> void:
	#i+=1
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index==MOUSE_BUTTON_LEFT:
			
			#记录被选中的cell
			if not is_instance_valid(Global.selected_cell0):
				Global.selected_cell0=self
				#print("0x",Global.selected_cell0)
				#点中时的效果
				AudioPlayer.play_click()
				Global.selected_cell0.modulate.a=0.5
				return
			elif is_instance_valid(Global.selected_cell0) and not is_instance_valid(Global.selected_cell1):
				Global.selected_cell1=self
				#点中时的效果
				Global.selected_cell1.modulate.a=0.5
				if Global.selected_cell0.type!=Global.selected_cell1.type:
					Global.selected_cell0.modulate.a=1
				#print("1x",Global.selected_cell1)
			elif is_instance_valid(Global.selected_cell0) and is_instance_valid(Global.selected_cell1):
					#点中时的效果
				self.modulate.a=0.5
				Global.selected_cell0.modulate.a=1
				if Global.selected_cell1.type!=self.type:
					Global.selected_cell1.modulate.a=1
				#赋值
				Global.selected_cell0=Global.selected_cell1
				Global.selected_cell1=self
				#print("0x",Global.selected_cell0)
				#print("1x",Global.selected_cell1)
			#print("零的坐标为",Global.selected_cell0.cell_pos)
			#print("一的坐标为",Global.selected_cell1.cell_pos)
			#print(i)
			#如果是同类型的，将计算消除
			if Global.selected_cell1.type==Global.selected_cell0.type:
				if Global.calculate(Global.selected_cell0.cell_pos,Global.selected_cell1.cell_pos):
					#print("零的坐标为",Global.selected_cell0.position+Vector2(64,64)+Vector2(132*3,132))
					#print("一的坐标为",Global.selected_cell1.position+Vector2(64,64)+Vector2(132*3,132))
					_disable()
					is_disabled=true
					AudioPlayer.play_selected()
					$"../../Line".on_show(Global.local_cell(Global.final_path))
				
			if not is_disabled:
				AudioPlayer.play_click()
			else:
				is_disabled=false
			#print(cell_pos)
	pass # Replace with function body.

func _disable():
	for i in 10:
		await get_tree().create_timer(0.05).timeout
		Global.selected_cell0.get_child(0).material.set_shader_parameter("step_width",(10-(i+1))/10.0)
		Global.selected_cell1.get_child(0).material.set_shader_parameter("step_width",(10-(i+1))/10.0)
	Global.selected_cell0.process_mode=Node.PROCESS_MODE_DISABLED
	Global.selected_cell1.process_mode=Node.PROCESS_MODE_DISABLED
	Global.selected_cell0=null
	Global.selected_cell1=null
	#printt(Global.selected_cell0,Global.selected_cell1)

func _click_effect():
	self.modulate.a=0.5
