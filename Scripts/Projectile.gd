extends Area2D

var speed = Vector2()


"""Funcion para enviarle al personaje un hit de cierta cantidad de daño"""
func set_pj_hit(hitbox_pj,dmg):
	
	if hitbox_pj.get_parent().health > 0:
		
		hitbox_pj.get_parent().enemy_hit(self,dmg)
