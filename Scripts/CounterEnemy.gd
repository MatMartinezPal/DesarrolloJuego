extends "res://Scripts/Enemy.gd"

const PROYECTILE = preload("res://Scenes/Enemies/Counter/Counter_Proyectile.tscn")

var proyectile = null
var position_POSITION2D_left = 1
var position_POSITION2D_right = 0


func _ready():
	
	initial_position = global_position
	$AnimatedSprite.play("Idle")


func _physics_process(delta):
	
	speed.y += GRAVITY
	speed.x = lerp(speed.x,0,0.05)
	
	if $AnimatedSprite.get_frame() == 6 && $AnimatedSprite.get_animation() == "Shooting" :
		
		get_parent().get_parent().add_child(proyectile)
		
	elif $AnimatedSprite.get_frame() == 10 && $AnimatedSprite.get_animation() == "Shooting" :
		
		$AnimatedSprite.play("Idle")
	
	
	
	speed = move_and_slide(speed,Vector2(0,-1))
	
func change_Position2D (direction):
	
	if direction == "left" && position_POSITION2D_left == 1:
		
		pass
		
	elif direction == "left" && position_POSITION2D_left == 0:
		
		$Position2D.position.x *= -1
		position_POSITION2D_left = 1
		position_POSITION2D_right = 0
		
	elif direction == "right" && position_POSITION2D_right == 1:
		
		pass
		
	elif direction == "right" && position_POSITION2D_right == 0:
		
		$Position2D.position.x *= -1
		position_POSITION2D_left = 0
		position_POSITION2D_right = 1	
		
			
func _on_Area2D_body_entered(body):
	if body.get_name() == "Pj" && $Timer_Death.is_stopped() == true && body.health > 0 && get_death() == 0:
		
		proyectile = PROYECTILE.instance()
	
		if body.global_position.x < global_position.x:
				
			$AnimatedSprite.flip_h = false
			change_Position2D("left")
			proyectile.set_direction(-1)
				
		else:
				
			$AnimatedSprite.flip_h = true
			change_Position2D("right")
			proyectile.set_direction(1)
		
		$AnimatedSprite.play("Shooting")	
		
		proyectile.global_position = $Position2D.global_position
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		
		if $Timer_Shooting.is_stopped() == true:
				
			$Timer_Shooting.set_wait_time(3)
			$Timer_Shooting.start()
			
	
func _on_Timer_Shooting_timeout():
	
	$Timer_Shooting.stop()
	$Area2D/CollisionShape2D.set_deferred("disabled", false)	

func _on_Hitbox_Enemy_area_entered(area):
	
	if area.get_name() == "Hitbox_Guitar_Slash" || area.get_name() == "Hitbox_Bounce" || area.get_name() =="Area2D_Counter_Proyectile" || area.get_name().find("Special_Sound") != -1:
		enemy_set_hit(area,100,50,100,50)
		
			
	


func _on_Timer_Death_Animation_timeout():
	
	$Timer_Death_Animation.stop()
	$AnimatedSprite.set_visible(false)


func _on_Timer_Death_timeout():
	
	set_death(0)
	


func _on_VisibilityNotifier2D_screen_entered():
	
	if get_death() == 1:
		
		$Timer_Death.stop()


func _on_VisibilityNotifier2D_screen_exited():
	
	if get_death() == 1:
		
		if $Timer_Death.is_stopped() == true:
		
			$Timer_Death.set_wait_time(10)
			$Timer_Death.start()


func _on_Damage_Area_area_entered(area):
	
	if area.get_name() == "Hitbox_Pj":
		
		set_pj_hit(area,20)
	


func _on_Timer_Modulate_timeout():
	
	$Timer_Modulate.stop()
	$AnimatedSprite.set_modulate(Color("ffffff"))
	
