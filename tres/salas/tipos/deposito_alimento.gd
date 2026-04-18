extends SalaData

@export var capacidad_extra := 100
# Called when the node enters the scene tree for the first time.
func aplicar_efecto():
	ControllerHormiguero.capacidad_comida_total += capacidad_extra
