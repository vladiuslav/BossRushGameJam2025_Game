extends Node2D

@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var blood_list: Node = $Blood_List
@onready var timer: Timer = $Timer


const BLOOD = preload("res://Scenes/Blood/blood.tscn")

func _ready() -> void:
	SignalManager.blood_creation.connect(_create_blood)
	SignalManager.blood_colapse.connect(_blood_colapse)


func _process(delta: float) -> void:
	pass

func _create_blood(new_blood_pos:Vector2) ->void:
	var new_blood: Blood = BLOOD.instantiate() as Blood
	
	if (blood_list.get_children().is_empty()):
		new_blood.prev_blood = null 
	else :
		var prev_blood = blood_list.get_children().back() as Blood
		new_blood.prev_blood = prev_blood
		prev_blood.next_blood = new_blood
	
	new_blood.position = new_blood_pos
	
	blood_list.add_child(new_blood)

func _blood_colapse() -> void:
	collision_polygon_2d.polygon = _get_blood_vectors()
	collision_polygon_2d.disabled = false
	timer.start()
	#Check for colision and remove poligon

func _get_blood_vectors() -> PackedVector2Array:
	var new_array : PackedVector2Array = PackedVector2Array() 
	for child in blood_list.get_children() :
		var blood = child as Blood
		new_array.append(blood.position)
	
	return new_array

func _on_area_2d_body_entered(body: Node2D) -> void:
	timer.timeout.emit()
	#Add there damage logic


func _on_timer_timeout() -> void:
	for child in blood_list.get_children():
		blood_list.remove_child(child)
		child.queue_free()
	
	collision_polygon_2d.disabled = true
	collision_polygon_2d.polygon = PackedVector2Array()
