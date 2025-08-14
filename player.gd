extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const LANDING_DETECTION_DELAY = 0.1
const BOUNCE_GRAVITY_IGNORE = 0.1

@onready var animation = $player_animation
var last_direction := "right"
var last_animation := ""
var was_on_floor := false
var landing := false
var time_since_start := 0.0

# Movement lock
var can_move := true
# Temporary bounce gravity ignore
var bounce_timer := 0.0

func _ready():
	was_on_floor = is_on_floor()

func _physics_process(delta: float) -> void:
	time_since_start += delta

	if not can_move:
		velocity.x = 0
		return

	# Gravity
	if bounce_timer > 0:
		bounce_timer -= delta
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta

	# Jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		landing = false
		play_animation("jumping")

	# Movement input
	var direction := Input.get_axis("left", "Right")
	if direction != 0:
		velocity.x = direction * SPEED
		last_direction = "right" if direction > 0 else "left"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Landing detection
	if time_since_start > LANDING_DETECTION_DELAY:
		if not was_on_floor and is_on_floor():
			landing = true
			play_animation("landing")

	if landing:
		if not animation.is_playing():
			if abs(velocity.x) > 0:
				landing = false
				play_animation(last_direction)
	else:
		if is_on_floor():
			if abs(velocity.x) > 0:
				play_animation(last_direction)
			else:
				var stop_anim = "stop" + last_direction
				if last_animation != stop_anim:
					play_animation(stop_anim)

	# Spring collision detection
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var col = get_slide_collision(i)
		if col == null:
			continue
		var collider = col.get_collider()
		if collider == null:
			continue
		if collider.is_in_group("spring") and velocity.y > 0:
			# Apply bounce
			velocity.y = -1200
			bounce_timer = BOUNCE_GRAVITY_IGNORE

			# Play spring animation
			if collider.has_node("AnimatedSprite2D/AnimationPlayer"):
				var anim = collider.get_node("AnimatedSprite2D/AnimationPlayer")
				if anim.has_animation("bounce"):
					anim.play("bounce")

	was_on_floor = is_on_floor()

func die():
	print("Player died!")
	position = Vector2(100, 100)

func set_movement_enabled(enabled: bool) -> void:
	can_move = enabled

func play_animation(anim_name: String) -> void:
	if last_animation == anim_name:
		return
	last_animation = anim_name
	animation.play(anim_name)
