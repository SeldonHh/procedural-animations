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
var head_directions : Array[Vector2] = [
Vector2.UP,
Vector2(1,-1),
Vector2.RIGHT,
Vector2(1,1),
Vector2.DOWN,
Vector2(-1,1),
Vector2.LEFT,
Vector2(-1,-1)]
var head_direction : Vector2 = Vector2.LEFT
var direction : Vector2 = Vector2.LEFT

func _ready() -> void:
	if head:
		$Timer.start()

func _process(delta: float) -> void:
	if next_point != null:
		var distance_to_next_point = next_point.position - position
		distance_to_next_point =  distance_to_next_point.limit_length(distance_constraint)
		next_point.position = position+distance_to_next_point
		parametric = GameManager.get_parametric_equation(distance_to_next_point.angle(),radius)
		left = Vector2(-parametric.y,parametric.x)
		right = Vector2(parametric.y,-parametric.x)
	
	if head:
		direction = lerp(direction,head_direction,0.05)
		var velocity : Vector2 = direction * 300 * delta
		position += velocity


func _on_timer_timeout() -> void:
	var head_direction_id = head_directions.find(head_direction)
	var neighbors = []
	neighbors.append(head_directions[(head_direction_id - 2) % head_directions.size()])
	neighbors.append(head_directions[(head_direction_id - 1) % head_directions.size()])
	neighbors.append(head_directions[(head_direction_id + 1) % head_directions.size()])
	neighbors.append(head_directions[(head_direction_id + 2) % head_directions.size()])

	head_direction = neighbors.pick_random()

	$Timer.wait_time = randf_range(0.55,0.7)
