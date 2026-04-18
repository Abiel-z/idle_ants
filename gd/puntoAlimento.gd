class_name  puntoAlimento

signal  cantidad_cambiada

var cantidad : int
var distancia : int

func consumir(cantidad):
	self.cantidad -= cantidad
	emit_signal("cantidad_cambiada")

func get_cantidad() -> int:
	return cantidad
