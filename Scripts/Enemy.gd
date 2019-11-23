"""Script para aspectos generales de los enemigos. Estos heredaran este archivo"""

""" Usar 0 como apagado ó como "No", 1 como encendido ó como "Si" """

"""Constantes y variables globales"""	
extends KinematicBody2D

const GRAVITY = 15
const MAXIMUM_SPEED = 150 


var speed = Vector2()
var health = 100
var death = 0
var initial_position = Vector2(0,0)
var enemy_sounds
var hit_sound


"""Funcion que se ejecuta cuando entra en escena un enemigo"""
func _ready():
	
	enemy_sounds = AudioStreamPlayer.new()
	add_child(enemy_sounds)
	hit_sound = load("res://Sounds/Enemy_Sounds/Powerup6 (1).wav")
		

"""Funcion setter de la variable death"""	
func set_death(death,death_ani_time=0.0):
	
	self.death = death
	
	if self.death == 1:
		
		$AnimatedSprite.play("Death")
		$Hitbox_Enemy/CollisionShape2D.set_deferred("disabled", true)
		
		set_collision_layer_bit(2,true)
		set_collision_mask_bit(2,true)
		
		set_collision_layer_bit(0,false)
		set_collision_mask_bit(0,false)
		
		if $Timer_Death_Animation.is_stopped() == true:
		
			$Timer_Death_Animation.set_wait_time(death_ani_time)
			$Timer_Death_Animation.start()
			
	else:
		
		self.health = 100
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.set_visible(true)
		$AnimatedSprite.play("Idle")
		$Hitbox_Enemy/CollisionShape2D.set_deferred("disabled", false) 
	
		set_collision_layer_bit(0,true)
		set_collision_mask_bit(0,true)
		
		set_collision_layer_bit(2,false)
		set_collision_mask_bit(2,false)
		
		$Timer_Death.stop()
		
		global_position = initial_position
		

"""Funcion getter de la variable death"""
func get_death():
	
	return self.death


"""Funcion para darle el hit al personaje"""
func enemy_set_hit(area,GS,BOUNCE,SPECIAL,BALL,JUMP=1):
	
	enemy_sounds.set_stream(hit_sound)
	enemy_sounds.play(0.0)
	
	var direction_after_hit = 0
	
	if area.get_name() == "Hitbox_Guitar_Slash" || area.get_name() =="Area2D_Counter_Proyectile":

		if area.global_position.x < global_position.x:
			direction_after_hit = 1
		else:
			direction_after_hit = -1
			
		if area.get_name() == 	"Hitbox_Guitar_Slash":	
		
			set_health(get_health() - GS)
		else:
			
			set_health(get_health() - BALL)
			
	elif area.get_name() == "Hitbox_Bounce":
		
		set_health(get_health() - BOUNCE)
		
	else:
		
		set_health(get_health() - SPECIAL)
	
	if direction_after_hit != 0:
		
		speed.x = 100 * direction_after_hit
		if JUMP == 1:
			speed.y = -200
		

"""Funcion setter de la variable health y para la direccion on hit (Esta funcion solo se activara cuando el pj golpee al enemigo"""
func set_health(health):
	
	self.health = health
		
	if get_health() <= 0:
		
		set_death(1,1.7)
		
	else:
		
		$AnimatedSprite.set_modulate(Color("ff6b6b"))
		$Timer_Modulate.set_wait_time(0.3)
		$Timer_Modulate.start()


"""Funcion getter de la variable health"""
func get_health():
	
	return self.health

	
"""Funcion para enviarle al personaje un hit de cierta cantidad de daño"""
func set_pj_hit(hitbox_pj,dmg):
	
	if hitbox_pj.get_parent().health > 0 && get_death() == 0:
		
		hitbox_pj.get_parent().enemy_hit(self,dmg)