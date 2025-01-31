extends Boss

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var stone_skin_timer: Timer = $StoneSkinTimer

# Sounds
@onready var audio_move: AudioStreamPlayer2D = $Sounds/AudioMove
@onready var audio_earth: AudioStreamPlayer2D = $Sounds/AudioEarth
@onready var audio_air: AudioStreamPlayer2D = $Sounds/AudioAir
@onready var audio_death: AudioStreamPlayer2D = $Sounds/AudioDeath


enum SPELLS {FIRE, WATER, EARTH, AIR}
enum AI_STATES {IDLE, IDLE_EARTH, MOVE, CASTING_FIRE, CASTING_WATER, CASTING_EARTH, CASTING_AIR, DEATH}

const SPEED = 30
const SPEED_SLOWED = 15

const NEW_POSITION_RANGE = 60
const MAP_SIZE = {
	"min":{"x":50,"y":50},
	"max":{"x":200,"y":200}
	}

var current_state : AI_STATES = AI_STATES.IDLE
var next_position = null

func _ready() -> void:
	max_hp = 300
	current_hp = max_hp
	
	_change_state(AI_STATES.MOVE)
	next_position = get_random_position()

func _physics_process(delta: float) -> void:
	
	
	if (current_state == AI_STATES.MOVE) :
		_movement()
	elif (current_state == AI_STATES.CASTING_FIRE) :
		animation_player.play("spell_fire")
	elif (current_state == AI_STATES.CASTING_WATER) :
		animation_player.play("spell_water")
	elif (current_state == AI_STATES.CASTING_EARTH) :
		animation_player.play("spell_earth")
	elif (current_state == AI_STATES.CASTING_AIR) :
		if(audio_air.playing != true):
			audio_air.play()
		animation_player.play("spell_air")
	elif (current_state == AI_STATES.IDLE_EARTH) :
		if(audio_earth.playing != true):
			audio_earth.play()
		animation_player.play("idle_earth")
	elif (current_state == AI_STATES.DEATH) :
		pass
	else:
		animation_player.play("idle")
	
	
	move_and_slide()

func _movement() -> void:
	
	if(next_position == null):
		next_position = get_random_position()
	
	if(audio_move.playing != true):
		audio_move.play()
	
	if(self.global_position.distance_to(next_position) > 10):
		var direction = self.global_position.direction_to(next_position)
		var current_speed : int 
		if(is_slowed):
			current_speed = SPEED_SLOWED
		else :
			current_speed = SPEED
		
		velocity = direction * current_speed
		if(velocity.y > 0):
			animation_player.play("move_down")
		else:
			animation_player.play("move_up")
		
	else:
		next_position = null
		set_state_random_spell()
		velocity = Vector2.ZERO
	

func get_random_position() -> Vector2:
	
	var random_x: int = randi_range(-NEW_POSITION_RANGE, NEW_POSITION_RANGE)
	var random_y: int = randi_range(-NEW_POSITION_RANGE, NEW_POSITION_RANGE)
	
	var random_position: Vector2 = self.global_position + Vector2(random_x, random_y)
	
	# Clamp the position to ensure it stays within map boundaries
	random_position.x = clamp(random_position.x, MAP_SIZE.min.x, MAP_SIZE.max.x)
	random_position.y = clamp(random_position.y, MAP_SIZE.min.y, MAP_SIZE.max.y)
	
	return random_position

func set_state_random_spell() -> void:
	var random_index = randi_range(3,6) # 3-6 states for spells
	_change_state(random_index)

func set_state_idle() -> void:
	_change_state(AI_STATES.IDLE)

func set_state_move() -> void:
	_change_state(AI_STATES.MOVE)

func _change_state(new_state:AI_STATES) -> void:
	current_state = new_state
	audio_move.stop()
	audio_earth.stop()
	audio_air.stop()
	

func _cast_sunstrike() -> void:
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	var attack_position:Vector2 = player.global_position
	
	SignalManager.create_attack.emit(attack_position, Constants.ATTACK_TYPES.SPELL_FIRE, Vector2.ZERO)

func _cast_icicle() -> void:
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	var attack_position:Vector2 = self.global_position 
	attack_position.y += 5 # move attack to boss forward
	var attack_direction:Vector2 = self.global_position.direction_to(player.global_position)
	
	SignalManager.create_attack.emit(attack_position, Constants.ATTACK_TYPES.SPELL_WATER, attack_direction)

func _cast_stoneskin() -> void:
	_change_state(AI_STATES.IDLE_EARTH)
	collision_shape_2d.disabled = true
	stone_skin_timer.start()

func _on_stone_skin_timer_timeout() -> void:
	_change_state(AI_STATES.IDLE)
	collision_shape_2d.disabled = false

func _cast_airdash() -> void:
	var random_direction = randi_range(0,4)
	
	match random_direction:
		0:
			self.global_position.y -= 100
		1:
			self.global_position.y += 100
		2:
			self.global_position.x -= 100
		3:
			self.global_position.x += 100
	
	self.global_position.x = clamp(self.global_position.x, MAP_SIZE.min.x, MAP_SIZE.max.x)
	self.global_position.y = clamp(self.global_position.y, MAP_SIZE.min.y, MAP_SIZE.max.y)

func _hit(damage:int) ->void:
	current_hp -= damage
	if(current_hp <= 0):
		animation_player.play("death")
		audio_death.play()
		_change_state(AI_STATES.DEATH)
		
	SignalManager.boss_hit.emit()
	SignalManager.boss_hp_change.emit()

func death() -> void:
	SignalManager.boss_killed.emit(boss_number)
