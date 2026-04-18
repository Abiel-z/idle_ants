class_name BotonAccion
extends Button

@onready var lab_nombre = $general/vertical/horizontal_1/nombre
@onready var lab_producto = $general/vertical/horizontal_2/producto
@onready var lab_costo = $general/vertical/horizontal_2/costo


var costo := 0
var accion_callback = null

func configurar(nombre:String,costo_valor:int,callback):
	lab_nombre.text = nombre
	lab_producto.text = "Costo: "
	lab_costo = str(costo_valor)
	costo = costo_valor
	accion_callback = callback

func _pressed():
	if ControllerHormiguero.tomar_comida(costo):
		if accion_callback:
			accion_callback.call()  

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
