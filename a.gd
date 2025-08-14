extends CharacterBody2D

@export var start_delay: float = 8.0    # seconds to wait before moving
@export var move_speed: float = 100.0   # pixels per second
@export var move_distance: float = 92. # total distance to move up

var _elapsed_time: float = 0.0
var _moving: bool = false
var _moved_distance: float = 0.0

func _physics_process(delta: float) -> void:
	_elapsed_time += delta

	# start moving after the delay
	if not _moving and _elapsed_time >= start_delay:
		_moving = true

	if _moving and _moved_distance < move_distance:
		var motion = Vector2(0, -move_speed * delta)

		# ensure we don't move more than move_distance
		if _moved_distance + abs(motion.y) > move_distance:
			motion.y = - (move_distance - _moved_distance)
			_moving = false  # stop after reaching distance

		move_and_collide(motion)
		_moved_distance += abs(motion.y)
