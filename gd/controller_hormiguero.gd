extends Node

signal entrega_alimento(cantidad: int)
signal error_entrega(causa: String)
signal hormiga_creada(hormiga)
signal hormiga_muerta(hormiga)

var reina : Reina

#------
var tiempo_acumulado := 0.0
var intervalo := 1.0
#------

var hormigas : Array[Hormiga] = []
var hormigas_muertas := 0

var cantidad_hormigas : int = 0
var comida_actual : float = 0.0
var capacidad_comida_total := 10000
var consumo_por_segundo : float = 0.0
var consumo_por_hormiga : float = 1.0
var produccion_por_hormiga : float = 2.0
var produccion_por_segundo : float = 0.0

func _ready():
	reina = Reina.new()
	reina.controller = self
	reina.produccion_activa = true

func _process(delta):
	reina.update(delta)
	for hormiga in hormigas:
		hormiga.update(delta)
	limpiar_hormigas_muertas()

func entregar_comida(cantidad: int):
	if comida_actual >= capacidad_comida_total:
		emit_signal("error_entrega", "No hay mas espacio para alimentos")
		return
	comida_actual += cantidad
	entrega_alimento.emit(cantidad)
	#emit_signal("entrega alimento", cantidad )

func sumar_hormiga():
	var nueva = Hormiga.new()
	emit_signal("hormiga_creada",nueva)
	hormigas.append(nueva)

func get_cantidad_hormigas() -> int:
	return hormigas.size()

func get_cantidad_hormigas_por_tipo(tipo: Hormiga.Tipo) -> int:
	var contador := 0
	for h in hormigas:
		if h.tipo == tipo:
			contador += 1
	return contador 

func get_cantidad_hormigas_por_estado(estado: Hormiga.Estado) -> int:
	var contador := 0
	for h in hormigas:
		if h.estado == estado:
			contador += 1
	return contador
	
func limpiar_hormigas_muertas():
	for i in range(hormigas.size() - 1, -1 , -1):
		if hormigas[i].muerta:
			emit_signal("hormiga_muerta", hormigas[i])
			hormigas.remove_at(i)
			hormigas_muertas += 1

func get_cantidad_comida() -> int:
	return comida_actual

func tomar_comida(cantidad: float) -> bool:
	if comida_actual > cantidad:
		comida_actual -= cantidad
		return true
	else:
		return false

func consumo_total_por_tick() -> float:
	var total := 0.0
	for hormiga in hormigas:
		total += hormiga.get_consumo()
	return total
