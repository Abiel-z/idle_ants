extends VBoxContainer

@export var boton_scene : PackedScene

var button_group := ButtonGroup.new()

func _ready():
	crear_botones_base()

func crear_botones_base():
	crear_boton_toggle("Poner Huevo", "producir_huevo")
	crear_boton_toggle("Explorar", "explorar")
	crear_boton_toggle("Buscar Comida", "recolectar")
	# El de crear punto puede ser automático o manual

func crear_boton_toggle(texto: String, accion: String):
	var boton = boton_scene.instantiate()
	boton.text = texto
	boton.toggle_mode = true
	boton.button_group = button_group
	boton.toggled.connect(_on_boton_toggled.bind(accion))
	add_child(boton)

func _on_boton_toggled(pressed: bool, accion: String):
	if pressed:
		ControllerReina.establecer_accion_activa(accion)
	else:
		if ControllerReina.accion_activa == accion:
			ControllerReina.establecer_accion_activa("")
