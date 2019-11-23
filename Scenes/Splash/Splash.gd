extends Control

export (PackedScene) var next_scene
var Next_Scene_Instance = null

#Cargar Hilo
onready var Loading_Thread = Thread.new()

func _ready():
	#Cargar datos del juego
	Loading_Thread.start(self, "load_data")
	
	
	#Mostrar logo
	Splash_Screen()
	
	
func Splash_Screen():
	print ("SISA PANA")
	
	#Crear una instancia (Crea una instancia y la guarda)
	Next_Scene_Instance = next_scene.instance()
	#Añadir Escena
	add_child(Next_Scene_Instance)
	
func load_data(vars):
	#Simular cargado
	for i in range(0,10):
		for j in range (0,7):
			pass
	print("¡Cargado!")
	Next_Scene_Instance.is_loading = false



