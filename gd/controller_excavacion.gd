extends Node

signal sala_desbloqueada

var profundidad : int = 0

var salas_disponibles : Array[SalaData] = []
var salas_en_construccion : Array[SalaData] = []
var salas_desbloqueadas : Array[SalaData] = []

func _ready():
	cargar_salas()

func _process(delta):
	for sala in salas_disponibles:
		if sala.estado == SalaData.Estado.BLOQUEADA and profundidad >= sala.profundidad_desbloqueo:
			emit_signal("sala_desbloqueada")
	get_salas_en_construccion()

func excavar(cantidad):
	profundidad += cantidad

func get_salas_en_construccion():
	salas_en_construccion.clear()
	for sala in salas_disponibles:
		if sala == null:
			continue
		
		if sala.estado == SalaData.Estado.EN_CONSTRUCCION:
			salas_en_construccion.append(sala)

func cargar_salas():
	var dir = DirAccess.open("res://tres/salas/data/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".tres"):
				var sala = load("res://tres/salas/data/" + file_name)
				salas_disponibles.append(sala)
			
			file_name = dir.get_next()
