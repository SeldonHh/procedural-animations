extends Node2D

@export var body_sizes : Array[int] = [18,21,18,16,16,16,16,16,15,15,15,15,15,15,15,14,14,14,14,14,12,12,12,12,12,10,10,10,10,9,9,9,8,8]
var structure_point_scene = preload("res://Game/scenes/structure point/structure_point.tscn")
var head : Structure_Point = null
var structure_points : Array[Structure_Point] = []
var points : Array[Vector2]
@export var body_color : Color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
@export var outline_color : Color = Color.WHITE
@export var show_outline : bool = false
var draw_filling : bool = false
@export var spawn_lenght : float = 500.0
@export var main_creature : bool = false

func _draw() -> void:
	#FILLING
	if draw_filling:
		draw_polygon(points,[body_color])
	else:
		draw_filling = true
	#DETAILS
	draw_circle(head.to_global(head.left/2.4),3,Color.BLACK)
	draw_circle(head.to_global(head.right/2.4),3,Color.BLACK)
	

func _ready() -> void:
	if !main_creature:
		$Camera2D.enabled = false
	$Line2D.default_color = outline_color
	$Line2D.visible = show_outline
	for i in len(body_sizes):
		var new_point = structure_point_scene.instantiate()
		new_point.position.x = i * spawn_lenght/float(len(body_sizes))
		new_point.radius = body_sizes[i]
		new_point.parent = self
		if i == 0:
			new_point.head = true
			head = new_point
		structure_points.append(new_point)
		add_child(new_point)
	for i in len(structure_points):
		if i < len(structure_points)-1:
			structure_points[i].next_point = structure_points[i+1]
		
func _process(_delta: float) -> void:
	$Camera2D.global_position = head.global_position
	$Line2D.points = points
	points.clear()
	points.append(head.to_global(head.right - head.parametric))
	points.append(head.to_global(-head.parametric * 1.4 + head.right * 0.2))
	points.append(head.to_global(-head.parametric * 1.4 + head.left * 0.2))
	points.append(head.to_global(head.left - head.parametric))
	for structure in structure_points:
		points.append(structure.to_global(structure.left))
	for i in range(structure_points.size()-1,-1,-1):
		var structure = structure_points[i]
		points.append(structure.to_global(structure.right))
	queue_redraw()
