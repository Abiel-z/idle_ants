extends VBoxContainer

@export var boton_scene : PackedScene
@onready var controller_botones_salas = get_node("/root/BASE/escena_principal/HUD_2/hud_botones/lay_controller_botones/controller_botones_salas")

var salas_disponibles : Array[SalaData]
var botones := {}

func _ready():
	print(" NODO CONTROLLER BOTONES : ", controller_botones_salas.name)
	controller_botones_salas.connect("construccion_iniciada", _on_construccion_iniciada)
	salas_disponibles = ControllerExcavacion.salas_disponibles

func _process(delta):
	for sala in salas_disponibles:
		if sala.estado == SalaData.Estado.EN_CONSTRUCCION:
			procesar_construccion(sala)

func _on_construccion_iniciada(sala: SalaData):
	print("SALA RECIBIDA : ", sala.nombre)
	mostrar_sala(sala)

func crear_boton(sala: SalaData, callback: Callable, contenedor: Node):
	if sala.id in botones:
		return
	
	var boton = boton_scene.instantiate()
	contenedor.add_child(boton)
	boton.set_data(sala)
	boton.pressed.connect(callback)
	
	botones[sala.id] = boton

func procesar_construccion(sala: SalaData):
	if sala.estado != SalaData.Estado.EN_CONSTRUCCION:
		return
	
	if sala.material_restante <= 0:
		completar_sala(sala)

func completar_sala(sala: SalaData):
	sala.estado = SalaData.Estado.CONSTRUIDA
	sala.emit_signal("datos_cambiados")

func on_sala_changed(sala: SalaData):
	if sala.estado == SalaData.Estado.EN_CONSTRUCCION:
		if sala.id not in botones:
			print("NO EXISTE BOTON")
		else:
			print("BOTON ENCONTRADO : ", botones[sala.id])
			botones[sala.id].actualizar()
	else:
		if sala.id in botones:
			print("ELIMINANDO BOTON")
			botones[sala.id].queue_free()
			botones.erase(sala.id)

func mostrar_sala(sala: SalaData):
	crear_boton(
		sala,
		func():avanzar_sala(sala),
		self
	)

func avanzar_sala(sala: SalaData):
	if sala.estado != SalaData.Estado.DESBLOQUEADA:
		return
	sala.estado = SalaData.Estado.EN_CONSTRUCCION
	sala.emit_signal("datos_cambiados")
	if sala.material_restante <= 0:
		completar_sala(sala)

func aplicar_efecto_salas():
	for sala in salas_disponibles:
		if sala.estado == SalaData.Estado.CONSTRUIDA:
			sala.aplicar_efecto()
