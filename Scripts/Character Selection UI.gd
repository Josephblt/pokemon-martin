extends Control

enum Characters {
	MARTIN,
	MELISSA,
}

var _current_character

onready var _animation_player = get_node("Character Selection Animation Player")


func _on_Martin_Button_pressed():
	_current_character = Characters.MARTIN
	_animation_player.play("Martin Selected")
	


func _on_Melissa_Button_pressed():
	_current_character = Characters.MELISSA
	_animation_player.play("Melissa Selected")