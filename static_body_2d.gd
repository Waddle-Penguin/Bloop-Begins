extends StaticBody2D

# Messages/animations to play in order
var messages = ["Message1", "Message2", "Message3","Message4"]
var current_index = 0

@onready var anim = $AnimatedSprite2D
@onready var player = get_parent()  # assumes this node is a direct child of the player

var switch_time = 1.5  # seconds per message
var timer = 0.0

func _ready():
	# Lock player movement
	if player and player.has_method("set_movement_enabled"):
		player.set_movement_enabled(false)
	
	# Start the first message
	anim.play(messages[current_index])

func _process(delta):
	timer += delta
	if timer >= switch_time:
		timer = 0.0
		current_index += 1
		
		if current_index >= messages.size():
			# Finished all messages: unlock player and remove node
			if player and player.has_method("set_movement_enabled"):
				player.set_movement_enabled(true)
			queue_free()
		else:
			# Play next message
			anim.play(messages[current_index])
