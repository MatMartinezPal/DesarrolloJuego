extends KinematicBody2D

const MAXIMUM_SPEED = 250

var speed = Vector2()
var direction = 1
var on_screen


func _ready():
	
	speed.x = MAXIMUM_SPEED * direction
	
func set_direction(dir):
	
	direction = dir


func _physics_process(delta):
	 
	$AnimatedSprite.play("Proyectile")
	
	if is_on_wall():
		queue_free()
	
	if is_on_floor():
		
		speed.x += 40 * direction
		speed.y += -200 
		
	else:
		
		speed.y += 5
	
	speed = move_and_slide(speed,Vector2(0,-1))


func _on_VisibilityNotifier2D_screen_exited():
	
	queue_free()
	
	 

func _on_Area2D_area_entered(area):
	if area.get_name() == "Hitbox_Guitar_Slash":
		if area.global_position.x < global_position.x:
			set_direction(1)
		elif area.global_position.x > global_position.x:
			set_direction(-1)
		speed.x = (MAXIMUM_SPEED+50) * direction
		
	elif area.get_name() == "Hitbox_Pj":
		
		if area.get_parent().health > 0:
		
			area.get_parent().enemy_hit(self,10)
	
	elif area.get_name() == "Hitbox_Enemy":
		
		queue_free()
			
	

func _on_Area2D_Counter_Proyectile_body_entered(body):
	
	if body.get_name() == "Pj" && body.get_node("Timer_Invicibility").is_stopped() == false:
		
		queue_free()
	
