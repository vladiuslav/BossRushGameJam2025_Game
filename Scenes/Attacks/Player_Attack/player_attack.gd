extends Basic_Attack

func _setup(is_creator_player: bool, position:Vector2, direction:Vector2, speed :int, damage:int) -> void:
	
	match direction:
		Vector2.RIGHT:
			rotation_degrees = 0
		Vector2.DOWN:
			rotation_degrees = 90
		Vector2.LEFT:
			rotation_degrees = 180
		Vector2.UP:
			rotation_degrees = 270
		
	super._setup(is_creator_player, position, direction, speed, damage)
