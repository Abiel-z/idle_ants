extends HBoxContainer

@onready var lbl_nombre : Label = $nombre
@onready var lbl_distancia : Label = $distancia
@onready var lbl_cantidad : Label = $cantidad

var punto : puntoAlimento

func _ready():
	if punto != null:
		actualizar()

func set_punto(p):
	punto = p
	if punto != null:
		punto.cantidad_cambiada.connect(_on_cantidad_cambiada)
	call_deferred("actualizar")

func _on_cantidad_cambiada():
	actualizar()

func actualizar():
	lbl_nombre.text = "Punto"
	lbl_distancia.text = "Dist: %d" % punto.distancia
	lbl_cantidad.text = "Cant: %d" % punto.cantidad
