extends StaticBody2D

@export var move_distance: float = 144.0  # How far up it moves
@export var move_speed: float = 100.0     # Pixels per second
@export var delay_time: float = 4.50       # Seconds to wait before moving

var start_position: Vector2
var target_position: Vector2
var moving: bool = false

func _ready():
	start_position = position
	target_position = position - Vector2(0, move_distance)
	await get_tree().create_timer(delay_time).timeout
	moving = true

func _process(delta):
	if moving:
		position = position.move_toward(target_position, move_speed * delta)
		if position == target_position:
			moving = false
