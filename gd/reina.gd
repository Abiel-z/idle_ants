class_name Reina

var controller

var huevos_en_produccion := 0
var tiempo_produccion : float = 0
var intervalo := 5

var produccion_activa := false

func update(delta):
	if not produccion_activa:
		return
	tiempo_produccion += delta
	if tiempo_produccion >= intervalo:
		tiempo_produccion -= intervalo
		generar_larva()

func generar_larva():
	controller.sumar_hormiga()
		
