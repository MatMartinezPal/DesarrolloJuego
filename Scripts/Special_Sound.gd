extends Area2D

const MAXIMUM_SPEED = 200

var speed = Vector2()
var actual_frame = 0
var direction = 1

func _ready():
	if direction == -1:
		$CollisionShape2D.position *= -1
		

func _physics_process(delta):
	
	$AnimatedSprite.play("special_sound")
	
	if direction == 1:
		
		if $AnimatedSprite.get_frame() == 1 && actual_frame != 1:
			actual_frame = 1
			$CollisionShape2D.translate(Vector2(20,0))
			$CollisionShape2D.get_shape().set_extents(Vector2(40.176102,88.33255))
		elif $AnimatedSprite.get_frame() == 2 && actual_frame != 2:
			actual_frame = 2
			$CollisionShape2D.translate(Vector2(20.5,0))
			$CollisionShape2D.get_shape().set_extents(Vector2(59.500229,88.33255))		
		elif $AnimatedSprite.get_frame() == 5 && actual_frame != 5:
			actual_frame = 5
			$CollisionShape2D.translate(Vector2(20,0))
			$CollisionShape2D.get_shape().set_extents(Vector2(40.000229,88.33255))	
		elif $AnimatedSprite.get_frame() == 6 && actual_frame != 6:
			actual_frame = 6
			$CollisionShape2D.translate(Vector2(20,0))
			$CollisionShape2D.get_shape().set_extents(Vector2(19.603012,40.416962))	
		elif $AnimatedSprite.get_frame() == 7 && actual_frame != 7:
			actual_frame = 7
			$CollisionShape2D.set_deferred("disabled", true)
	else:
		
		if $AnimatedSprite.get_frame() == 1 && actual_frame != 1:
			actual_frame = 1
			$CollisionShape2D.translate(Vector2(-20,0))
			$CollisionShape2D.get_shape().set_extents(Vector2(40.176102,88.33255))
		elif $AnimatedSprite.get_frame() == 2 && actual_frame != 2:
			actual_frame = 2
			$CollisionShape2D.translate(Vector2(-20.5,0))
			$CollisionShape2D.get_shape().set_extents(Vector2(59.500229,88.33255))		
		elif $AnimatedSprite.get_frame() == 5 && actual_frame != 5:
			actual_frame = 5
			$CollisionShape2D.translate(Vector2(-20,0))
			$CollisionShape2D.get_shape().set_extents(Vector2(40.000229,88.33255))	
		elif $AnimatedSprite.get_frame() == 6 && actual_frame != 6:
			actual_frame = 6
			$CollisionShape2D.translate(Vector2(-20,0))
			$CollisionShape2D.get_shape().set_extents(Vector2(19.603012,40.416962))	
		elif $AnimatedSprite.get_frame() == 7 && actual_frame != 7:
			actual_frame = 7
			$CollisionShape2D.set_deferred("disabled", true)
		
	speed.x = MAXIMUM_SPEED * delta * direction 
	translate(speed)
	

func _on_VisibilityNotifier2D_screen_exited():
	
	queue_free()
