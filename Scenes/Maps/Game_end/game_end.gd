extends Control


func _ready() -> void:
	SignalManager.end_dialoge.connect(_on_end)

func _process(delta: float) -> void:
	pass

func _on_end() -> void:
	Global.change_current_scene(Global.SCENES.main_menu)
