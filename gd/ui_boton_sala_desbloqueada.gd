class_name BotonSalaDesbloqueada
extends Button

@onready var lab_nombre = $general/vertical/horizontal_1/sala
@onready var lab_estado = $general/vertical/horizontal_1/estado
@onready var lab_materia_restante = $general/vertical/horizontal_2/materia_restante
@onready var lab_cantidad = $general/vertical/horizontal_2/cantidad

var data : SalaData

func _ready():
	if data:
		set_data(data)

func configurar(nombre:String,estado:SalaData.Estado,cantidad:float):
	
	lab_nombre.text = nombre
	lab_estado.text = estado_a_texto(estado)
	lab_cantidad.text = str(cantidad)

func estado_a_texto(estado: SalaData.Estado) -> String:
	match estado:
		SalaData.Estado.BLOQUEADA:
			return "Bloqueada"
		SalaData.Estado.DESBLOQUEADA:
			return "Disponible"
		SalaData.Estado.EN_CONSTRUCCION:
			return "En construcción"
		SalaData.Estado.CONSTRUIDA:
			return "Construida"
		_:
			return "??"
#
func set_data(sala: SalaData):
	data = sala
	if data.is_connected("datos_cambiados", Callable(self, "_on_data_changed")):
		data.disconnect("datos_cambiados", Callable(self, "_on_data_changed"))
	data.connect("datos_cambiados", Callable(self, "_on_data_changed"))
	actualizar()

#func set_data(sala: SalaData):
	#data = sala
	#if data.is_connected("datos_cambiados", _on_data_changed):
		#data.disconnect("datos_cambiado", _on_data_changed)
	#data.connect("datos_cambiados", _on_data_changed)
	#actualizar()

func _on_data_changed():
	actualizar()

func actualizar():
	print("ACTUALIZANDO SALA EN CONSTRUCCION", data.id)
	if not data:
		return
	if data.estado == SalaData.Estado.EN_CONSTRUCCION :
		lab_nombre.text = data.nombre
		lab_estado.text = estado_a_texto(data.estado)
		
		lab_cantidad.visible = true
		lab_materia_restante.visible = true
		
		lab_cantidad.text = "%.2f" % data.material_restante
		
	if data.estado == SalaData.Estado.CONSTRUIDA:
		lab_nombre.text = data.nombre
		lab_estado.text = estado_a_texto(data.estado)
		
		lab_cantidad.visible = false
		lab_materia_restante.visible = false
