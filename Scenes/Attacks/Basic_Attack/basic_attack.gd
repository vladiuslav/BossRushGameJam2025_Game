extends Area2D

class_name Basic_Attack

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var damage: int = 1
var speed: int = 0 # Stay on place by default
var is_creator_boss_or_plaer:bool
var _direction:Vector2

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	position += _direction * speed * delta

func _setup(is_creator_player: bool, position:Vector2, direction:Vector2, speed :int, damage:int) -> void:
	
	self.position = position
	self.damage = damage
	is_creator_boss_or_plaer = is_creator_player
	_direction = direction
	self.speed = speed
	
	if is_creator_player:
		set_collision_layer_value(1,true) # 1 - Player
		set_collision_mask_value(3,true) # 3 - Boss
	else:
		set_collision_layer_value(3,true) # 3 - Boss
		set_collision_mask_value(1,true) # 1 - Player

func _on_body_entered(body: Node2D) -> void:
	if(body is Player or body is Boss):
		body._hit(damage)
		collision_shape_2d.set_deferred("disabled",true)
	

func _on_timer_timeout() -> void:
	queue_free()
