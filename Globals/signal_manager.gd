extends Node

signal game_over
signal boss_killed(boss_number:int)

signal blood_colapse
signal blood_colapse_cancel
signal blood_creation(position:Vector2)

signal create_attack(new_position:Vector2, attack_type: Constants.ATTACK_TYPES, direction:Vector2)
signal boss_hit

signal boss_hp_change
signal player_hp_change
signal player_blood_change
signal player_change_spell

signal end_dialoge
