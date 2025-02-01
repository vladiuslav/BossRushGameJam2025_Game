extends Button

@export var Lines : PackedStringArray

var _current_line = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = Lines[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	
	if(_current_line + 1 < Lines.size()):
		_current_line += 1
		self.text = Lines[_current_line]
	else:
		visible = false
		SignalManager.end_dialoge.emit()



func _on_skip_button_pressed() -> void:
	visible = false
	SignalManager.end_dialoge.emit()
