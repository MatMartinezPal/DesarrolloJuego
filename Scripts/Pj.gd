"""Script para las fisicas del personaje"""

""" Usar 0 como apagado ó como "No", 1 como encendido ó como "Si" """

"""Constantes y variables globales"""
extends KinematicBody2D

const ACCELERATION = 10
const MAXIMUM_SPEED = 180
const JUMP_POWER = -425
const SPECIAL_ATTACK = preload("res://Scenes/PJ/Special_Sound.tscn")

var gravity = 15
var speed = Vector2()
var friction
var health = 100
var activate_rebound_counter = 0
var rebounds_counter = 0
var activate_guitar_slash = 0
var activate_special_attack = 0
var special_shoots_fired = 0
var hit_air = 0
var hit = 0
var on_wall = 0
var on_jump = 0
var points = 0

var special_attack1 
var special_attack2

"""Funcion para condiciones iniciales del personaje cuando se instancia en la escena"""
func _ready():

	points = PlayerVariables.points
	PlayerVariables.position = get_parent().get_node("Initial_position").global_position
	get_parent().get_node("HUD/Points_Counter").set_text(String(points))
	get_parent().get_node("HUD/Lifes_Counter").set_text(String(PlayerVariables.lifes))
	
	
"""Funcion para las fisicas generales del personaje"""
func _physics_process(delta):
	
	friction = false
	speed.y += gravity
	
	if health > 0:

		if hit == 0 :
	
			if Input.is_action_pressed("d") && activate_guitar_slash == 0 && on_wall == 0 && activate_special_attack == 0:
				
				if Input.is_action_pressed("a") == false:
					
					speed.x = min(speed.x+ACCELERATION,MAXIMUM_SPEED)
					reflect_collision_shape_and_hitbox("right")
					play_animation("run")
					
				else:
					
					speed.x = lerp(speed.x,0,0.15)
					play_animation("idle")
			
			elif Input.is_action_pressed("a")  && activate_guitar_slash == 0 && on_wall == 0 && activate_special_attack == 0:
				
				if Input.is_action_pressed("d") == false:
					
					speed.x = max(speed.x-ACCELERATION,-MAXIMUM_SPEED)
					reflect_collision_shape_and_hitbox("left")
					play_animation("run")
					
				else:
					
					speed.x = lerp(speed.x,0,0.15)
					play_animation("idle")
				
			elif Input.is_action_pressed("d") == false && Input.is_action_pressed("a") == false && activate_guitar_slash == 0 && on_wall == 0 && activate_special_attack == 0:
				
				friction = true
				play_animation("idle")
				
		if $Timer_Invicibility.is_stopped() == false && $Timer_Invicibility.get_time_left() >= 0.15:
			
			$AnimatedSprite.hide()
			if $Timer_Blinking_Sprite.is_stopped() == true:
				
				$Timer_Blinking_Sprite.set_wait_time(0.05)
				$Timer_Blinking_Sprite.start()
				
		if is_on_floor():
			gravity = 15
			
			if on_jump == 1:
				on_jump = 0
			
			if $Timer_Bounce_Attack.is_stopped() == false:
				$Timer_Bounce_Attack.stop()
			$Hitbox_Bounce/CollisionShape2D.set_deferred("disabled", true)
			
			if hit_air == 1:
				
				hit = 0
				hit_air = 0
			
			if on_wall == 1:
				
				speed.x = 50 * -get_direction()
				on_wall = 0
			
			if activate_special_attack == 1:
				
				if $AnimatedSprite.get_frame() == 6 && special_shoots_fired == 0 :
					$Sounds/Special.play(0.0)
					special_shoots_fired = 1
					
					special_attack2.direction = -1
					special_attack2.get_node("AnimatedSprite").set_flip_h(true) 
					
					special_attack1.global_position = $Special_Attack_Position1.global_position
					special_attack2.global_position = $Special_Attack_Position2.global_position
					get_parent().add_child(special_attack1)
					get_parent().add_child(special_attack2)
					
					points -= 2
					get_parent().get_node("HUD/Points_Counter").set_text(String(points))
					
				if $AnimatedSprite.get_frame() == 8:
					
					play_animation("idle")
					activate_special_attack = 0
					special_shoots_fired = 0
					
			if Input.is_action_just_pressed("espacio"):
				
				speed.y = JUMP_POWER
				$Sounds/Jump.play(0.0)
				on_jump = 1
				
			elif Input.is_action_just_pressed("shift") && activate_rebound_counter == 0:
				
				if activate_guitar_slash == 0:
					
					activate_guitar_slash = 1
						
				if $Timer_Begin_Attack.is_stopped() == true:
				
					$Timer_Begin_Attack.set_wait_time(0.28)
					$Timer_Begin_Attack.start()
					
				speed.x = 0
				play_animation("attack")
					
			elif Input.is_action_pressed("shift") && rebounds_counter < 2 && activate_rebound_counter == 1:
				
				get_parent().get_node("HUD/Bounce_Bar").value -= 50
				get_parent().get_node("HUD/Bounce_Bar/AnimationPlayer").play("Middle")
				rebounds_counter += 1
					
				$Timer_Bounce_Reload.set_wait_time(2)
				$Timer_Bounce_Reload.start()
					
				
				if rebounds_counter == 2:
					
					get_parent().get_node("HUD/Bounce_Bar/AnimationPlayer").play("Empty")
					
					$Timer_Bounce_Reload.set_wait_time(3)
					$Timer_Bounce_Reload.start()

				speed.y = JUMP_POWER - (75 * (rebounds_counter + 1))
				activate_rebound_counter = 0
				$Sounds/Bounce.play(0.0)
				
			elif Input.is_action_pressed("control") && points >= 2:
				
				speed.x = lerp(speed.x,0,0.5)
				activate_special_attack = 1
				play_animation("special_attack")
				
				special_attack1 = SPECIAL_ATTACK.instance()
				special_attack2 = SPECIAL_ATTACK.instance()
				
			else:
				
				activate_rebound_counter = 0
				
			if ($AnimatedSprite.get_animation() == "attack" && $AnimatedSprite.get_frame() == 10) && activate_rebound_counter == 0:
				
				activate_guitar_slash = 0	
					
			if friction == true:
				
				speed.x = lerp(speed.x,0,0.2)
				
		else:
			
			$Timer_Begin_Attack.stop()
			$Hitbox_Guitar_Slash/CollisionShape2D.set_deferred("disabled", true)
				
			if activate_guitar_slash == 1:
				
				activate_guitar_slash = 0
				
			if activate_special_attack == 1:
				
				activate_special_attack = 0	
				
			if hit == 1:
				
				hit_air = 1
				
				if Input.is_action_pressed("a"):
					
					reflect_collision_shape_and_hitbox("left")
					
				elif Input.is_action_pressed("d"):
					
					reflect_collision_shape_and_hitbox("right")
					
			if $RayCast2D.is_colliding() && $RayCast2D2.is_colliding() && Input.is_action_pressed("shift") == false && hit == 0:
				
				if on_wall == 0:
					play_animation("wall_jump")
					speed.y = 0
					gravity = 2
					on_wall = 1
					
				
				if Input.is_action_pressed("a") && get_direction() == 1:
					if Input.is_action_pressed("espacio") && Input.is_action_pressed("d") == false:
						speed.x = -150
						speed.y = JUMP_POWER
						
				elif Input.is_action_pressed("d") && get_direction() == -1:
					if Input.is_action_pressed("espacio") && Input.is_action_pressed("a") == false:
						speed.x = 150
						speed.y = JUMP_POWER
					
			
			else:
				
				on_wall = 0
				gravity = 15
					
			if speed.y > 0 && on_wall == 0:
				
				if Input.is_action_pressed("shift") && hit == 0:
					
					play_animation("fall_attack")
					
					if $Timer_Bounce_Attack.is_stopped() == true:
					
						$Timer_Bounce_Attack.set_wait_time(0.09)
						$Timer_Bounce_Attack.start()
					
					if activate_rebound_counter == 0:
						
						activate_rebound_counter = 1
					
				else:
					
					if $Timer_Bounce_Attack.is_stopped() == false:
						
						$Timer_Bounce_Attack.stop()
										
					$Hitbox_Bounce/CollisionShape2D.set_deferred("disabled", true)	
					play_animation("fall")
					activate_rebound_counter = 0
									
				if friction == true:
					
					speed.x = lerp(speed.x,0,0.1)
					
			elif speed.y <= 0 && on_wall == 0:
				
				play_animation("jump")
				
				if Input.is_action_just_released("espacio") && on_jump == 1:
					on_jump = 0
					speed.y = lerp(speed.y,0,0.35)
						
	speed = move_and_slide(speed,Vector2(0,-1))

""" Funcion para las animaciones """	
func play_animation(animation):
	
	if Input.is_action_pressed("d") && Input.is_action_pressed("a") == false && on_wall == 0:
		
		$AnimatedSprite.flip_h = false
		
	elif Input.is_action_pressed("a") && Input.is_action_pressed("d") == false && on_wall == 0: 
		
		$AnimatedSprite.flip_h = true
		
	if animation == "death":
		
		$AnimatedSprite.play("death")
	
	if is_on_floor():
		
		if animation == "run":
			
			$AnimatedSprite.play("run")	
		
		elif animation == "idle":
			
			$AnimatedSprite.play("idle")
		
		elif animation == "attack":
			
			$AnimatedSprite.play("attack")
		
		elif animation == "special_attack":
			
			$AnimatedSprite.play("special_attack")		
	else:
		
		if animation == "jump":
			
			$AnimatedSprite.play("p1_jump")
			
		elif animation == "fall":
			
			$AnimatedSprite.play("fall")
			
		elif animation == "fall_attack":
			
			$AnimatedSprite.play("fall_attack")
		
		elif animation == "wall_jump":
			
			$AnimatedSprite.play("wall_jump")


"""Funcion para cambiar el collision shape de direccion"""
func reflect_collision_shape_and_hitbox(direction):
	
	if direction == "right" && $CollisionShape2D.position.x < 0:
		
		$CollisionShape2D.position.x *= -1
		$Hitbox_Pj/CollisionShape2D.position.x *= -1
		$Hitbox_Guitar_Slash/CollisionShape2D.position.x *= -1
		$Hitbox_Bounce/CollisionShape2D.position.x *= -1
		$RayCast2D.position.x *= -1
		$RayCast2D.rotate(deg2rad(180))
		$RayCast2D2.position.x *= -1
		$RayCast2D2.rotate(deg2rad(180))
		
	elif direction == "left" && $CollisionShape2D.position.x > 0:
		
		$CollisionShape2D.position.x *= -1
		$Hitbox_Pj/CollisionShape2D.position.x *= -1
		$Hitbox_Guitar_Slash/CollisionShape2D.position.x *= -1
		$Hitbox_Bounce/CollisionShape2D.position.x *= -1
		$RayCast2D.position.x *= -1
		$RayCast2D.rotate(deg2rad(180))
		$RayCast2D2.position.x *= -1
		$RayCast2D2.rotate(deg2rad(180))
		
	else:
		
		pass

	
"""Funcion para saber hacia donde apunta el personaje; Devuelve -1 si es hacia la izquierda y 1 si es hacia la derecha"""		
func get_direction():
	
	if 	$CollisionShape2D.position.x < 0:
			
		return -1
			
	else:
			
		return 1


"""Funcion para cambiar la health del personaje"""
func set_health(new_health):
	
	if new_health < 0:
		health = 0
	elif new_health > 100:
		health = 100
	else:	
		health = new_health
	
	get_parent().get_node("HUD/Health_Bar").value = health
	
	if health == 0:
		
		PlayerVariables.points = points
		$Hitbox_Pj/CollisionShape2D.set_deferred("disabled", true)
		$Hitbox_Guitar_Slash/CollisionShape2D.set_deferred("disabled", true)
		$Camera2D.current = false
		speed.x = lerp(speed.x,0,0.6)
		play_animation("death")
		
		if $Timer_Death.is_stopped() == true:
			
			$Timer_Death.set_wait_time(5)
			$Timer_Death.start()


"""Funcion saber que el personaje fue golpeado por algo"""
func set_hit():
	hit = 1
	
	if activate_special_attack == 1:
		
		activate_special_attack = 0
	
	$Hitbox_Pj/CollisionShape2D.set_deferred("disabled", true)
	
	if $Timer_Invicibility.is_stopped() == true:
			
		$Timer_Invicibility.set_wait_time(2)
		$Timer_Invicibility.start()
	
	
"""Funcion saber que tipo de nodo golpeo al personaje y cuanto daño le hara"""
func enemy_hit(enemy,damage):
	
	if enemy.get_class() == "KinematicBody2D":

		if enemy.get_name() == "Counter_Proyectile":
				
			if enemy.global_position.x > global_position.x:
				
				speed.x = -100
				
			else:
				
				speed.x = 100
					
			speed.y = -200
			enemy.queue_free()
			
		else:
			if enemy.get_death() == 0:
				if enemy.global_position.x > global_position.x:
					
					speed.x = -165
					
				else:
					
					speed.x = 165
				
				speed.y = -300 
		
		
	elif enemy.get_class() == "Area2D":
		
		if enemy.global_position.x > global_position.x:
			
			speed.x = -100
			
		else:
			
			speed.x = 100
			
		enemy.queue_free()	
		speed.y = -200
		
	set_health(health-damage)	
	set_hit()	

	
"""Funcion para que cuando el personaje salga de la pantalla se recargue la escena"""	
func _on_VisibilityNotifier2D_screen_exited():
	
	if health > 0:
		
		$Timer_Death.set_wait_time(1)
		$Timer_Death.start()
			
	
	

"""Funcion para detectar disparos,hechizos,etc (AREA) en el hitbox del personaje"""
func _on_Hitbox_Pj_area_entered(area):
		
	if area.get_name() == "Checkpoint1":
		
		PlayerVariables.checkpoint = 1
		PlayerVariables.position = area.global_position


"""Funcion para detectar si un enemigo entro en el hitbox de rebote del personaje"""	
func _on_Hitbox_Bounce_area_entered(area):
	
	if area.get_name() == "Hitbox_Enemy":
		
		activate_rebound_counter = 0
		speed.y = -400	
			
	elif area.get_name() =="Area2D_Counter_Proyectile":
		
		activate_rebound_counter = 0
		speed.y = -500
		
"""------------------------------------------------- *TIMERS* -----------------------------------------------------"""			


"""Funcion para el timer de recarga del shift"""
func _on_Timer_Bounce_Reload_timeout():
	
	rebounds_counter = 0
	get_parent().get_node("HUD/Bounce_Bar").value = 100
	$Timer_Bounce_Reload.stop()
	

"""Funcion para el timer de recarga de la muerte de personaje"""
func _on_Timer_Death_timeout():
	
	$Timer_Death.stop()
	
	if PlayerVariables.lifes > 1:
	
		PlayerVariables.lifes -= 1
		set_health(100)
		get_parent().get_node("HUD/Health_Bar").value = health
		get_parent().get_node("HUD/Lifes_Counter").set_text(String(PlayerVariables.lifes))
		global_position = PlayerVariables.position
		$Hitbox_Pj/CollisionShape2D.set_deferred("disabled", false)
		$Hitbox_Guitar_Slash/CollisionShape2D.set_deferred("disabled", false)
		$Camera2D.current = true
		$AnimatedSprite.stop()
		
		if get_parent().get_name().find("World") != -1:
			
			for enemy in get_parent().get_node("Enemies").get_children():
				enemy.set_death(0)
				
		elif get_parent().get_name().find("Boss") != -1:
			
			pass
			
	else:
		
		PlayerVariables.lifes = 3
		PlayerVariables.points = 0
		get_tree().reload_current_scene()


"""Funcion para el timer de invencibilidad de la barra del personaje"""
func _on_Timer_Invicibility_timeout():
	
	$Timer_Invicibility.stop()
	if health > 0:
		$Hitbox_Pj/CollisionShape2D.set_deferred("disabled", false)


"""Funcion para el timer de inicio del slash attack del personaje"""	
func _on_Timer_Begin_Attack_timeout():

	$Hitbox_Guitar_Slash/CollisionShape2D.set_deferred("disabled", false)
	$Timer_Begin_Attack.stop()
	
	if $Timer_End_Attack.is_stopped() == true:
				
			$Timer_End_Attack.set_wait_time(0.1)
			$Timer_End_Attack.start()
	
	
"""Funcion para el timer de finalizacion del slash attack del personaje"""		
func _on_Timer_End_Attack_timeout():
	
	$Hitbox_Guitar_Slash/CollisionShape2D.set_deferred("disabled", true)
	$Timer_End_Attack.stop()
	
	
	
"""Funcion para el timer de parpadeo del sprite del personaje"""	
func _on_Timer_Blinking_Sprite_timeout():
	
	$AnimatedSprite.show()
	$Timer_Blinking_Sprite.stop()



"""Funcion para el timer de ataque del bounce del personaje"""	
func _on_Timer_Bounce_Attack_timeout():
	
	$Hitbox_Bounce/CollisionShape2D.set_deferred("disabled", false)
	$Timer_Bounce_Attack.stop()
	

	
