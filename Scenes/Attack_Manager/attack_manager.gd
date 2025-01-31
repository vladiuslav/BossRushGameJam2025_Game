extends Node2D

const PLAYER_ATTACK = preload("res://Scenes/Attacks/Player_Attack/player_attack.tscn")
const OGRE_ATTACK = preload("res://Scenes/Attacks/Ogre_Attack/ogre_attack.tscn")
const SUNSTRIKE = preload("res://Scenes/Attacks/Boss_2_attacks/Sunstrike/sunstrike.tscn")
const ICICLE = preload("res://Scenes/Attacks/Boss_2_attacks/Icicle/icicle.tscn")

func _ready() -> void:
	SignalManager.create_attack.connect(create_attack)

func _process(delta: float) -> void:
	pass

func create_attack(new_position:Vector2, attack_type: Constants.ATTACK_TYPES, direction:Vector2) -> void:
	var new_attack:Basic_Attack
	var is_creator_player : bool = false
	var speed = 0
	var damage = 1
	
	match attack_type:
		Constants.ATTACK_TYPES.PLAYER_ATTACK:
			is_creator_player = true
			new_attack = PLAYER_ATTACK.instantiate()
			damage = 10
			speed = 120
			
		Constants.ATTACK_TYPES.OGRE_ATTACK:
			new_attack = OGRE_ATTACK.instantiate()
			damage = 10
			speed = 20
			
		Constants.ATTACK_TYPES.SPELL_FIRE:
			new_attack = SUNSTRIKE.instantiate()
			damage = 30
			
		Constants.ATTACK_TYPES.SPELL_WATER:
			new_attack = ICICLE.instantiate()
			damage = 10
			speed = 150
	
	new_attack._setup(is_creator_player, new_position, direction, speed, damage)
	
	self.add_child(new_attack)
