extends "res://Scripts/Bosses.gd"

const MAXIMUM_SPEED = 190
const ACCELERATION = 15

var estado_actual = 1


func _ready():
	pass


func _physics_process(delta):
	speed.y += GRAVITY
	
	if estado_actual == 1:
		
	
	speed = move_and_slide(speed, Vector2(0, -1))
	
	
	
	
func estado_1():
	