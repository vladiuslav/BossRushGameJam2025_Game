extends CharacterBody2D

class_name Boss

@onready var timer_slow: Timer = $TimerSlow
@onready var timer_tick_damage: Timer = $TimerTickDamage

const DAMAGE_TICKS = 3
const TICK_DAMAGE = 5

# Movement variables
@export var boss_number: int = 1
@export var max_hp = 100.0


var current_hp: float = max_hp
var is_slowed: bool = false
var timer_ticks: int = 0

func _ready():
	pass

func _physics_process(delta: float) -> void:
	pass

func _hit(damage:int) ->void:
	current_hp -= damage
	if(current_hp <= 0):
		SignalManager.boss_killed.emit(boss_number)
		call_deferred("queue_free") # Later replace with deth animation
		
	SignalManager.boss_hit.emit()
	SignalManager.boss_hp_change.emit()

func apply_slow() ->void:
	is_slowed = true
	timer_slow.start()

func apply_tick_damage() -> void:
	timer_ticks = DAMAGE_TICKS
	timer_tick_damage.start()

func remove_status_effects() -> void:
	is_slowed = false
	timer_ticks = 0
	timer_slow.stop()
	timer_tick_damage.stop()

func get_hp() -> float:
	return current_hp / max_hp * 100.0

func _on_timer_slow_timeout() -> void:
	is_slowed =  false


func _on_timer_tick_damage_timeout() -> void:
	timer_ticks -= 1
	if(timer_ticks >= 0):
		
		current_hp -= TICK_DAMAGE
		SignalManager.boss_hp_change.emit()
		
		var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
		player.heal()
		
		if(current_hp <= 0):
			SignalManager.boss_killed.emit(boss_number)
			call_deferred("queue_free") # Later replace with deth animation
			
		timer_tick_damage.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body is Player):
		body._hit(10)
		var knockback_direction = (body.global_position - global_position).normalized()
		var knockback_strength = 20  # Adjust force as needed

		# Apply knockback
		body.position += knockback_direction * knockback_strength
