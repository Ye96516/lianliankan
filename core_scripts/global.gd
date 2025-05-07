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
		#print("坐标为%s和%s的cell可消除"%[v1,v2])
		return true
	#一个拐角检测
	if _check_single_corner(v1,v2):
		_disabled(v1,v2)
		return true
	#两个拐角检测
	if _check_bfs_path(v1,v2):
		_disabled(v1,v2)
		return true
	
	

#无折线
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

#单个折线
func _check_single_corner(a: Vector2i, b: Vector2i) -> bool:
	var corner1 = Vector2(a.x, b.y) 
	var corner2 = Vector2(b.x, a.y)
	return ((corner1 not in cell_pos_arry) and 
	_check_straight_line(a, corner1) and 
	_check_straight_line(corner1, b)) or \
	((corner2 not in cell_pos_arry) and 
	_check_straight_line(a, corner2) and 
	_check_straight_line(corner2, b)) 
		
#两个折线
func _check_bfs_path(start: Vector2, end: Vector2) -> bool:
	var queue = [{"pos": start, "from": Vector2(-1, -1), "corners": 0}]

	while queue.size() > 0:
		#去除第一个元素
		var current = queue.pop_front()
		print(current)
		var pos = current.pos
		#若找到目标返回true
		if pos == end:
			return true
		#向四周延伸
		for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
			var next_pos=pos+dir
			if next_pos in cell_pos_arry:
				continue
			var new_corners = current.corners
			#若拐弯则corner+1
			if dir != (pos - current.from):
				new_corners+=1
			
			#var next_pos = pos + dir
			#if next_pos in cell_pos_arry:continue
			#var new_corners = current.corners
			#if current.from != Vector2(-1, -1) && dir != (pos - current.from):
		
		#if visited.has(pos) && visited[pos] <= current.corners:
			#continue
		#visited[pos] = current.corners
		#for dir in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
			#var next_pos = pos + dir
			#if next_pos in cell_pos_arry:continue
			#var new_corners = current.corners
			#if current.from != Vector2(-1, -1) && dir != (pos - current.from):
				#new_corners += 1
				#if new_corners > 2: continue
			#if next_pos not in cell_pos_arry or next_pos == end:
				#queue.append({
					#"pos": next_pos,
					#"from": pos,
					#"corners": new_corners
				#})
	return false
#func _check_bfs_path(start: Vector2i, end: Vector2i) -> bool:
	#var queue = [{"pos": start, "from": Vector2i(-1, -1), "corners": 0}]
	#var visited = {}
	#
	#while queue.size() > 0:
		#var current = queue.pop_front()
		#var pos = current.pos
		#
		#if pos == end: 
			#return true
		#
		#var key = "%d,%d" % pos
		#if visited.has(key) && visited[key] <= current.corners:
			#continue
		#visited[key] = current.corners
		#
		## 四方向遍历（网页2的BFS优化[2](@ref)）
		#for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			#var next_pos = pos + dir
			#if !_is_valid_cell(next_pos): continue
			#
			## 计算拐角数（网页3的corner属性[3](@ref)）
			#var new_corners = current.corners
			#if current.from != Vector2i(-1, -1) && dir != (pos - current.from):
				#new_corners += 1
				#if new_corners > 2: continue
			#
			#if grid[next_pos.y][next_pos.x] == 0 || next_pos == end:
				#queue.append({
					#"pos": next_pos,
					#"from": pos,
					#"corners": new_corners
				#})
	#
	#return false

#消除匹配的cell的坐标，对应的节点在cell本身的脚本替换为空
func _disabled(v1:Vector2,v2:Vector2):
	var index_v1:int=cell_pos_arry.find(v1)
	cell_pos_arry.remove_at(index_v1)
	var index_v2:int=cell_pos_arry.find(v2)
	cell_pos_arry.remove_at(index_v2)
