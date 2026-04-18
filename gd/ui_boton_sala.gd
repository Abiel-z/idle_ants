class_name BotonSala
extends Button

@onready var lab_nombre = $general/vertical/horizontal_1/SALA
@onready var lab_material_restante = $general/vertical/horizontal_1/cant_material_restante
@onready var lab_producto = $general/vertical/horizontal_2/producto
@onready var lab_costo = $general/vertical/horizontal_2/costo

var data : SalaData
func _ready():
	if data:
		configurar(
			data.nombre,
			data.material_restante,
			data.producto_desbloqueo,
			data.costo
		)

func configurar(nombre:String,material_restante:float,producto:String,costo:float):
	print("ejecutando boton.configurar", nombre)
	lab_nombre.text = nombre
	lab_material_restante.text = "%.2f" % material_restante
	lab_producto.text = producto
	lab_costo.text = str(costo)

func actualizar(material_restante:float):
	lab_material_restante.text = "%.2f" % material_restante
