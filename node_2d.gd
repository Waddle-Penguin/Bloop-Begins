extends Node2D

@export var bounce_force: float = 800.0
@export var cooldown_time: float = 0.5

var can_bounce := true

@onready var anim_player = $AnimatedSprite2D/AnimationPlayer
@onready var area = $Area2D

func _ready():
	if area:
		area.body_entered.connect(_on_body_entered)
		print("Spring ready, Area2D connected")
	else:
		push_error("Area2D not found!")

func _on_body_entered(body):
	print("Body entered:", body.name)  # Testing collision
	if not can_bounce or body == null:
		return

	if body.is_in_group("player"):
		print("Bouncing player!")  # Testing logic
		can_bounce = false

		# Launch player upward
		if body.has_variable("velocity"):
			body.velocity.y = -bounce_force
		else:
			print("Warning: player has no velocity variable!")

		# Play spring animation
		if anim_player and anim_player.has_animation("bounce"):
			anim_player.play("bounce")
			print("Playing bounce animation")
		else:
			print("Warning: AnimationPlayer missing or no 'bounce' animation")

		# Start cooldown timer
		_start_cooldown()

func _start_cooldown():
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = cooldown_time
	add_child(t)
	t.start()
	t.timeout.connect(_on_cooldown_timeout)

func _on_cooldown_timeout():
	can_bounce = true
	print("Spring ready again")
