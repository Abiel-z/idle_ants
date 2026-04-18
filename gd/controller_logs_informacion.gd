extends VBoxContainer

@onready var txt_display_informacion : RichTextLabel = $lay_display_informacion/scroll_controller_logs_informacion/txt_display_informacion
@onready var controller_botones_salas = get_node("/root/BASE/escena_principal/HUD_2/hud_botones/lay_controller_botones/controller_botones_salas")

var max_lineas := 10 
var lineas := []

func _ready():
	ControllerForrajeo.connect("new_log", _on_new_log)
	ControllerHormiguero.connect("entrega_alimento", _on_entrega_alimento)
	ControllerHormiguero.connect("error_entrega", _on_error_entrega)
	controller_botones_salas.connect("sala_desbloqueada", _on_sala_desbloqueada)

func agregar_log(texto: String):
	lineas.append(texto)
	if lineas.size() > max_lineas:
		lineas.pop_front()
	txt_display_informacion.clear()
	for linea in lineas:
		txt_display_informacion.append_text(linea + "\n")
	call_deferred("_scroll_abajo")

func _on_new_log(texto):
	agregar_log(texto)

func _scroll_abajo():
	txt_display_informacion.scroll_to_line(txt_display_informacion.get_line_count())

func _on_sala_desbloqueada(sala):
	agregar_log("Ahora puedes construir : " + sala)

func _on_error_entrega(causa):
	agregar_log(causa)

func _on_entrega_alimento(cantidad):
	agregar_log("Se entregaron " + str(cantidad) + " de alimento")
