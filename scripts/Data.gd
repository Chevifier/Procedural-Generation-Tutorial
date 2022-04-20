extends Node


signal get_player_position

var Seed = "world";

var player_stats={
	"hp": 100,
	"position": Vector3(),
	"rotation": Vector3()
}
var items ={
	"wood": 0,
	"rocks": 0
}
var removed_trees =[]
var removed_rocks =[]

func RESET_DATA():
	Seed = "world";

	player_stats={
	"hp": 100,
	"position": Vector3(),
	"rotation": Vector3()
}
	items ={
	"wood": 0,
	"rocks": 0
}
	removed_trees =[]
	removed_rocks =[]
	
	
