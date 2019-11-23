extends Control

export (PackedScene) var next_scene

onready var Anim_Player = $Anim_Player

var is_loading = true

func _ready():
	#Skipear cinematica
	set_process_input(true)
	
	#Animación
	fade_in_out()
	
func fade_in_out():
	print("ke")
	Anim_Player.play("Fade_in_out")
	
	Anim_Player.connect("animation_finished",self,"goto_next_scene")
	
func goto_next_scene():
	#Si aún está cargando cuando la animación termine, tratamos de cargar la siguiente
	#Escena cada segundo
	if(is_loading):
		$Timer.set_wait_time(1)
		$Timer.set_one_shot(false)
		$Timer.connect("timeout",self, "next_scene")
		$Timer.start()
		
	else:
		next_scene()
	
		
func next_scene():
	if(!is_loading):
		print("Estamos Cargando el logo")
		
	#Ir a la proxima escena
		get_parent().add_child(next_scene.instance())
		queue_free()
		
