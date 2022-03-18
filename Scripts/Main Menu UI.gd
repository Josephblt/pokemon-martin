extends Control

var _gui_locked

onready var _profile = get_node("Profile")
onready var _battle = get_node("Battle")
onready var _shop = get_node("Shop")
onready var _animation_player = get_node("Main Menu Animation Player")


func _translate(distance):
	var relative = (Vector2.RIGHT * distance);
	
	var profile_center_position = _profile.rect_position + relative
	var battle_center_position = _battle.rect_position +  relative
	var shop_center_position = _shop.rect_position + relative
	
	_profile.set_position(profile_center_position)
	_battle.set_position(battle_center_position)
	_shop.set_position(shop_center_position)


func _finish_translation():
	
	var data = {}
	data.parse_json("Wagner");
	
	var center = get_viewport_rect().size / 2
	
	var profile_center_position = _profile.rect_position + (_profile.rect_size / 2)
	var battle_center_position = _battle.rect_position + (_battle.rect_size / 2)
	var shop_center_position = _shop.rect_position + (_shop.rect_size / 2)
	
	var pd = center.distance_to(profile_center_position)
	var bd = center.distance_to(battle_center_position)
	var sd = center.distance_to(shop_center_position)
	
	if pd < bd and pd < sd:
		_animation_player.play("Lock Profile")
		
	if bd < pd and bd < sd:
		_animation_player.play("Lock Battle")
		
	if sd < pd and sd < bd:
		_animation_player.play("Lock Shop")


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			_gui_locked = true
		else:
			_gui_locked = false
			_finish_translation()
	
	if _gui_locked and event is InputEventMouseMotion:
		_translate(event.relative.x)
