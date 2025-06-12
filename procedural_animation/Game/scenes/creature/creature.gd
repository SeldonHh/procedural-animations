extends Node2D

@export var body_sizes : Array[int] = [15,13,12,11,10,12,14,15,17,19,20,19,16,15,13,12,11,10,10,10]
var structure_point_scene = preload("res://Game/scenes/structure_point.tscn")
var head : Structure_Point = null
var structure_points : Array[Structure_Point] = []
var points : Array[Vector2]
var body_color : Color = Color.WEB_MAROON
var outline_color : Color = Color.WHITE

func _draw() -> void:
	draw_polygon(points,[body_color])

func _ready() -> void:
	$Line2D.default_color = outline_color
	for i in len(body_sizes):
		var new_point = structure_point_scene.instantiate()
		new_point.position.x = i * 500/len(body_sizes)
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
	$Line2D.points = points
	points.clear()
	points.append(head.to_global(head.right - head.parametric))
	points.append(head.to_global(-head.parametric * 1.5))
	points.append(head.to_global(head.left - head.parametric))
	for structure in structure_points:
		points.append(structure.to_global(structure.left))
	for i in range(structure_points.size()-1,-1,-1):
		var structure = structure_points[i]
		points.append(structure.to_global(structure.right))
	queue_redraw()
