@tool
extends GridContainer

@export var type_number:int=4
var icons:=[]

#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("mouse_left"):
		#print(cell_pos_arry)
func _ready() -> void:

	self.position=Global.init_data.lt_pos*\
	(Global.init_data.size+Global.init_data.gap)
	
	var child_number:int=get_child_count()
	var pairs=child_number/2
	for i in pairs:
		icons.append(i % 4+ 1)  
		icons.append(i % 4 + 1)
	icons.shuffle()
	#print(icons)
	var i:=0
	for child in get_children():
		var v:int=icons[i]
		
		#print(v)
		match v:
			1:
				child.type="白色64"
			2:
				child.type="黑色64"
			3:
				child.type= "橙色64"
			4:
				child.type="蓝灰色64"
			
				
		i+=1
		
