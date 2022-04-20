extends Node

signal saving
var data_loaded = false
const SAVE_DIR = "user://saves/"
var my_password = "0123456789"

var file_path = SAVE_DIR + "procgen_tutorial_save.dat"
var loaded_data;

func _ready():
	pass

func save_data():
	emit_signal("saving", "SAVING DATA...")
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var save_file = File.new()
	#save with encryption
	save_file.open_encrypted_with_pass(file_path,File.WRITE,my_password)
	##Store Data Here
	save_file.store_var(Data.Seed)
	save_file.store_var(Data.player_stats)
	save_file.store_var(Data.items)
	save_file.store_var(Data.removed_trees)
	save_file.store_var(Data.removed_rocks)
	save_file.close()
	emit_signal("saving", "DATA SAVED")
	print_data()
	
func load_data():
	var save_file = File.new()
	if save_file.file_exists(file_path):
		save_file.open_encrypted_with_pass(file_path,File.READ,my_password)
		##LOAD data here
		Data.Seed = save_file.get_var()
		Data.player_stats = save_file.get_var()
		Data.items = save_file.get_var()
		Data.removed_trees = save_file.get_var()
		Data.removed_rocks = save_file.get_var()
		save_file.close()
		data_loaded = true
		print_data()
		
		
func print_data():
	print(Data.Seed)
	print(Data.player_stats)
	print(Data.removed_trees)
	print(Data.removed_rocks)


func wipe_save():
	print("data wipe")
	Data.RESET_DATA()
	var dir = Directory.new()
	if dir.file_exists(file_path):
		dir.remove(file_path)
