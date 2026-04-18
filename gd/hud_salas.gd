extends VBoxContainer

@onready var lab_profundidad : Label = $lay_profundidad/profundidad

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lab_profundidad.text = str(ControllerExcavacion.profundidad)
	pass
