extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("pause")):
		visible = !visible
		get_tree().paused = !get_tree().paused


func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	Global.change_current_scene(Global.SCENES.main_menu)


func _on_repit_button_pressed() -> void:
	Global.change_current_scene(Global.current_scene) # restarts current level


func _on_next_button_pressed() -> void:
	get_tree().paused = false
	visible = false
