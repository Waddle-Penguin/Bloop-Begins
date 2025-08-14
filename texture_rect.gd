extends TextureRect

@export var first_texture: Texture2D
@export var second_texture: Texture2D
@export var change_delay := 2.0 # seconds before changing texture
@export var vanish_delay := 1.0 # seconds after changing before vanishing

func _ready():
	texture = first_texture
	# Step 1: Change texture after delay
	await get_tree().create_timer(change_delay).timeout
	texture = second_texture
	# Step 2: Hide after another delay
	await get_tree().create_timer(vanish_delay).timeout
	hide()
