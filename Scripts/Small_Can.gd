extends StaticBody2D

func _ready():
	
	pass

func _on_Area2D_body_entered(body):
	
	if body.get_name() == "Pj" && body.health > 0:
		
		body.set_health(body.health + 20)
		queue_free()

	
	
