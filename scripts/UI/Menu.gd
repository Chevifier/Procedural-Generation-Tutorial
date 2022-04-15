extends Control

onready var seed_line_edit = $VBoxContainer/VBoxContainer/HBoxContainer/seed_edit
onready var continue_btn = $VBoxContainer/VBoxContainer/Continue_Game
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	SaveSystem.load_data()
	if SaveSystem.data_loaded:
		seed_line_edit.text = str(Inventory.world_seed)
	else:
		seed_line_edit.text = "newworld"+str(round(rand_range(0,9999999)))
	show_continue(SaveSystem.data_loaded)


func _on_Continue_Game_pressed():
	get_tree().change_scene("res://scenes/World/World.tscn")


func _on_New_Game_pressed():
	SaveSystem.wipe_save()
	Inventory.world_seed = str(seed_line_edit.text)
	get_tree().change_scene("res://scenes/World/World.tscn")


func _on_Exit_pressed():
	get_tree().quit()
	
func show_continue(is_save_loaded):
	continue_btn.visible = is_save_loaded


func _on_shuffle_pressed():
	randomize()
	seed_line_edit.text = "newworld"+str(round(rand_range(0,9999999)))
