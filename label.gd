extends Label

var waiting_for_input := false
var start_time := 0.0
var game_started := false
var high_score := INF
@export var wait_before_input := 6.0  # seconds before first input

func _ready():
	visible = false
	# Wait before allowing input to start
	await get_tree().create_timer(wait_before_input).timeout
	waiting_for_input = true
	print("Waiting for player input to start timer...")

func _unhandled_input(event):
	# Start the timer on any input
	if waiting_for_input and (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton):
		waiting_for_input = false
		game_started = true
		visible = true
		start_time = Time.get_ticks_msec() / 1000.0
		print("Timer started!")

func _process(delta):
	if game_started:
		var elapsed := Time.get_ticks_msec() / 1000.0 - start_time
		var best_text := "--" if high_score == INF else "%.2f" % high_score
		text = "Time: %.2f s   Best: %s s" % [elapsed, best_text]

	# Restart game when pressing R
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

# Called by the end zone
func stop_timer():
	if not game_started:
		return
	game_started = false
	var elapsed := Time.get_ticks_msec() / 1000.0 - start_time
	if elapsed < high_score:
		high_score = elapsed
	print("Timer stopped at %.2f seconds" % elapsed)
