extends CharacterBody2D

class_name Boss

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Movement variables
const SPEED = 30
const MAX_HP = 500

enum AI_STATES {ATTACK, CHASE}

var current_state:AI_STATES = AI_STATES.CHASE
var current_hp = MAX_HP

func _ready():
	pass

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	
	if (self.global_position.distance_to(player.global_position) > 100 and current_state == AI_STATES.CHASE) :
		velocity = self.global_position.direction_to(player.global_position) * SPEED
		
		# Animation
		sprite_2d.flip_h = false
		
		if (velocity.y > 0):
			animation_player.play("move_forward")
			
		elif (velocity.y < 0):
			animation_player.play("move_back")
			
		elif (velocity.x > 0):
			sprite_2d.flip_h = true
			animation_player.play("move_left")
			
		elif (velocity.x < 0):
			animation_player.play("move_left")
			
		else :
			animation_player.play("idle")
		
	else :
		if(current_state!=AI_STATES.ATTACK):
			attack()
		
	
	move_and_slide()

func attack() -> void:
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	var attack_direction:Vector2
	var attack_position
	
	velocity = Vector2.ZERO
	current_state = AI_STATES.ATTACK
	
	attack_direction = self.global_position.direction_to(player.global_position)
	attack_position = self.global_position + (attack_direction * 80)
	
	# Change sprite direction at attack
	animation_player.play("attack")
	
	SignalManager.create_attack.emit(attack_position, false, attack_direction, 10)

func _end_attack() -> void:
	current_state = AI_STATES.CHASE

func hit(damage:int) ->void:
	current_hp -= damage
	print("Boss hp:")
	print(current_hp)
	
	if(current_hp <= 0):
		# Add there kill boss signal
		call_deferred("queue_free")
		
