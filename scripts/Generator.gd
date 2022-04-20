extends Spatial
export var Seed : String = "World"
var current_seed : int = 0
export(PackedScene) var rock;
export var rock_count = 30
export(PackedScene) var tree;
export var tree_count = 50
export var world_size = 700
export var subdivisions = 20
export var max_hill_height = 50
onready var Player = $Player
onready var House = $House
onready var terrain = $Terrain
onready var col_shape = $Terrain/StaticBody/CollisionShape


var col_margin = 5
var MIN_X=-world_size/2 + col_margin
var MAX_X=world_size/2- col_margin
var MIN_Z=-world_size/2+ col_margin
var MAX_Z=world_size/2- col_margin

var complete_land = false
var offset = Vector3(0,1.5,0)

func _ready():
	current_seed = Data.Seed.hash()
	seed(current_seed)
	generate_land()

func _process(delta):
	if complete_land:
		generate_trees()
		generateRocks()
		place_player()
		place_house()
		set_process(false)
		complete_land = false



func generate_land():
	var noiseTex = ImageTexture.new()
	var osnoise = OpenSimplexNoise.new()
	var amesh = ArrayMesh.new()
	var pmesh = PlaneMesh.new()
	pmesh.size = Vector2(world_size,world_size)
	pmesh.subdivide_width = subdivisions*2
	pmesh.subdivide_depth = subdivisions*2
	osnoise.seed = Data.Seed.hash()
	osnoise.octaves = 2
	osnoise.period = 64.0
	osnoise.persistence = 0.5
	osnoise.lacunarity = 0.1
	var image = osnoise.get_seamless_image(world_size)
	noiseTex.create_from_image(image)
	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,pmesh.surface_get_arrays(0))
	terrain.mesh = amesh
	var land_material : ShaderMaterial = terrain.get_active_material(0)
	land_material.set_shader_param("hills",noiseTex)
	land_material.set_shader_param("max_hill_height",max_hill_height)
	var hms = HeightMapShape.new()
	hms.map_width = world_size
	hms.map_depth = world_size
	var float_array = []
	image.lock()
	for y in image.get_height():
		for x in image.get_width():
			var pix = image.get_pixel(x, y).r*max_hill_height
			float_array.append(pix)
	image.unlock()
	hms.map_data = float_array
	col_shape.shape = hms
	complete_land = true
	
	
	
	
	
	
	
	
	
	
	
	
	
func place_player():
	var pos = Vector3(rand_range(MIN_X,MAX_X),200,rand_range(MIN_Z,MAX_Z))
	var fnl_pos = get_down_raycast(pos)
	if Data.player_stats["position"] != Vector3():
		Player.global_transform.origin = Data.player_stats["position"]
		Player.camera_h.rotation_degrees = Data.player_stats["rotation"]
	else:
		Player.global_transform.origin = fnl_pos + offset


func generate_trees():
	var trees_placed = 0
	var tree_index
	for i in tree_count:
		var pos = Vector3(rand_range(MIN_X,MAX_X),100,rand_range(MIN_Z,MAX_Z))
		var fnl_pos = get_down_raycast(pos)
		var rot = Vector3(0,rand_range(0,360),0)
		for index in Data.removed_trees:
			if index == i:
				tree_index = index
				break
		if tree_index == i:
			continue
		if fnl_pos != Vector3.ZERO:
			var treei = tree.instance()
			add_child(treei)
			treei.index = i
			treei.transform.origin = fnl_pos
			treei.rotation_degrees = rot
	
func generateRocks():
	var rocks_placed = 0
	var rock_index = 0
	for i in tree_count:
		var pos = Vector3(rand_range(MIN_X,MAX_X),200,rand_range(MIN_Z,MAX_Z));
		var fnl_pos = get_down_raycast(pos)
		var rot = Vector3(0,rand_range(0,360),0)
		#Using Saved Data to determine spawn
		for index in Data.removed_rocks:
			if index == i:
				rock_index = index
				break
		if rock_index == i:
			continue
		if fnl_pos != Vector3.ZERO:
			var rocki = rock.instance()
			rocki.index = i
			add_child(rocki)
			rocki.transform.origin = fnl_pos
			rocki.rotation_degrees = rot
	

func place_house():
	var pos = Vector3(rand_range(MIN_X,MAX_X),200,rand_range(MIN_Z,MAX_Z))
	var fnl_pos = get_down_raycast(pos)
	var rot = Vector3(0,rand_range(0,360),0)
	House.transform.origin = fnl_pos
	House.rotation_degrees = rot

func get_down_raycast(pos):
	var length = 1000;
	var to = Vector3(pos.x,pos.y-length,pos.z)
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(pos,to)
	if result:
		return result.position
	else:
		return pos


	
