extends Basic_Attack


func _ready() -> void:
	var player: Player = get_tree().get_nodes_in_group("player")[0] as Player
	if player:
		var direction = (player.global_position - global_position).normalized()
		rotation = direction.angle()
