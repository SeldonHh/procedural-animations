extends Node

func get_parametric_equation(angle,radius):
	var x = radius * cos(angle)
	var y = radius * sin(angle)
	return Vector2(x,y)
