extends CharacterBody2D

class_name Player

enum PLAYER_STATE {ATTACK, IDLE, PAINT, DEATH}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

# Sounds
@onready var audio_move: AudioStreamPlayer = $AudioPlayers/AudioMove
@onready var audio_paint: AudioStreamPlayer = $AudioPlayers/AudioPaint
@onready var audio_death: AudioStreamPlayer = $AudioPlayers/AudioDeath


var _state : PLAYER_STATE = PLAYER_STATE.IDLE

const SPEED_NORMAL = 60.0
const SPEED_PAINT = 90.0

const MAX_HP : float = 100.0
const HEAL_HP = 5

const MAX_BLOOD : float = 100.0
const BLOOD_PER_HIT = 10


var current_hp:float = MAX_HP
var current_blood:float = 0
var current_speed = SPEED_NORMAL

var last_direction:Vector2 = Vector2.ZERO
var last_spawn_position : Vector2 = Vector2.ZERO
const SPAWN_DISTANCE = 15

func _ready() -> void:
	SignalManager.blood_colapse.connect(_change_to_idle)
	SignalManager.boss_hit.connect(add_blood)

func _physics_process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("change_spell")):
		_change_spell()
	
	if (_state == PLAYER_STATE.IDLE and Input.is_action_just_pressed("attack")):
		attack()
		
	elif (_state == PLAYER_STATE.IDLE and Input.is_action_pressed("slide")):
		_change_state(PLAYER_STATE.PAINT)
	
	elif (_state == PLAYER_STATE.IDLE) :
		current_speed = SPEED_NORMAL
		_move_idle()
	
	elif (_state == PLAYER_STATE.PAINT) :
		if(current_blood == 0):
			_change_to_idle()
			SignalManager.blood_colapse_cancel.emit()
		else:
			current_speed = SPEED_PAINT
			calculate_blood_spawn()
			_move_paint()
			if(audio_paint.playing != true):
				audio_paint.play()
	elif(_state == PLAYER_STATE.DEATH):
		pass
	
	move_and_slide()

func _change_spell() -> void:
	
	_change_to_idle()
	SignalManager.blood_colapse_cancel.emit()
	
	if(Global.curent_spell + 1 < 3):
		Global.curent_spell = Global.curent_spell+1
	else:
		Global.curent_spell = 0
		
	SignalManager.player_change_spell.emit() # change in UI

func _move_idle() -> void:
	
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("up","down")
	
	if (direction != Vector2.ZERO):
		last_direction = direction.normalized()
	
	velocity = direction.normalized() * current_speed
	
	if(audio_move.playing != true):
			audio_move.play()
	
	
	if (velocity.y > 0):
		animation_player.play("move_down")
		
	elif (velocity.y < 0):
		animation_player.play("move_up")
		
	elif (velocity.x > 0):
		animation_player.play("move_right")
		
	elif (velocity.x < 0):
		animation_player.play("move_left")
		
	else :
		audio_move.stop()
		animation_player.play("idle")

func _move_paint() -> void:
	
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("left","right")
	direction.y = Input.get_axis("up","down")
	
	if (direction != Vector2.ZERO):
		last_direction = direction.normalized()
	
	velocity = direction.normalized() * current_speed
	
	if (velocity.y > 0):
		animation_player.play("paint_down")
		
	elif (velocity.y < 0):
		animation_player.play("paint_up")
		
	elif (velocity.x > 0):
		animation_player.play("paint_right")
		
	elif (velocity.x < 0):
		animation_player.play("paint_left")
		
	else :
		_change_to_idle()
		SignalManager.blood_colapse_cancel.emit()

func attack() -> void:
	velocity = Vector2.ZERO
	_change_state(PLAYER_STATE.ATTACK)
	
	match last_direction: # creates attack into last moved direction
		Vector2.UP:
			animation_player.play("attack_up")
			
		Vector2.DOWN:
			animation_player.play("attack_down")
			
		Vector2.LEFT:
			animation_player.play("attack_left")
			
		Vector2.RIGHT:
			animation_player.play("attack_right")
			
		_:
			_change_to_idle()
	


func _create_attack() -> void:
	var attack_position = self.position
	var attack_direction = last_direction
	
	match attack_direction:
		Vector2.UP:
			attack_position.y -= 10
			
		Vector2.DOWN:
			attack_position.y += 10
			
		Vector2.LEFT:
			attack_position.x -= 10
			
		Vector2.RIGHT:
			attack_position.x += 10
	
	SignalManager.create_attack.emit(attack_position, Constants.ATTACK_TYPES.PLAYER_ATTACK, attack_direction)

#Used in Animation Player
func _change_to_idle() -> void:
	_change_state(PLAYER_STATE.IDLE)

func _change_state(new_state:PLAYER_STATE) ->void:
	_state = new_state
	audio_move.stop()
	audio_paint.stop()

func calculate_blood_spawn() -> void:
	
	var distance_moved = position.distance_to(last_spawn_position)
	
	if distance_moved >= SPAWN_DISTANCE :
		
		current_blood -= 1
		SignalManager.player_blood_change.emit()
		
		SignalManager.blood_creation.emit(position)
		
		last_spawn_position = position
	

func add_blood() -> void:
	current_blood += BLOOD_PER_HIT
	SignalManager.player_blood_change.emit()
	
	if(current_blood >= MAX_BLOOD):
		current_blood = MAX_BLOOD
	

func _hit(damage:int) ->void:
	current_hp -= damage
	SignalManager.player_hp_change.emit()
	
	if(current_hp <= 0):
		animation_player.play("death")
		audio_death.play()
		_change_state(PLAYER_STATE.DEATH)

func death() -> void:
	SignalManager.game_over.emit()

func heal() ->void:
	current_hp += HEAL_HP
	SignalManager.player_hp_change.emit()
	
	if(current_hp >= MAX_HP):
		current_hp = MAX_HP
	
