extends Node2D
class_name Structure_Point

@export var radius : int = 10
@export var distance_constraint : int = 10
@export var next_point : Structure_Point
@export var head : bool = false
var left : Vector2 
var right : Vector2
var parametric : Vector2
var parent : Node2D = null

func _process(delta: float) -> void:
	if next_point != null:
		var distance_to_next_point = next_point.position - position
		distance_to_next_point =  distance_to_next_point.limit_length(distance_constraint)
		next_point.position = position+distance_to_next_point
		parametric = GameManager.get_parametric_equation(distance_to_next_point.angle(),radius)
		left = Vector2(-parametric.y,parametric.x)
		right = Vector2(parametric.y,-parametric.x)
	
	if head:
		var direction : Vector2 = Input.get_vector("left","right","up","down")
		var velocity : Vector2 = direction * 300 * delta
		position += velocity
