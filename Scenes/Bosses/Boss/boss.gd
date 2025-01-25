extends CharacterBody2D

class_name Boss

# Movement variables
@export var boss_number: int = 1
@export var max_hp = 100.0
var current_hp: float = max_hp

func _ready():
	pass

func _physics_process(delta: float) -> void:
	pass

func hit(damage:int) ->void:
	current_hp -= damage
	print("Boss hp:")
	print(current_hp)
	if(current_hp <= 0):
		SignalManager.boss_killed.emit(boss_number)
		call_deferred("queue_free") # Later replace with deth animation
		

func get_hp() -> float:
	return current_hp / max_hp * 100.0
