extends Area2D

@export var bounce_strength := 700
@onready var anim_player := $AnimatedSprite2D/AnimationPlayer

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	# Launch the player upward
	body.velocity.y = -bounce_strength

	# Play bounce animation if available
	if anim_player and anim_player.has_animation("bounce"):
		anim_player.play("bounce")

	print("Player bounced!")  # for testing
