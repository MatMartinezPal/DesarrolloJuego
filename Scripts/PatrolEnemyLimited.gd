extends "res://Scripts/Enemy.gd"


var direction = 1
var initial_position_x

func _ready():
	
	initial_position_x = global_position.x
	initial_position = global_position
	

func _physics_process(delta):
	
	speed.y += GRAVITY
	
	if get_direction() == 1:
			
		if round(abs(initial_position_x-global_position.x)) >= 40:
			$CollisionShape2D.position.x *= -1
			$Damage_Area/CollisionShape2D.position.x *= -1
			set_direction(-1)
			$AnimatedSprite.flip_h = true
			
	elif get_direction() == -1:
				
		if round(abs(global_position.x-initial_position_x)) >= 40:
			$CollisionShape2D.position.x *= -1
			$Damage_Area/CollisionShape2D.position.x *= -1
			set_direction(-1)
			$AnimatedSprite.flip_h = false
		
	if get_death() == 0:
		speed.x = MAXIMUM_SPEED * get_direction()
	else:
		speed.x = 0
	speed = move_and_slide(speed,Vector2(0,-1))
	
	
func get_direction():
	
	return self.direction
	
func set_direction(direction):
	
	self.direction *= direction
	

func _on_Hitbox_area_entered(area):
	
	if area.get_name() == "Hitbox_Guitar_Slash" || area.get_name() == "Hitbox_Bounce" || area.get_name() =="Area2D_Counter_Proyectile" || area.get_name().find("Special_Sound") != -1:
		
		enemy_set_hit(area,100,100,100,100,0)


func _on_Damage_Area_area_entered(area):
	
	if area.get_name() == "Hitbox_Pj":
		
		if get_direction() == 1:
			
			$AnimatedSprite.flip_h = true
			
		else:
			
			$AnimatedSprite.flip_h = false
			
		$CollisionShape2D.position.x *= -1
		$Damage_Area/CollisionShape2D.position.x *= -1
		set_direction(-1)
		
		set_pj_hit(area,10)
		

func _on_Damage_Area_body_entered(body):
	if body.get_name() == "Pj" && body.get_node("Timer_Invicibility").is_stopped() == false:
		if get_direction() == 1:
			
			$AnimatedSprite.flip_h = true
			
		else:
			
			$AnimatedSprite.flip_h = false
			
		$CollisionShape2D.position.x *= -1
		$Damage_Area/CollisionShape2D.position.x *= -1
		set_direction(-1)


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


func _on_Timer_Modulate_timeout():
	pass
