extends Node

#被选中的cell
var selected_cell0:Cell
var selected_cell1:Cell

#所有cell的标准化坐标
var cell_pos_arry:PackedVector2Array

#最终的路径
var final_path:=[]

#对资源的引用
#const 白色64 = preload("res://art/cell/白色64.png")
#const 蓝灰色64 = preload("res://art/cell/蓝灰色64.png")
#const 黑色64 = preload("res://art/cell/黑色64.png")
#const 橙色64 = preload("res://art/cell/橙色64.png")
#const 火龙果 = preload("res://art/cell/火龙果.png")
#const 橘子 = preload("res://art/cell/橘子.png")
#const 葡萄 = preload("res://art/cell/葡萄.png")
#const 西瓜 = preload("res://art/cell/西瓜.png")
#const 黄瓜 = preload("res://art/cell/黄瓜.png")
#const 幻橘子 = preload("res://art/cell/幻橘子.png")
#const 幻火龙果 = preload("res://art/cell/幻火龙果.png")
#const 幻葡萄 = preload("res://art/cell/幻葡萄.png")

#初始化的一些数据，或许将来考虑做成res？
var init_data:={
	"type":4,
	"column":8,
	"row":6,
	"size":128,
	"gap":4,
	"lt_pos":Vector2(3,1),
	#"total_type_res":[白色64,蓝灰色64,黑色64,橙色64,火龙果,橘子,葡萄,西瓜,黄瓜,幻橘子,幻火龙果,幻葡萄]
}

#边缘的网格
@onready var the_edge:PackedVector2Array=spawn_edge(8,6)
func _ready() -> void:
	print(local_cell(Vector2(1,1)))

#生成边界
func spawn_edge(column:int,row:int):  
	var array:PackedVector2Array
	for i in column+4:
		array.append(Vector2(-1+i,-1))
		array.append(Vector2(-1+i,row+2))
	for i in row+2:
		array.append(Vector2(-1,i))
		array.append(Vector2(column+2,i))
	return array

#将坐标标准输出
func format_cell(v:Vector2):
	var final:Vector2
	for i in init_data.column:
		if  i*(init_data.size+init_data.gap)<v.x and \
		(i+1)*(init_data.size+init_data.gap)>v.x:
			final.x=i+1
			break
	for i in init_data.row:
		if  i*(init_data.size+init_data.gap)<v.y and\
		 (i+1)*(init_data.size+init_data.gap)>v.y:
			final.y=i+1
			break
	return final

#将标准化的输出全局化
func local_cell(v):
	if typeof(v)==5:
		var final:Vector2
		var off:Vector2=init_data.lt_pos*(init_data.size+init_data.gap)
		var local:Vector2=v*(init_data.size+init_data.gap)-Vector2(init_data.size/2,init_data.size/2)
		return off+local
	var final1:Array
	if typeof(v)==28 or typeof(v)==36:
		for i in v:
			var final:Vector2
			var off:Vector2=init_data.lt_pos*(init_data.size+init_data.gap)
			var local:Vector2=i*(init_data.size+init_data.gap)-Vector2(init_data.size/2,init_data.size/2)
			final1.append(off+local) 
		return final1
		
#计算消除
func calculate(v1:Vector2,v2:Vector2):
	if v1==v2:
		return

	#直线检测
	if _check_straight_line(v1,v2):
		#消除匹配的cell在数组中的值
		_disabled(v1,v2)
		#print("坐标为%s和%s的cell可消除"%[v1,v2])
		return true
	#一个拐角检测
	if _check_single_corner(v1,v2):
		_disabled(v1,v2)
		return true
	#两个拐角检测
	if _check_bfs_path(v1,v2):
		#print("llll")
		_disabled(v1,v2)
		return true
	
#无折线
func _check_straight_line(a: Vector2, b: Vector2,is_clear:bool=true) -> bool:
	#竖直方向上相同
	if is_clear:
		final_path.clear()
	if a.x == b.x:
		var step = 1 if b.y > a.y else -1
		final_path.append(a)
		for y in range(a.y + step, b.y, step):
			if Vector2(a.x,y) in cell_pos_arry:
				final_path.clear()
				return false
			final_path.append(Vector2(a.x,y))
		final_path.append(b)
		return true
	#水平方向上相同
	elif a.y==b.y:
		var step = 1 if b.x > a.x else -1
		final_path.append(a)
		for x in range(a.x + step, b.x, step):
			if Vector2(x,a.y) in cell_pos_arry:
				final_path.clear()
				return false
			final_path.append(Vector2(x,a.y))
		final_path.append(b)
		return true
	return false

#单个折线
func _check_single_corner(a: Vector2, b: Vector2) -> bool:
	var corner1 = Vector2(a.x, b.y) 
	var corner2 = Vector2(b.x, a.y)
	if ((corner1 not in cell_pos_arry) and 
	_check_straight_line(a, corner1,false) and 
	_check_straight_line(corner1, b,false)):
		final_path.erase(corner1)
		return true
	if ((corner2 not in cell_pos_arry) and 
	_check_straight_line(a, corner2,false) and 
	_check_straight_line(corner2, b,false)) :
		final_path.erase(corner2)
		return true
	return false
	#return ((corner1 not in cell_pos_arry) and 
	#_check_straight_line(a, corner1,false) and 
	#_check_straight_line(corner1, b,false)) or \
	#((corner2 not in cell_pos_arry) and 
	#_check_straight_line(a, corner2,false) and 
	#_check_straight_line(corner2, b,false)) 
		
	
		
#两个折线
func _check_bfs_path(start: Vector2, end: Vector2) -> bool:
	var queue = [{"pos": start, "from": Vector2(-1, -1),
	 			"corners": 0,"path":[start]}]
	var visited:={}
	while queue.size() > 0:
		#弹出第一个元素
		#print("当前的数组为：",queue,"\n")
		var current = queue.pop_front()
		#print("当前弹出的元素为",current)
		#print("............................................")
		var pos = current.pos
		#若找到目标返回true
		if pos == end:
			print("神奇，竟然从这里成功了，快回代码看看")
			return true
		visited[pos]=true
		#向四周延伸
		for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
			var next_pos=pos+dir
			var new_corners = current.corners
			#注意gds数组是引用传递
			var new_path=current.path.duplicate()
			
				#
			if next_pos ==end:
				if dir != (pos - current.from):
					new_corners+=1
				#queue.clear()
				if new_corners<3:
					new_path.append(next_pos)
					var final_dic={
					"pos": next_pos,
					"from":pos,
					"corners":new_corners,
					"path":new_path
					}
					final_path=new_path
					print("最终字典为:", final_dic)
					#print("path.size",queue[0].path.size())
					return true
			if next_pos in cell_pos_arry or\
			 visited.has(next_pos) or\
			next_pos in the_edge:
				continue
			
			#if next_pos.x
			if dir != (pos - current.from) and current.from!=Vector2(-1,-1):
				#print("当前dir为",dir)
				new_corners+=1
			if new_corners<3:
				new_path.append(next_pos)
				#print(new_path)
				queue.append({
					"pos": next_pos,
					"from":pos,
					"corners":new_corners,
					"path":new_path
				})

	print("失败了，噜啦噜啦噜啦啦啦")
	print(selected_cell0,"000")
	print(selected_cell1,"111")
	return false

#消除匹配的cell的坐标，对应的节点在cell本身的脚本替换为空
func _disabled(v1:Vector2,v2:Vector2):
	var index_v1:int=cell_pos_arry.find(v1)
	cell_pos_arry.remove_at(index_v1)
	var index_v2:int=cell_pos_arry.find(v2)
	cell_pos_arry.remove_at(index_v2)
