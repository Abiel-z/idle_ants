extends VBoxContainer


@export var escena_punto : PackedScene
var items := {}

var max_lineas := 10 
var puntos_a_mostrar = []

func _ready():
	ControllerForrajeo.punto_creado.connect(agregar_punto)
	ControllerForrajeo.punto_eliminado.connect(eliminar_punto)

func _on_cantidad_cambiada(punto):
	actualizar()

func actualizar():
	for punto in items.keys():
		items[punto].actualizar()

func agregar_punto(punto):
	if punto in items:
		return
	var item = escena_punto.instantiate()
	item.set_punto(punto)
	
	add_child(item)
	items[punto] = item

func eliminar_punto(punto):
	if not items.has(punto):
		return
	items[punto].queue_free()
	items.erase(punto)
