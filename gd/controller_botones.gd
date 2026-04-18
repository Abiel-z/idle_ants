extends VBoxContainer

@export var boton_scene : PackedScene
# -- DEBEN CREARSE BOTONES DEPENDIENDO DE LAS OPCIONES DISPONIBLES    --
# -- ESTAS OPCIONES DEBEN LLEGAR DESDE UN <Autoload : MejorasManager> --
# -- POR AHORA func crear_botones_base() VA A CUMPLIR SU FUNCION      --

func _ready():
	crear_botones_base()

func crear_botones_base():
	crear_boton(
		"Buscar Comida",
		_on_boton_buscar_comida_pressed,
		self
	)
	crear_boton(
		"Poner Huevo",
		_on_boton_poner_huevo_pressed,
		self
	)
	crear_boton(
		"Explorar la zona",
		_on_boton_crear_punto_pressed,
		self
	)
	crear_boton(
		"Explorar",
		_on_boton_explorar_pressed,
		self
	)

func crear_boton(texto: String, callback: Callable, contenedor: Node):
	var boton = boton_scene.instantiate()
	boton.text = texto
	boton.pressed.connect(callback)
	contenedor.add_child(boton)

func _on_boton_explorar_pressed():
	ControllerExcavacion.profundidad += 1

func _on_boton_crear_punto_pressed():
	ControllerForrajeo.generar_punto()

func _on_boton_buscar_comida_pressed():
	ControllerHormiguero.comida_actual += 1

func _on_boton_poner_huevo_pressed():
	ControllerHormiguero.sumar_hormiga()
	pass # Replace with function body.
