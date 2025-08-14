extends AnimatableBody2D

@export var bounce_force: float = 800.0
@export var cooldown_time: float = 0.5

var can_bounce := true

# AnimatedSprite2D/AnimationPlayer
@onready var anim_player = $AnimatedSprite2D/AnimationPlayer
# Area2D for detecting the player
@onready var trigger_area = $Area2D

func _ready():
	if trigger_area:
		trigger_area.body_entered.connect(_on_body_entered)
	else:
		push_error("Area2D not found!")

func _on_body_entered(body):
	if not can_bounce or body == null:
		return
	if body.is_in_group("player") and body.has_variable("velocity"):
		can_bounce = false
		body.velocity.y = -bounce_force
		if anim_player and anim_player.has_animation("bounce"):
			anim_player.play("bounce")
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
