extends TextureButton

onready var _animation_player = get_node("Animation Player")


func _on_calibration_mode_activated():
	_animation_player.play(name + " Enabled-Disabled Animation")
	_animation_player.


func _on_game_mode_activated():
	_animation_player.play_backwards(name + " Enabled-Disabled Animation")