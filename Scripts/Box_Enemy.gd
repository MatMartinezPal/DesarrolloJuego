"""Script para las fisicas del enemigo"""

""" Usar 0 como apagado ó como "No", 1 como encendido ó como "Si" """

"""Constantes y variables globales"""	
extends "res://Scripts/Enemy.gd"

const FIREBALL = preload("res://Scenes/Enemies/Box/Box_Proyectile.tscn")

var fireball = null
var position_POSITION2D_left = 1
var position_POSITION2D_right = 0


"""Funcion para condiciones iniciales del enemigo cuando se instancia en la escena"""
func _ready():
	
	initial_position = global_position 


"""Funcion para las fisicas generales del enemigo"""
func _physics_process(delta):
	
	speed.y += GRAVITY
	
	if $AnimatedSprite.get_frame() == 22 && is_on_floor() == true:
		get_parent().get_parent().add_child(fireball)

	if speed.x < 0:
		
		speed.x += 2
		
	elif speed.x > 0:
		
		speed.x -= 2
		
		
	speed = move_and_slide(speed,Vector2(0,-1))

	
"""Funcion para detectar cuando un personaje entra en el hitbox de salto del enemigo"""
func _on_Hitbox_Jump_body_entered(body):
	
	if body.get_name() == "Pj" && $Timer_Death.is_stopped() == true && is_on_floor() && body.health > 0 && get_death() == 0:
		
		$AnimatedSprite.set_frame(0) 
		$AnimatedSprite.play("Jump")
		
		if body.global_position.x < global_position.x:
				
			speed.x = MAXIMUM_SPEED * -1 
			$AnimatedSprite.flip_h = false
				
		else:
				
			speed.x = MAXIMUM_SPEED * 1
			$AnimatedSprite.flip_h = true
				

		speed.y = -250
		disable_hitbox_salto()


"""Funcion para detectar cuando un personaje entra en el hitbox de disparo del enemigo"""
func _on_Hitbox_Shoot_body_entered(body):
	
	if body.get_name() == "Pj" && $Timer_Death.is_stopped() == true && is_on_floor() && body.health > 0 && get_death() == 0:
			
			fireball = FIREBALL.instance()
			
			if body.global_position.x < global_position.x:
				
				$AnimatedSprite.flip_h = false
				fireball.set_direction(-1)
				change_Position2D("left")
				
			else:
				
				$AnimatedSprite.flip_h = true
				fireball.set_direction(1)
				change_Position2D("right")
				
			fireball.global_position = $Position2D.global_position
			$AnimatedSprite.play("Shoot")
			disable_hitbox_disparo()
			
			
"""Funcion para mover de sitio el Position2D y que las balas esten correctamente posicionadas"""
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


"""Funcion para desactivar el hitbox de disparo"""
func disable_hitbox_disparo():
	
	$Hitbox_Shoot/CollisionPolygon2D.set_deferred("disabled",true)
	$Hitbox_Shoot/CollisionPolygon2D2.set_deferred("disabled",true)
	
	if $Timer_Shoot.is_stopped() == true:
			
			$Timer_Shoot.set_wait_time(3)
			$Timer_Shoot.start()


"""Funcion para desactivar el hitbox de salto"""
func disable_hitbox_salto():
	$Hitbox_Jump/CollisionShape2D.set_deferred("disabled",true)
	
	if $Timer_Jump.is_stopped() == true:
			
			$Timer_Jump.set_wait_time(2)
			$Timer_Jump.start()


"""Funcion para saber cuando el enemigo salio de pantalla estando muerto"""
func _on_VisibilityNotifier2D_screen_exited():
	
	if get_death() == 1:
		
		if $Timer_Death.is_stopped() == true:
		
			$Timer_Death.set_wait_time(10)
			$Timer_Death.start()
		
		
"""Funcion para saber cuando el enemigo entro en pantalla estando muerto"""		
func _on_VisibilityNotifier2D_screen_entered():
	 
	if get_death() == 1:
		
		$Timer_Death.stop()
		
		
"""Funcion para saber si el personaje entro en el area de daño del enemigo"""	
func _on_Damage_Area_area_entered(area):
	
	if area.get_name() == "Hitbox_Pj":
		
		set_pj_hit(area,30)


"""Funcion para saber si algun ataque del personaje entro en el hitbox del enemigo"""	
func _on_Hitbox_Enemy_area_entered(area):
	if area.get_name() == "Hitbox_Guitar_Slash" || area.get_name() == "Hitbox_Bounce" || area.get_name() =="Area2D_Counter_Proyectile" || area.get_name().find("Special_Sound") != -1:
		
		enemy_set_hit(area,100,50,100,100)


"""------------------------------------------------- *TIMERS* -----------------------------------------------------"""	


"""Funcion que se activa cuando el timer de disparar llega a 0"""
func _on_Timer_Shoot_timeout():
	
	$Hitbox_Shoot/CollisionPolygon2D.set_deferred("disabled",false)
	$Hitbox_Shoot/CollisionPolygon2D2.set_deferred("disabled",false)
	
	if $Timer_Death.is_stopped() == true && get_death() == 0:
		
		$AnimatedSprite.play("Idle")
		
	$Timer_Shoot.stop()


"""Funcion que se activa cuando el timer de disparar llega a 0"""
func _on_Timer_Jump_timeout():
	
	$Hitbox_Jump/CollisionShape2D.set_deferred("disabled",false)
	$Timer_Jump.stop()


"""Funcion que se activa cuando el timer de muerte llega a 0"""			
func _on_Timer_Death_timeout():
	
	set_death(0)
	
	
"""Funcion que se activa cuando el timer de animacion de muerte llega a 0"""		
func _on_Timer_Death_Animation_timeout():
	
	$Timer_Death_Animation.stop()
	$AnimatedSprite.set_visible(false)



func _on_Timer_Modulate_timeout():
	
	$Timer_Modulate.stop()
	$AnimatedSprite.set_modulate(Color("ffffff"))
	
