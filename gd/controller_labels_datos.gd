extends HBoxContainer

@onready var label_cantidad_hormigas : Label = $label_nombres/lay_hormigas/lay_label_cantidad/label_cantidad_hormigas
@onready var label_cantidad_huevos : Label = $label_nombres/lay_hormigas/lay_label_cantidad/label_cantidad_huevos
@onready var label_cantidad_larvas : Label = $label_nombres/lay_hormigas/lay_label_cantidad/label_cantidad_larvas
@onready var label_cantidad_pupas : Label = $label_nombres/lay_hormigas/lay_label_cantidad/label_cantidad_pupas
@onready var label_cantidad_adultas : Label = $label_nombres/lay_hormigas/lay_label_cantidad/label_cantidad_adultos

@onready var label_cantidad_comida : Label = $label_nombres/lay_comida/lay_label_cantidad/label_cantidad_comida
@onready var label_cantidad_azucar : Label = $label_nombres/lay_comida/lay_label_cantidad/label_cantidad_azucar
@onready var label_cantidad_proteina : Label = $label_nombres/lay_comida/lay_label_cantidad/label_cantidad_proteina



# Called when the node enters the scene tree for the first time.
func _ready():
	ControllerHormiguero.connect("tick", _on_tick)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	actualizar_datos()
	pass

func _on_tick():
	pass

func actualizar_datos():
	var cantidad_comida = ControllerHormiguero.get_cantidad_comida()
	
	label_cantidad_comida.text = str(cantidad_comida)
	
	var cantidad_hormigas = ControllerHormiguero.get_cantidad_hormigas()
	var cantidad_huevos = ControllerHormiguero.get_cantidad_hormigas_por_estado(Hormiga.Estado.HUEVO)
	var cantidad_larvas = ControllerHormiguero.get_cantidad_hormigas_por_estado(Hormiga.Estado.LARVA)
	var cantidad_pupas = ControllerHormiguero.get_cantidad_hormigas_por_estado(Hormiga.Estado.PUPA)
	var cantidad_adultas = ControllerHormiguero.get_cantidad_hormigas_por_estado(Hormiga.Estado.ADULTA)
	
	label_cantidad_hormigas.text = str(cantidad_hormigas)
	label_cantidad_huevos.text = str(cantidad_huevos)
	label_cantidad_larvas.text = str(cantidad_larvas)
	label_cantidad_pupas.text = str(cantidad_pupas)
	label_cantidad_adultas.text = str(cantidad_adultas)
