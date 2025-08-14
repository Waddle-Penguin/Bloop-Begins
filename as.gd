extends StaticBody2D

@onready var anim_player = $AnimatedSprite2D/AnimationPlayer

func bounce():
	if anim_player.has_animation("bounce"):
		anim_player.play("bounce")
