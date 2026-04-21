extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = Engine.is_editor_hint()
	color = Color.RED
	#var stylebox = StyleBoxFlat.new()
	#stylebox.bg_color = Color.TRANSPARENT  # Fondo transparente
	#stylebox.border_width_left = 2
	#stylebox.border_width_right = 2
	#stylebox.border_width_top = 2
	#stylebox.border_width_bottom = 2
	#stylebox.border_color = Color.WHITE
	#stylebox.set_corner_radius_all(4)  # Opcional: esquinas redondeadas
#
	#self.add_theme_stylebox_override("panel", stylebox)
