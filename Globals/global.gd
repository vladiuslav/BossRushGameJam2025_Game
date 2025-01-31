extends Node


var curent_spell: Constants.PLAYER_SPELLS = Constants.PLAYER_SPELLS.FIRE

enum SCENES {main_menu, arena_1, arena_2}

const MAIN_MENU = preload("res://Scenes/Maps/Main_Menu/main_menu.tscn")
const ARENA_1 = preload("res://Scenes/Maps/Arena1/arena_1.tscn")
const ARENA_2 = preload("res://Scenes/Maps/Arena2/arena_2.tscn")

var current_scene : SCENES = SCENES.main_menu

var elapsed_time: float = 0.0

func change_current_scene(new_scene: SCENES) ->void:
	elapsed_time = 0
	current_scene = new_scene
	get_tree().paused = false
	
	match new_scene:
		SCENES.main_menu:
			get_tree().change_scene_to_packed(MAIN_MENU)
		SCENES.arena_1:
			get_tree().change_scene_to_packed(ARENA_1)
		SCENES.arena_2:
			get_tree().change_scene_to_packed(ARENA_2)


func level_time() -> String:
	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60
	return "%02d:%02d" % [minutes, seconds]  # Format MM:SS
