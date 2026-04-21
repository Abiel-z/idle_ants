extends Node

signal tick()
signal dia_pasado(dia)
signal mes_pasado(mes)
signal año_pasado(año)
signal estacion_cambiada(estacion)

enum Estacion { PRIMAVERA, VERANO, OTOÑO, INVIERNO }

const TICKS_POR_DIA = 10
const DIAS_POR_MES = 30
const MESES_POR_AÑO = 4

var velocidad_tiempo := 1.0

var _acumulador_tick := 0.0
var _acumulador_dia := 0.0

var tick_count := 0
var dia_actual := 1
var mes_actual := 1
var año_actual := 1
var estacion_actual := Estacion.VERANO  # Empiezas en verano como dijiste

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta):
	_acumulador_tick += delta
	if _acumulador_tick >= 1.0:
		_acumulador_tick -= 1.0
		tick_count += 1
		tick.emit()
	
	_acumulador_dia += delta * velocidad_tiempo
	if _acumulador_dia >= float(TICKS_POR_DIA):
		_acumulador_dia -= float(TICKS_POR_DIA)
		_avanzar_dia()

func _avanzar_dia():
	dia_actual += 1
	
	# Ver si pasa un mes
	if dia_actual > DIAS_POR_MES:
		dia_actual = 1
		_avanzar_mes()
	
	dia_pasado.emit(dia_actual)

func _avanzar_mes():
	mes_actual += 1
	
	# Ver si pasa un año
	if mes_actual > MESES_POR_AÑO:
		mes_actual = 1
		_avanzar_año()
	else:
		_cambiar_estacion_segun_mes()
	
	mes_pasado.emit(mes_actual)

func _avanzar_año():
	año_actual += 1
	año_pasado.emit(año_actual)
	# Al cambiar el año, también cambia la estación según el mes
	_cambiar_estacion_segun_mes()

func _cambiar_estacion_segun_mes():
	var nueva_estacion
	match mes_actual:
		1:
			nueva_estacion = Estacion.PRIMAVERA
		2:
			nueva_estacion = Estacion.VERANO
		3:
			nueva_estacion = Estacion.OTOÑO
		4:
			nueva_estacion = Estacion.INVIERNO
	
	if nueva_estacion != estacion_actual:
		estacion_actual = nueva_estacion
		estacion_cambiada.emit(estacion_actual)

func set_velocidad(velocidad: float):
	velocidad_tiempo = clamp(velocidad, 0.1, 10.0)

func get_estacion_nombre() -> String:
	match estacion_actual:
		Estacion.PRIMAVERA:
			return "Primavera"
		Estacion.VERANO:
			return "Verano"
		Estacion.OTOÑO:
			return "Otoño"
		Estacion.INVIERNO:
			return "Invierno"
	return "Error"
