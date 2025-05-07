@tool
class_name Cell
extends TextureRect

const 白色64 = preload("res://art/cell/白色64.png")
const 蓝灰色64 = preload("res://art/cell/蓝灰色64.png")
const 黑色64 = preload("res://art/cell/黑色64.png")
const 橙色64 = preload("res://art/cell/橙色64.png")

@export_enum("white", "black", "orange","blue") var type: String:
	set(v):
		type=v
		match v:
			"white":
				self.texture=白色64
			"black":
				self.texture=黑色64
			"orange":
				self.texture=橙色64
			"blue":
				self.texture=蓝灰色64

var cell_pos:Vector2

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	var pos:Vector2=self.position+self.pivot_offset
	cell_pos=Global.format_cell(pos)
	Global.cell_pos_arry.append(cell_pos)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index==MOUSE_BUTTON_LEFT:
			#记录被选中的cell
			if not is_instance_valid(Global.selected_cell0):
				Global.selected_cell0=self
				#print("0x",Global.selected_cell0)
				return
			elif is_instance_valid(Global.selected_cell0) and not is_instance_valid(Global.selected_cell1):
				Global.selected_cell1=self
				#print("1x",Global.selected_cell1)
			elif is_instance_valid(Global.selected_cell0) and is_instance_valid(Global.selected_cell1):
				Global.selected_cell0=Global.selected_cell1
				Global.selected_cell1=self
				#print("0x",Global.selected_cell0)
				#print("1x",Global.selected_cell1)
			

			#如果是同类型的，将计算消除
			if Global.selected_cell1.type==Global.selected_cell0.type:
				if Global.calculate(Global.selected_cell0.cell_pos,Global.selected_cell1.cell_pos):
					_disable()
			self.modulate=Color(1,0,0,self.modulate.a)
			#print(cell_pos)
	pass # Replace with function body.

func _disable():
	Global.selected_cell0.modulate.a=0
	Global.selected_cell1.modulate.a=0
	Global.selected_cell0=null
	Global.selected_cell1=null
	
	printt(Global.selected_cell0,Global.selected_cell1)
