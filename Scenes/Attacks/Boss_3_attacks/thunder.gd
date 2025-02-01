extends Basic_Attack


func _ready() -> void:
	collision_shape_2d.disabled = true

func _set_colision_disabled_false()->void:
	collision_shape_2d.disabled = false
