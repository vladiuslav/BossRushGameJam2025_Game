extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.end_dialoge.connect(_end_dialoge)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _end_dialoge() ->void:
	Global.change_current_scene(Global.SCENES.arena_1)
