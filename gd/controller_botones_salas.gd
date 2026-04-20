extends VBoxContainer

signal construccion_iniciada(sala: SalaData)

@export var boton_scene : PackedScene

var salas_disponibles : Array[SalaData] = []
var botones := {}

func _ready():
	ControllerExcavacion.connect("sala_desbloqueada", _check_desbloqueos)
	salas_disponibles = ControllerExcavacion.salas_disponibles
	for sala in salas_disponibles:
		sala.connect("datos_cambiados" , _check_desbloqueos)

func crear_boton(sala: SalaData, callback: Callable, contenedor: Node):
	if sala.id in botones:
		return
	
	var boton = boton_scene.instantiate()
	boton.data = sala
	contenedor.add_child(boton)
	boton.pressed.connect(callback)
	botones[sala.id] = boton
	
func _check_desbloqueos():
	print("SALAS DISPONIBLES")
	print(salas_disponibles)
	for sala in salas_disponibles:
		if sala.estado != SalaData.Estado.BLOQUEADA:
			continue
		if ControllerExcavacion.profundidad >= sala.profundidad_desbloqueo:
			sala.estado = SalaData.Estado.DESBLOQUEADA
			desbloquear_sala(sala)

func desbloquear_sala(sala: SalaData):
	emit_signal("sala_desbloqueada", sala)
	crear_boton(
		sala,
		func():comprar_sala(sala),
		self
	)

func comprar_sala(sala: SalaData):
	if sala.estado != SalaData.Estado.DESBLOQUEADA:
		return
	if ControllerHormiguero.comida_actual < sala.costo:
		emit_signal("construccion_invalida", sala.nombre)
		return
	
	ControllerHormiguero.tomar_comida(sala.costo)
	sala.estado = SalaData.Estado.EN_CONSTRUCCION
	emit_signal("construccion_iniciada", sala)
	print("CONSTRUCCION INICIADA ", sala.nombre)
	if sala.id in botones:
		botones[sala.id].queue_free()
		botones.erase(sala)
