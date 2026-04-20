extends Control

signal prioridades_cambiadas(valores :Dictionary)

@onready var slider_recolectar : Slider = $horizontal_1/vertical_1/slider_recolectar 
@onready var slider_explorar : Slider = $horizontal_1/vertical_2/slider_explorar 
@onready var slider_construir : Slider = $horizontal_1/vertical_3/slider_construir 

@onready var texto_recolectar : Label = $horizontal_1/vertical_1/valor_recolectar
@onready var texto_explorar : Label = $horizontal_1/vertical_2/valor_explorar
@onready var texto_construir : Label = $horizontal_1/vertical_3/valor_construir

var valores = {
	"recolectar" : 0.34,
	"explorar" : 0.33,
	"construir" : 0.33
}
var actualizando := false

func _ready():
	slider_recolectar.value_changed.connect(_on_slider_recolectar)
	slider_explorar.value_changed.connect(_on_slider_explorar)
	slider_construir.value_changed.connect(_on_slider_construir)
	
	slider_recolectar.step = 0.01
	slider_explorar.step = 0.01
	slider_construir.step = 0.01
	
	actualizar_sliders()
	actualizar_textos()


func actualizar_sliders():
	slider_recolectar.value = valores["recolectar"]
	slider_explorar.value = valores["explorar"]
	slider_construir.value = valores["construir"]

func _on_slider_construir(value):
	cambiar_valor("construir", value)

func _on_slider_explorar(value):
	cambiar_valor("explorar", value)

func _on_slider_recolectar(value):
	cambiar_valor("recolectar", value)

func actualizar_textos():
	texto_recolectar.text = "%.2f" % valores["recolectar"]
	texto_explorar.text = "%.2f" % valores["explorar"]
	texto_construir.text = "%.2f" % valores["construir"]


func set_valores(nuevos: Dictionary):
	print("set valores llamado")
	actualizando = true
	valores = nuevos.duplicate()
	actualizar_sliders()
	actualizar_textos()
	actualizando = false

func cambiar_valor(tipo: String , nuevo_valor: float):
	if actualizando:
		return
	actualizando = true
	var delta = nuevo_valor - valores [tipo]
	valores[tipo] = nuevo_valor
	
	var otros = valores.keys().filter(func(k):return k!=tipo)
	for k in otros:
		valores[k] -= delta / otros.size()
	
	normalizar()
	actualizar_sliders()
	actualizar_textos()
	emit_signal("prioridades_cambiadas", valores)
	actualizando = false
	
func normalizar():
	var total = 0.0
	for v in valores.values():
		total += v
	if total == 0:
		return
	for k in valores.keys():
		valores[k] = clamp(valores[k] / total, 0.0, 1.0)
	

