extends HBoxContainer

@onready var dia_label = $dia  # Ajusta las rutas según tus nodos
@onready var mes_label = $mes
@onready var año_label = $año
@onready var estacion_label = $estacion

var dia_actual : int = 1
var mes_actual : int = 1
var año_actual : int = 1
var estacion_actual := ""

func _ready():
	# Conectar las señales del TimeManager
	if not ManagerTime:
		print("ERROR: ManagerTime no encontrado")
		return
	
	ManagerTime.dia_pasado.connect(_on_dia_pasado)
	ManagerTime.mes_pasado.connect(_on_mes_pasado)
	ManagerTime.año_pasado.connect(_on_año_pasado)
	ManagerTime.estacion_cambiada.connect(_on_estacion_cambiada)
	
	# Inicializar UI con valores actuales
	_actualizar_ui()

func _on_dia_pasado(dia):
	dia_actual = dia
	_actualizar_ui()

func _on_mes_pasado(mes):
	mes_actual = mes
	_actualizar_ui()

func _on_año_pasado(año):
	año_actual = año
	_actualizar_ui()

func _on_estacion_cambiada(estacion):
	estacion_actual = estacion
	_actualizar_ui()

func _actualizar_ui():
	# Actualizar labels
	if dia_label:
		dia_label.text = "Día: " + str(dia_actual)
	if mes_label:
		mes_label.text = "Mes: " + str(mes_actual)
	if año_label:
		año_label.text = "Año: " + str(año_actual)
	if estacion_label:
		estacion_label.text = estacion_actual
