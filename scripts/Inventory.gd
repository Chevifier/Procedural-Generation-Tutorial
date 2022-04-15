extends Node
#connect to player to get position when saving
#emit right before saving
signal update_player_position

var world_seed = "World";
var player_stats={
	"hp":100,
	"hunger":0,
	"thirst":0,
	"stamina":100,
	"saved_pos": Vector3(0,0,0),
	"saved_rotation": Vector3(0,0,0)
	
}

var items = {
	"wood": 0,
	"rocks": 0
}

var removed_trees_index = []
var removed_rocks_index = []


func RESET_DATA():
	items= {
	"wood": 0,
	"rocks": 0
	}
	player_stats={
	"hp": 100,
	"hunger": 0,
	"thirst":0,
	"stamina":100,
	"saved_pos": Vector3(0,0,0),
	"saved_rotation": Vector3(0,0,0)
	}
	removed_rocks_index = []
	removed_trees_index = []
	
