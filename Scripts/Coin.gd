extends StaticBody2D

func _ready():
	pass

func _on_Area2D_body_entered(body):
	
	if body.get_name() == "Pj" && body.health > 0:
		
		body.points += 1
		body.get_parent().get_node("HUD/Points_Counter").set_text(String(body.points))
		$Pick.play(0.0)
		$Sprite.set_visible(false)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
func _on_Pick_finished():
	
	queue_free()
