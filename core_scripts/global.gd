extends Node

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
func calculate(v1:Vector2,v2:Vector2):
	if v1==v2:
		return

	#直线检测
	if _check_straight_line(v1,v2):
		#消除匹配的cell在数组中的值
		_disabled(v1,v2)
		print("坐标为%s和%s的cell可消除"%[v1,v2])
		return true

func _check_straight_line(a: Vector2, b: Vector2) -> bool:
	#竖直方向上相同
	if a.x == b.x:
		var step = 1 if b.y > a.y else -1
		for y in range(a.y + step, b.y, step):
			if Vector2(a.x,y) in cell_pos_arry:
				return false
		return true
	#水平方向上相同
	elif a.y==b.y:
		var step = 1 if b.x > a.x else -1
		for x in range(a.x + step, b.x, step):
			if Vector2(x,a.y) in cell_pos_arry:
				return false
		return true
	return false










#消除匹配的cell的坐标，对应的节点在cell本身的脚本替换为空
func _disabled(v1:Vector2,v2:Vector2):
	var index_v1:int=cell_pos_arry.find(v1)
	cell_pos_arry.remove_at(index_v1)
	var index_v2:int=cell_pos_arry.find(v2)
	cell_pos_arry.remove_at(index_v2)
