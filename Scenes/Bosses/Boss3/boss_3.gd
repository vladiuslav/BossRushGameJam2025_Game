extends Boss

@onready var animation_player: AnimationPlayer = $AnimationPlayer


@onready var audio_move: AudioStreamPlayer2D = $Sounds/AudioMove
@onready var audio_death: AudioStreamPlayer2D = $Sounds/AudioDeath

enum AI_STATES {MOVE, CASTING_STORMSTRIKE, CASTING_THUNDERBRAND, CASTING_BLINKLASH, DEATH}

const SPEED = 30
const SPEED_SLOWED = 15

const NEW_POSITION_RANGE = 30
const MAP_SIZE = {
	"min":{"x":75,"y":75},
	"max":{"x":175,"y":175}
	}
	
var _current_state: AI_STATES = AI_STATES.MOVE
var next_position = null

func _ready() -> void:
	max_hp = 300
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	if (_current_state == AI_STATES.MOVE) :
		_movement()
	elif (_current_state == AI_STATES.CASTING_STORMSTRIKE) :
		animation_player.play("stormstrike")
	elif (_current_state == AI_STATES.CASTING_THUNDERBRAND) :
		animation_player.play("thunderbrand")
	elif (_current_state == AI_STATES.CASTING_BLINKLASH) :
		animation_player.play("blinklash")
	elif (_current_state == AI_STATES.DEATH) :
		pass
	
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
		animation_player.play("move")
		
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
	var random_index = randi_range(1,3) # 1-3 states for spells
	_change_state(random_index)

func set_state_move() -> void:
	_change_state(AI_STATES.MOVE)

func _change_state(new_state:AI_STATES) -> void:
	_current_state = new_state
	audio_move.stop()

func _hit(damage:int) ->void:
	current_hp -= damage
	if(current_hp <= 0):
		animation_player.play("death")
		audio_death.play()
		_change_state(AI_STATES.DEATH)
		
	SignalManager.boss_hit.emit()
	SignalManager.boss_hp_change.emit()

func _cast_thunderbrand() -> void:
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	var attack_position:Vector2 = self.global_position 
	attack_position.y += 5 # move attack to boss forward
	
	for i in range(1, 4):
		var direction = Vector2.from_angle(randf() * TAU)  # TAU = 2 * PI
		SignalManager.create_attack.emit(attack_position, Constants.ATTACK_TYPES.SPELL_GROUND_LIGHTING, direction)
	

func _cast_stormstrike() -> void:
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	var attack_position:Vector2 = player.global_position
	
	SignalManager.create_attack.emit(attack_position, Constants.ATTACK_TYPES.SPELL_THUNDER, Vector2.ZERO)

func _cast_blinklash() -> void:
	var random_direction = randi_range(0,4)
	
	match random_direction:
		0:
			self.global_position.y -= NEW_POSITION_RANGE
		1:
			self.global_position.y += NEW_POSITION_RANGE
		2:
			self.global_position.x -= NEW_POSITION_RANGE
		3:
			self.global_position.x += NEW_POSITION_RANGE
	
	self.global_position.x = clamp(self.global_position.x, MAP_SIZE.min.x, MAP_SIZE.max.x)
	self.global_position.y = clamp(self.global_position.y, MAP_SIZE.min.y, MAP_SIZE.max.y)

func death() -> void:
	SignalManager.boss_killed.emit(boss_number)
