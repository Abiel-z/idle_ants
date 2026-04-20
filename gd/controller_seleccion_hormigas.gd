extends ScrollContainer

signal seleccion_cambiada(hormigas)

var hormigas_seleccionadas := []

@onready var layout = $layout_lista_hormigas
@onready var ui_sliders = get_node("/root/BASE/escena_principal/HUD_1/ui_sliders")


var ignorar_actualizacion := false

func _ready():
	ui_sliders.connect("prioridades_cambiadas", _on_prioridades_cambiadas)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_prioridades_cambiadas(valores):
	print("PRIORIDADES CAMBIADAS")
	ignorar_actualizacion = true
	for h in hormigas_seleccionadas:
		h.prioridad_recolectar = valores["recolectar"]
		h.prioridad_explorar = valores["explorar"]
		h.prioridad_construir = valores["construir"]
		layout.items[h].actualizar_barra()
	ignorar_actualizacion = false

func toggle_hormiga(hormiga):
	print("func toggle_homiga ejecutandose")
	if hormiga in hormigas_seleccionadas:
		hormigas_seleccionadas.erase(hormiga)
	else :
		hormigas_seleccionadas.append(hormiga)
	emit_signal("seleccion_cambiada", hormigas_seleccionadas)
	actualizar_visual()
	actualizar_sliders_desde_seleccion()

func actualizar_visual():
	for h in layout.items.keys():
		var item = layout.items[h]
		item.set_seleccionada(h in hormigas_seleccionadas)
		
func actualizar_sliders_desde_seleccion():
	print("func actualizar_sliders_desde_seleccion ejecutandose")
	if ignorar_actualizacion:
		return
	if hormigas_seleccionadas.is_empty():
		return
	var promedio = {
		"recolectar" : 0.0,
		"explorar": 0.0,
		"construir": 0.0
	}
	for h in hormigas_seleccionadas:
		promedio["recolectar"] += h.prioridad_recolectar
		promedio["explorar"] += h.prioridad_explorar
		promedio["construir"] += h.prioridad_construir
	var n = hormigas_seleccionadas.size()
	for k in promedio:
		promedio[k] /= n
	ui_sliders.set_valores(promedio)
