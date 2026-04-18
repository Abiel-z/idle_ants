extends Node

signal new_log(texto: String)
signal punto_creado(punto)
signal punto_eliminado(punto)

var puntos_alimento := []

func obtener_punto() -> puntoAlimento:
	if puntos_alimento.is_empty():
		return null
	return puntos_alimento[0]

func generar_punto_con_datos(cantidad: int, distancia: int):
	var punto = puntoAlimento.new()
	punto.cantidad = cantidad
	punto.distancia = distancia
	puntos_alimento.append(punto)
	emit_signal("punto_creado", punto)
	emit_signal("new_log", "Una hormiga ha encontrado alimento")

func generar_punto():
	var punto = puntoAlimento.new()
	punto.cantidad = randf_range(100,200)
	punto.distancia = randf_range(5,10)
	puntos_alimento.append(punto)
	print("PUNTO GENERADO " + str(punto.cantidad) + " " + str(punto.distancia))
	emit_signal("punto_creado", punto)

func consumir_punto(punto: puntoAlimento, cantidad: float) -> int:
	if punto == null:
		return 0
	var recolectado = min(punto.cantidad, cantidad)
	punto.consumir(recolectado)
	if punto.cantidad <= 0:
		puntos_alimento.erase(punto)
		emit_signal("punto_eliminado", punto)
	return int(recolectado)
