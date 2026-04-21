class_name Reina
extends Node

var controller
var accion_activa := ""  # "producir_huevo", "explorar", "recolectar"
var progreso_actual := 0
var tiempo_requerido := 0

var acciones_config := {
	"producir_huevo": {"duracion": 10, "callback": "_generar_larva"},
	"explorar": {"duracion": 15, "callback": "_ejecutar_exploracion"},
	"recolectar": {"duracion": 5, "callback": "_ejecutar_recoleccion"}
}

func _ready():
	ManagerTime.tick.connect(_on_tick)

func establecer_accion_activa(accion: String):
	accion_activa = accion
	progreso_actual = 0
	
	if accion == "":
		print("Reina: Acción detenida")
	else:
		tiempo_requerido = acciones_config[accion]["duracion"]
		print("Reina: Iniciando ", accion, " - Duración: ", tiempo_requerido, " ticks")

func _on_tick():
	if accion_activa == "":
		return
	
	progreso_actual += 1
	
	if progreso_actual >= tiempo_requerido:
		progreso_actual = 0
		_ejecutar_accion_actual()

func _ejecutar_accion_actual():
	var config = acciones_config[accion_activa]
	var metodo = config["callback"]
	
	match metodo:
		"_generar_larva":
			_generar_larva()
		"_ejecutar_exploracion":
			_ejecutar_exploracion()
		"_ejecutar_recoleccion":
			_ejecutar_recoleccion()
	
	# Opcional: Repetir automáticamente (si quieres que siga activo)
	# progreso_actual = 0  # Ya está en 0, se reinicia el ciclo

func _generar_larva():
	print("Reina: ¡Larva generada!")
	controller.sumar_hormiga()

func _ejecutar_exploracion():
	print("Reina: Exploración completada - Nuevo punto descubierto")
	ControllerForrajeo.generar_punto()

func _ejecutar_recoleccion():
	print("Reina: Recolección completada - +1 comida")
	controller.comida_actual += 1

func get_progreso() -> float:
	if tiempo_requerido == 0:
		return 0.0
	return float(progreso_actual) / float(tiempo_requerido)
