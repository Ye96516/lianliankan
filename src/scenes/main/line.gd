extends Node2D

@onready var line_2d: Line2D = $Line2D


func on_show(v:PackedVector2Array):
	#line_2d.visible=true
	line_2d.points=v
	#await  get_tree().create_timer(2).timeout
	#line_2d.visible=false
