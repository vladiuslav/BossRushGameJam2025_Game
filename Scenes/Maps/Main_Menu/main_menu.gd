extends Control

@onready var levels_container: MarginContainer = $LevelsContainer
@onready var settings: TextureRect = $Settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	Global.change_current_scene(Global.SCENES.dojo)

func _on_select_level_button_pressed() -> void:
	levels_container.visible = !levels_container.visible

func _on_settings_button_pressed() -> void:
	settings.visible = !settings.visible

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_level_1_button_pressed() -> void:
	Global.change_current_scene(Global.SCENES.arena_1)

func _on_level_2_button_pressed() -> void:
	Global.change_current_scene(Global.SCENES.arena_2)

func _on_level_3_button_pressed() -> void:
	Global.change_current_scene(Global.SCENES.arena_3)
