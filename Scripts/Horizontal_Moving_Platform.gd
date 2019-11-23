extends KinematicBody2D

const MAXIMUM_SPEED = -180
var speed = Vector2()
var initial_position 
var acceleration = 5
var direction
var changing_direction_to_left = 0
var changing_direction_to_right = 0

func _ready():
	
	initial_position = global_position.x
	direction = 1
	speed.x = MAXIMUM_SPEED

func _physics_process(delta):
	
	
	if direction == 1:
		
		if changing_direction_to_left == 1:
			if speed.x >= -180:
				speed.x = speed.x - 5
			else:
				speed.x = -180
				changing_direction_to_left = 0
			
		if round(abs(initial_position-global_position.x)) >= 250 && round(abs(initial_position-global_position.x)) < 300 && changing_direction_to_left == 0:
			if abs(speed.x) > 50:
				speed.x = speed.x + 5
			
		elif round(abs(initial_position-global_position.x)) >= 300 && changing_direction_to_left == 0:
			
			direction *= -1
			changing_direction_to_right = 1
			
	elif direction == -1:
		
		if changing_direction_to_right == 1:
			if speed.x >= -180:
				speed.x = speed.x - 5
			else:
				speed.x = -180
				changing_direction_to_right = 0
				
		if round(abs(global_position.x-initial_position)) >= 250 && round(abs(global_position.x-initial_position)) < 300 && changing_direction_to_right == 0:
			if abs(speed.x) > 50:
				speed.x = speed.x + 5
			
		elif round(abs(global_position.x-initial_position)) >= 300 && changing_direction_to_right == 0:
			
			direction *= -1
			changing_direction_to_left = 1
			
	print(speed.x)
	translate(speed * delta * direction)
