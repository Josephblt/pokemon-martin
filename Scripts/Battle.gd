extends Node

var autoclicker = 0
export var count = 0

func _ready():
	var file = File.new()
	if file.file_exists("user://save.txt"):
		file.open("user://save.txt", File.READ)
		var data = parse_json(file.get_line())
		count = data.count

func _on_Button_pressed():
	count += 1

# warning-ignore:unused_argument
func _process(delta):
#	$Label.text = str(count)
	pass

func _on_Saving_timeout():
	var data = {
			count = count
		}
	var file = File.new()
	file.open("user://save.txt", File. WRITE)
	file.store_line(to_json(data))
	file.close()
