extends Area2D

@onready var timer_label = get_node("/root/World/On-Screen Timer/Label")  # adjust the root if needed

func _ready():
	# Connect the body_entered signal using a callable
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Object) -> void:
	if body.is_in_group("player"):
		print("Player reached the end zone!")
		if timer_label != null:                                                    
			timer_label.stop_timer()
		else:
			push_error("Timer Label not found! Check node path.")
