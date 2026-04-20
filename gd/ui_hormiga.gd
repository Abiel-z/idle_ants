extends Button

@onready var lab_tipo = $container/top/nombre
@onready var lab_estado = $container/top/estado
@onready var lab_accion = $container/sub/textos/accion
@onready var lab_cantidad = $container/sub/textos/cantidad
@onready var lab_estado_recoleccion = $container/sub/textos/estado_recoleccion


@onready var lay_barra = $container/sub/lay_barra
@onready var lay_textos = $container/sub/textos

@onready var barra_recolectar = $container/sub/lay_barra/container_barra/barra_recolectar
@onready var barra_explorar = $container/sub/lay_barra/container_barra/barra_explorar
@onready var barra_construir = $container/sub/lay_barra/container_barra/barra_construir


var hormiga 

func _ready():
	if hormiga != null:
		actualizar()
	mostrar_textos()

func _pressed():
	get_parent().get_parent().toggle_hormiga(hormiga)

func actualizar_barra():
	if hormiga == null:
		return
	barra_recolectar.size_flags_stretch_ratio = hormiga.prioridad_recolectar
	barra_explorar.size_flags_stretch_ratio = hormiga.prioridad_explorar
	barra_construir.size_flags_stretch_ratio = hormiga.prioridad_construir

func set_hormiga(h):
	hormiga = h
	call_deferred("actualizar")

func mostrar_barra():
	print("mostrando_barra")
	lay_barra.visible = true
	lay_textos.visible = false

func mostrar_textos():
	print("mostrando_textos")
	lay_barra.visible = false
	lay_textos.visible = true


func set_seleccionada(valor: bool):
	if valor: 
		self_modulate = Color.WHITE
		mostrar_barra()
	else:
		self_modulate = Color.DIM_GRAY
		mostrar_textos()


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
	actualizar_barra()
