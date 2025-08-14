extends StaticBody2D

@export var start_delay := 2.0 # seconds to wait before moving
@export var move_speed := 100.0 # pixels per second
@export var target_y := 150.0 # stop at this Y position

var _start_time := 0.0
var _moving := false

func _ready():
	_start_time = Time.get_ticks_msec() / 1000.0 # record start time

func _process(delta):
	var current_time = Time.get_ticks_msec() / 1000.0

	# start moving after the delay
	if not _moving and current_time - _start_time >= start_delay:
		_moving = true

	# move upward until we reach the target Y
	if _moving and position.y > target_y:
		position.y -= move_speed * delta
		if position.y <= target_y:
			position.y = target_y
			_moving = false
