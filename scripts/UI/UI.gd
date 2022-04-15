extends CanvasLayer

onready var wood_txt = $main/HBoxContainer2/HBoxContainer/Wood_amount
onready var rocks_txt = $main/HBoxContainer2/HBoxContainer2/Rock_amount
onready var save_status_txt = $Pause/save_status

onready var main_ui = $main
onready var pause_ui = $Pause
func _ready():
	_on_resume_pressed()
	SaveSystem.connect("saving",self,"update_save_status")
	
func _process(delta):
	if wood_txt.text != str(Inventory.items["wood"]):
		wood_txt.text = str(Inventory.items["wood"])
	if rocks_txt.text != str(Inventory.items["rocks"]):
		rocks_txt.text = str(Inventory.items["rocks"])
		
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		main_ui.visible = false
		pause_ui.visible = true
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		_on_resume_pressed()
		


func _on_resume_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	main_ui.visible = true
	pause_ui.visible = false

func update_save_status(status):
	save_status_txt.text = status


func _on_save_pressed():
	Inventory.emit_signal("update_player_position")
	SaveSystem.save_data()
	
func _on_save_quit_pressed():
	_on_save_pressed()
	get_tree().change_scene("res://scenes/UI/Menu.tscn")


func _on_reset_pressed():
	SaveSystem.wipe_save()
	get_tree().reload_current_scene()
	
	
