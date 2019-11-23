extends "res://Scripts/Projectile.gd"

const MAXIMUM_SPEED = 180

var direction = 1


func set_direction(dir):
	
	direction = dir


func _physics_process(delta): 
	
	speed.x = MAXIMUM_SPEED * delta * direction
	translate(speed)
	$AnimatedSprite.play("Disparo")
	
		
func _on_VisibilityNotifier2D_screen_exited():
	
	queue_free()


func _on_Box_Projectile_area_entered(area):
		
	if area.get_name() == "Hitbox_Pj":
		
		set_pj_hit(area,20)

