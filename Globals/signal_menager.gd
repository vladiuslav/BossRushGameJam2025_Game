extends Node

signal game_over

signal blood_colapse
signal blood_creation(position:Vector2)
signal create_attack(new_position:Vector2, is_creator_player: bool, direction:Vector2, attack_damage:int)
