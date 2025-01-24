extends CharacterBody2D

class_name Player

enum DIRECTION {LEFT, RIGHT}
enum PLAYER_STATE {ATTACK, IDLE}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var _direction : DIRECTION = DIRECTION.RIGHT
var _state : PLAYER_STATE = PLAYER_STATE.IDLE

const SPEED_NORMAL = 60.0
const SPEED_STRIFE = 120.0
const MAX_HP = 100

var current_hp:int = MAX_HP
var current_speed = SPEED_NORMAL

var last_spawn_position : Vector2 = Vector2.ZERO
const SPAWN_DISTANCE = 16

func _physics_process(delta: float) -> void:
	
	if (Input.is_action_pressed("slide")):
		calculate_slide()
		current_speed = SPEED_STRIFE
	else:
		current_speed = SPEED_NORMAL
	
	if (_state == PLAYER_STATE.IDLE) :
		get_input()
		
		if Input.is_action_just_pressed("attack"):
			attack()
		
	move_and_slide()

func get_input() -> void:
	
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("up","down")
	
	velocity = direction.normalized() * current_speed
	
	sprite_2d.flip_h = false
	
	if (velocity.y > 0):
		animation_player.play("moving_bottom")
		
	elif (velocity.y < 0):
		animation_player.play("moving_top")
		
	elif (velocity.x > 0):
		sprite_2d.flip_h = true
		animation_player.play("moving_left")
		_direction = DIRECTION.RIGHT
		
	elif (velocity.x < 0):
		animation_player.play("moving_left")
		_direction = DIRECTION.LEFT
		
	else :
		animation_player.play("idle")
	

func attack() -> void:
	var attack_direction:Vector2
	var attack_position = self.position
	
	velocity = Vector2.ZERO
	_state = PLAYER_STATE.ATTACK
	
	if(_direction == DIRECTION.RIGHT):
		sprite_2d.flip_h = true
		attack_direction = Vector2.RIGHT
		attack_position.y += 10
	elif(_direction == DIRECTION.LEFT):
		sprite_2d.flip_h = false
		attack_direction = Vector2.LEFT
		attack_position.y -= 10
	
	animation_player.play("attack")
	
	SignalManager.create_attack.emit(attack_position, true, attack_direction, 10)

#Used in Animation Player
func _change_to_idle() -> void:
	_state = PLAYER_STATE.IDLE
	

func calculate_slide() -> void:
	
	var distance_moved = position.distance_to(last_spawn_position)
	
	if distance_moved >= SPAWN_DISTANCE :
		SignalManager.blood_creation.emit(position)
		
		last_spawn_position = position

func hit(damage:int) ->void:
	current_hp -= damage
	print("Player hp:")
	print(current_hp)
	if(current_hp <= 0):
		SignalManager.game_over.emit()
		call_deferred("queue_free")
		
