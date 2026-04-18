extends Control

@onready var lab_tipo = $container/top/nombre
@onready var lab_estado = $container/top/estado
@onready var lab_accion = $container/sub/accion
@onready var lab_cantidad = $container/sub/cantidad
@onready var lab_estado_recoleccion = $container/sub/estado_recoleccion

var hormiga 

func _ready():
	if hormiga != null:
		actualizar()

func set_hormiga(h):
	hormiga = h
	call_deferred("actualizar")

func actualizar():
	if hormiga == null:
		return
	lab_tipo.text = str(hormiga.tipo)
	lab_estado.text = hormiga.Estado.keys()[hormiga.estado]
	lab_accion.text = hormiga.Accion.keys()[hormiga.accion]
	
	
	if hormiga.accion == hormiga.Accion.RECOLECTANDO:
		lab_estado_recoleccion.text = hormiga.FaseRecoleccion.keys()[hormiga.fase_recoleccion]
		lab_cantidad.text = str(hormiga.carga)
	else:
		lab_estado_recoleccion.text = ""
		lab_cantidad.text = ""
