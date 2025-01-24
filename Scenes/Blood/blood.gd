extends Area2D
class_name Blood 

@export var prev_blood: Blood = null
@export var next_blood: Blood = null

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	sprite_2d.frame = randi_range(0,3)
	

func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if (area != prev_blood and area != next_blood):
		SignalManager.blood_colapse.emit()


func _on_timer_timeout() -> void:
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	self.look_at(player.global_position)
