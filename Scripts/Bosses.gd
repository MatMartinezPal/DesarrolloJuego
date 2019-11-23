extends KinematicBody2D

const GRAVITY = 15

var speed = Vector2()
var direction = -1
var health
var death

func _ready():
	death = 0
	pass

func get_death():
	return self.death

func set_health(health):
	self.health = self.health
	
"""Funcion para enviarle al personaje un hit de cierta cantidad de daño"""
func set_pj_hit(hitbox_pj,dmg):
	
	if hitbox_pj.get_parent().health > 0:
		
		hitbox_pj.get_parent().enemy_hit(self,dmg)