extends Node2D

@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var blood_list: Node = $Blood_List
@onready var timer: Timer = $Timer

const FIRE_BLOOD = preload("res://Scenes/BloodFormation/Blood/Spells_Blood/fire_blood.tscn")
const ICE_BLOOD = preload("res://Scenes/BloodFormation/Blood/Spells_Blood/ice_blood.tscn")
const HEAL_BLOOD = preload("res://Scenes/BloodFormation/Blood/Spells_Blood/heal_blood.tscn")

@onready var fire_spell_end: AnimatedSprite2D = $FireSpellEnd
@onready var ice_spell_end: AnimatedSprite2D = $IceSpellEnd
@onready var heal_spell_end: AnimatedSprite2D = $HealSpellEnd

@onready var audio_fire: AudioStreamPlayer2D = $AudioFire
@onready var audio_ice: AudioStreamPlayer2D = $AudioIce
@onready var audio_heal: AudioStreamPlayer2D = $AudioHeal


func _ready() -> void:
	SignalManager.blood_creation.connect(_create_blood)
	SignalManager.blood_colapse.connect(_blood_colapse)
	SignalManager.blood_colapse_cancel.connect(_blood_colapse_cancel)

func _process(delta: float) -> void:
	pass

func _create_blood(new_blood_pos:Vector2) ->void:
	var new_blood: Blood
	
	match Global.curent_spell:
		Constants.PLAYER_SPELLS.FIRE:
			new_blood = FIRE_BLOOD.instantiate()
		Constants.PLAYER_SPELLS.ICE:
			new_blood = ICE_BLOOD.instantiate()
		Constants.PLAYER_SPELLS.HEAL:
			new_blood = HEAL_BLOOD.instantiate()
			
	
	if (blood_list.get_children().is_empty()):
		new_blood.prev_blood = null
	else :
		var prev_blood = blood_list.get_children().back() as Blood
		new_blood.prev_blood = prev_blood
		prev_blood.next_blood = new_blood
	
	new_blood.position = new_blood_pos
	
	blood_list.add_child(new_blood)

func _blood_colapse() -> void:
	collision_polygon_2d.set_deferred("polygon",_get_blood_vectors())
	collision_polygon_2d.set_deferred("disabled",false)
	spell_effect_end()
	timer.start()
	#Check for colision and remove poligon

func _blood_colapse_cancel() -> void:
	for child in blood_list.get_children():
		blood_list.remove_child(child)
		child.queue_free()
	
	collision_polygon_2d.set_deferred("disabled",true)
	collision_polygon_2d.set_deferred("polygon",PackedVector2Array())

func _get_blood_vectors() -> PackedVector2Array:
	var new_array : PackedVector2Array = PackedVector2Array() 
	for child in blood_list.get_children() :
		var blood = child as Blood
		new_array.append(blood.position)
	
	return new_array

func spell_effect_end() -> void:
	var center = get_center()
	match Global.curent_spell:
		Constants.PLAYER_SPELLS.FIRE:
			fire_spell_end.position = center
			fire_spell_end.play("default")
			fire_spell_end.visible = true
			audio_fire.play()
			
		Constants.PLAYER_SPELLS.ICE:
			ice_spell_end.position = center
			ice_spell_end.play("default")
			ice_spell_end.visible = true
			audio_ice.play()
			
		Constants.PLAYER_SPELLS.HEAL:
			heal_spell_end.position = center
			heal_spell_end.play("default")
			heal_spell_end.visible = true
			audio_heal.play()

func get_center() -> Vector2:
	var center : Vector2 = Vector2.ZERO
	
	for child in blood_list.get_children() :
		var blood = child as Blood
		center += blood.position
	
	center /= blood_list.get_child_count()
	return center


func _on_area_2d_body_entered(body: Node2D) -> void:
	timer.timeout.emit()
	var boss = body as Boss
	
	match Global.curent_spell:
		Constants.PLAYER_SPELLS.FIRE:
			boss._hit(30)
		Constants.PLAYER_SPELLS.ICE:
			boss._hit(20)
			boss.apply_slow()
		Constants.PLAYER_SPELLS.HEAL:
			boss.apply_tick_damage()
			


func _on_timer_timeout() -> void:
	for child in blood_list.get_children():
		blood_list.remove_child(child)
		child.queue_free()
	
	collision_polygon_2d.set_deferred("disabled",true)
	collision_polygon_2d.set_deferred("polygon",PackedVector2Array())


func _on_fire_spell_end_animation_finished() -> void:
	fire_spell_end.visible = false


func _on_ice_spell_end_animation_finished() -> void:
	ice_spell_end.visible = false


func _on_heal_spell_end_animation_finished() -> void:
	heal_spell_end.visible = false
