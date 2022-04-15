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
	#save file without encryption
	#save_file.open(file_path,File.WRITE)
	#save with encryption
	save_file.open_encrypted_with_pass(file_path,File.WRITE,my_password)
	save_file.store_var(Inventory.world_seed)
	save_file.store_var(Inventory.player_stats)
	save_file.store_var(Inventory.items)
	save_file.store_var(Inventory.removed_trees_index)
	save_file.store_var(Inventory.removed_rocks_index)
	save_file.close()
	emit_signal("saving", "DATA SAVED")
	
func load_data():
	var save_file = File.new()
	if save_file.file_exists(file_path):
		save_file.open_encrypted_with_pass(file_path,File.READ,my_password)
		Inventory.world_seed = save_file.get_var()
		Inventory.player_stats = save_file.get_var()
		Inventory.items = save_file.get_var()
		Inventory.removed_trees_index = save_file.get_var()
		Inventory.removed_rocks_index = save_file.get_var()
		save_file.close()
		data_loaded = true
		print_data()
		return loaded_data
		
func print_data():
		print(str(Inventory.player_stats))
		print(str(Inventory.items))
		print("Trees Removed: "+ str(Inventory.removed_trees_index))
		print("Rocks_removed: "+ str(Inventory.removed_rocks_index))

func wipe_save():
	Inventory.RESET_DATA()
	var dir = Directory.new()
	if dir.file_exists(file_path):
		dir.remove(file_path)
