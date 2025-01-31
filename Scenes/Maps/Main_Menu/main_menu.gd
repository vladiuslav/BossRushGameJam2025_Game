extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	Global.change_current_scene(Global.SCENES.dojo)


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.
	# Add there global sound changing logic.



func _on_exit_button_pressed() -> void:
	get_tree().quit()
