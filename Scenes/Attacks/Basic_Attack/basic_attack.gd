extends Area2D

class_name Basic_Attack

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var damage: int = 1
var speed: int = 0 # Stay on place by default
var is_creator_boss_or_plaer:bool
var attack_direction:Vector2

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	position += attack_direction * speed * delta

func setup(is_creator_player: bool, new_position:Vector2, new_direction:Vector2, attack_damage:int) -> void:
	
	position = new_position
	damage = attack_damage
	is_creator_boss_or_plaer = is_creator_player
	attack_direction = new_direction
	
	if is_creator_player:
		speed = 150
		set_collision_layer_value(1,true) # 1 - Player
		set_collision_mask_value(3,true) # 3 - Boss
	else:
		speed = 0
		set_collision_layer_value(3,true) # 3 - Boss
		set_collision_mask_value(1,true) # 1 - Player

func _on_body_entered(body: Node2D) -> void:
	if(body is Player or body is Boss):
		body.hit(damage)
		collision_shape_2d.disabled = true
	

func _on_timer_timeout() -> void:
	queue_free()
