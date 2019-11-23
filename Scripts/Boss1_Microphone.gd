extends "res://Scripts/Projectile.gd"

const MAXIMUM_SPEED = 230
var direction = 1

func _ready():
	if direction == 1:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true

func _physics_process(delta):
	speed.x = MAXIMUM_SPEED * delta * direction
	translate(speed)
	
	
	


func _on_Area2D_area_entered(area):
	
	if area.get_name() == "Hitbox_Pj":
		
		set_pj_hit(area,20)
