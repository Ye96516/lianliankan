extends Node

#被选中的cell的标准化坐标
var selected_cell_pos:Array
#被选中的cell
var selected_cell0:Cell
var selected_cell1:Cell

#所有cell的标准化坐标
var cell_pos_arry:PackedVector2Array

#将坐标标准输出
func format_cell(v:Vector2):
	var gap:int=4
	var column:int=8
	var row:int=6
	var final:Vector2
	
	for i in column:
		if  i*(64+gap)<v.x and (i+1)*(64+gap)>v.x:
			final.x=i+1
			break
	for i in row:
		if  i*(64+gap)<v.y and (i+1)*(64+gap)>v.y:
			final.y=i+1
			break
	return final

#计算消除
func calculate(v:Vector2):
	selected_cell_pos.append(v)
	if selected_cell_pos.size()<=1:
		return

	if selected_cell_pos.size()==3:
		selected_cell_pos.remove_at(0)
	#此处已经将数组的大小限制为2了
	
	#直线检测
	if _check_straight_line(selected_cell_pos[0],selected_cell_pos[1]):
		print("坐标为%s和%s的cell可消除"%[selected_cell_pos[0],selected_cell_pos[1]])
		return true

func _check_straight_line(a: Vector2, b: Vector2) -> bool:
	if a.x == b.x:
		var step = 1 if b.y > a.y else -1
		for y in range(a.y + step, b.y, step):
			if Vector2(a.x,y) in cell_pos_arry:
				return false
		return true
	elif a.y==b.y:
		var step = 1 if b.x > a.x else -1
		for x in range(a.x + step, b.x, step):
			if Vector2(x,a.y) in cell_pos_arry:
				return false
		return true
	return false
#func _check_straight_line(a: Vector2i, b: Vector2i) -> bool:
	#if a.x == b.x:  # 垂直方向检测（网页1的直连型[1](@ref)）
		#var step = 1 if b.y > a.y else -1
		#for y in range(a.y + step, b.y, step):
			#if grid[y][a.x] != 0: return false
		#return true
	#elif a.y == b.y:  # 水平方向检测
		#var step = 1 if b.x > a.x else -1
		#for x in range(a.x + step, b.x, step):
			#if grid[a.y][x] != 0: return false
		#return true
	#return false
