extends MarginContainer

@onready var timer_label: Label = $MarginContainer/VBoxContainer/MarginContainer/TimerLabel
@onready var next_button: TextureButton = $MarginContainer/VBoxContainer/HBoxContainer/NextButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(is_won:bool):
	if !is_won:
		next_button.visible = false
	timer_label.text = Global.level_time()
	visible = true

func _on_next_button_pressed() -> void:
	Global.change_current_scene(Global.current_scene+1)

func _on_repit_button_pressed() -> void:
	Global.change_current_scene(Global.current_scene) # restarts current level

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	Global.change_current_scene(Global.SCENES.main_menu)
