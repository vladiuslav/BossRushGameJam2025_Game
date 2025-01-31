extends Boss

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_couldown_timer: Timer = $AttackCouldownTimer

#Sounds
@onready var audio_move: AudioStreamPlayer2D = $Sounds/AudioMove
@onready var audio_slash: AudioStreamPlayer2D = $Sounds/AudioSlash
@onready var audio_death: AudioStreamPlayer2D = $Sounds/AudioDeath

# Movement variables
const SPEED = 30
const SPEED_SLOWED = 15

enum AI_STATES {ATTACK, CHASE, COULDOWN, DEATH}

var current_state:AI_STATES = AI_STATES.CHASE

func _ready():
	max_hp = 5
	current_hp = max_hp

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	if (current_state==AI_STATES.DEATH):
		pass
	elif (self.global_position.distance_to(player.global_position) > 50 and current_state == AI_STATES.CHASE) :
		var current_speed : int 
		if(is_slowed):
			current_speed = SPEED_SLOWED
		else :
			current_speed = SPEED
			
		velocity = self.global_position.direction_to(player.global_position) * current_speed
		_movement()
		
	elif (current_state==AI_STATES.COULDOWN):
		animation_player.play("idle")
		
	elif (current_state!=AI_STATES.ATTACK):
		_start_attack()
	
	move_and_slide()

func _movement() -> void:
	sprite_2d.flip_h = false
	var animation_direction = velocity.normalized()
	
	if abs(animation_direction.x) > abs(animation_direction.y):  # Horizontal movement
		if animation_direction.x > 0:
			sprite_2d.flip_h = true
			animation_player.play("move_left")
		else:
			animation_player.play("move_left")
	else:  # Vertical movement
		if animation_direction.y > 0:
			animation_player.play("move_down")
		else:
			animation_player.play("move_up")
	
	if(audio_move.playing != true):
		audio_move.play()
	

func _start_attack() -> void: # phase of attack 1
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	var attack_direction:Vector2 = self.global_position.direction_to(player.global_position)
	
	velocity = Vector2.ZERO
	current_state = AI_STATES.ATTACK
	
	if attack_direction.x > 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	
	animation_player.play("attack")
	

func _create_attack() -> void: # phase of attack 2
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	var attack_direction:Vector2 = self.global_position.direction_to(player.global_position)
	
	var attack_position = self.global_position + (attack_direction * 40)
	
	audio_slash.play()
	
	SignalManager.create_attack.emit(attack_position, Constants.ATTACK_TYPES.OGRE_ATTACK, Vector2.ZERO)

func _end_attack() -> void: # phase of attack 3
	current_state = AI_STATES.COULDOWN
	attack_couldown_timer.start()

func _on_attack_couldown_timer_timeout() -> void:
	_change_state(AI_STATES.CHASE)

func _change_state(new_state:AI_STATES) -> void:
	current_state = new_state
	audio_slash.stop()
	audio_move.stop()

func _hit(damage:int) ->void:
	current_hp -= damage
	if(current_hp <= 0):
		attack_couldown_timer.stop()
		animation_player.play("death")
		audio_death.play()
		_change_state(AI_STATES.DEATH)
		
	SignalManager.boss_hit.emit()
	SignalManager.boss_hp_change.emit()

func death() -> void:
	SignalManager.boss_killed.emit(boss_number)
