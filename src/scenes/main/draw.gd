@tool
class_name Grid2D
extends Node2D

@export var cell_size := Vector2i(64, 64) : set = set_cell_size
@export var grid_size := Vector2i(10, 8) : set = set_grid_size
@export var gap := 4 : set = set_gap  # 新增间隔参数
@export var line_color := Color.BLACK
@export var coord_color := Color.WHITE

func set_cell_size(value):
	cell_size = value
	queue_redraw()

func set_grid_size(value):
	grid_size = value
	queue_redraw()

func set_gap(value):  # 新增间隔设置方法
	gap = value
	queue_redraw()

func _draw():
	# 计算带间隔的总尺寸
	var total_width = grid_size.x * (cell_size.x + gap) - gap
	var total_height = grid_size.y * (cell_size.y + gap) - gap
	
	# 绘制垂直网格线
	for x in grid_size.x + 1:
		var line_x = x * (cell_size.x + gap)
		draw_line(
			Vector2(line_x, 0), 
			Vector2(line_x, total_height), 
			line_color
		)
	
	# 绘制水平网格线
	for y in grid_size.y + 1:
		var line_y = y * (cell_size.y + gap)
		draw_line(
			Vector2(0, line_y), 
			Vector2(total_width, line_y), 
			line_color
		)
	
	# 绘制坐标文本（适配间隔布局）
	var font = ThemeDB.fallback_font
	var font_size = 24
	for x in grid_size.x:
		for y in grid_size.y:
			# 计算格子中心位置（包含间隔）
			var pos_x = x * (cell_size.x + gap) + cell_size.x / 2
			var pos_y = y * (cell_size.y + gap) + cell_size.y / 2
			draw_string(
				font, 
				Vector2(pos_x - 8, pos_y + 6), 
				"(%d,%d)" % [x, y], 
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				font_size,
				coord_color
			)
