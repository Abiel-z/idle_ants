extends VBoxContainer

@export var escena_hormiga : PackedScene
var items := {}

func _ready():
	ControllerHormiguero.hormiga_creada.connect(agregar_hormiga)
	ControllerHormiguero.hormiga_muerta.connect(eliminar_hormiga)

func agregar_hormiga(hormiga):
	if hormiga in items:
		return
	
	var item = escena_hormiga.instantiate()
	item.set_hormiga(hormiga)
	
	add_child(item)
	items[hormiga] = item

func eliminar_hormiga(hormiga):
	if not items.has(hormiga):
		return
	items[hormiga].queue_free()
	items.erase(hormiga)

func _process(delta):
	for item in items.values():
		item.actualizar()
