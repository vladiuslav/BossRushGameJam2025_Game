extends Control

@onready var player_health: TextureProgressBar = $MarginContainer/VBoxContainer/Player_health
@onready var player_blood: TextureProgressBar = $MarginContainer/VBoxContainer/Player_blood
@onready var boss_health: TextureProgressBar = $MarginContainer2/Boss_health

@onready var spell_whell: Control = $SpellWhell
@onready var timer_label: Label = $MarginContainer3/TimerLabel


func _ready() -> void:
	SignalManager.player_hp_change.connect(_chage_player_hp)
	SignalManager.player_blood_change.connect(_change_player_blood)
	SignalManager.boss_hp_change.connect(_change_boss_hp)
	SignalManager.player_change_spell.connect(_rotate_spell_whell)


func _process(delta: float) -> void:
	Global.elapsed_time += delta  # Increment elapsed time
	timer_label.text = Global.level_time()  # Update label text

func _chage_player_hp():
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	player_health.value = player.current_hp / player.MAX_HP * 100

func _change_player_blood():
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	player_blood.value = player.current_blood / player.MAX_BLOOD  * 100

func _change_boss_hp():
	var boss: Boss = get_tree().get_nodes_in_group("boss")[0] as Boss
	boss_health.value = boss.current_hp / boss.max_hp * 100

func _rotate_spell_whell():
	match Global.curent_spell:
		Constants.PLAYER_SPELLS.FIRE:
			spell_whell.rotation_degrees = 0
		Constants.PLAYER_SPELLS.ICE:
			spell_whell.rotation_degrees = 90
		Constants.PLAYER_SPELLS.HEAL:
			spell_whell.rotation_degrees = -90
