extends Resource
class_name SalaData

signal datos_cambiados

@export var id : int
@export var nombre : String
@export var producto_desbloqueo : String

enum Estado {
	BLOQUEADA,
	DESBLOQUEADA,
	EN_CONSTRUCCION,
	CONSTRUIDA
}
@export var estado := Estado.BLOQUEADA
@export var profundidad_desbloqueo : int = 0
@export var costo : int = 100
@export var material_restante : float = 60
@export var descripcion : String

func aplicar_efecto():
	pass
	
func terminar_sala():
	if material_restante <= 0:
		estado = SalaData.Estado.CONSTRUIDA
		material_restante = 0

func avanzar(cantidad):
	material_restante -= cantidad
	emit_signal("datos_cambiados")
	print("PROGRESO SALA : " + str(material_restante))
