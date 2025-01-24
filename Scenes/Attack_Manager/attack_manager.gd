extends Node2D

const BOSS_ATTACK = preload("res://Scenes/Attacks/Boss_Attack/boss_attack.tscn")
const PLAYER_ATTACK = preload("res://Scenes/Attacks/Player_Attack/player_attack.tscn")

func _ready() -> void:
	SignalManager.create_attack.connect(create_attack)
	

func _process(delta: float) -> void:
	pass

func create_attack(new_position:Vector2, is_creator_player: bool, direction:Vector2, attack_damage:int) -> void:
	
	var new_attack:Basic_Attack
	
	if is_creator_player:
		new_attack = PLAYER_ATTACK.instantiate()
	else:
		new_attack = BOSS_ATTACK.instantiate()
	
	new_attack.setup(is_creator_player, new_position, direction, attack_damage)
	
	self.add_child(new_attack)
