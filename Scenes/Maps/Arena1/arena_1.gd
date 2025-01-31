extends Node2D

@onready var ui: Control = $CanvasLayer/UI
@onready var ui_level_end: MarginContainer = $CanvasLayer/UI_level_end
@onready var audio_level_win: AudioStreamPlayer2D = $AudioLevelWin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.end_dialoge.connect(_on_dialog_end)
	SignalManager.game_over.connect(_played_dead)
	SignalManager.boss_killed.connect(_boss_dead)
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dialog_end() -> void:
	ui.visible = true
	get_tree().paused = false

func _played_dead() -> void:
	ui.visible = false
	get_tree().paused = true
	ui_level_end.setup(false)

func _boss_dead(boss_number:int) -> void:
	ui.visible = false
	get_tree().paused = true
	ui_level_end.setup(true)
	audio_level_win.play()
	
