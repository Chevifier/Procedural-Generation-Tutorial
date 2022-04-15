extends Spatial


export var Seed : String = "World"
var current_seed : int = 0

export(PackedScene) var rock;
export var rock_count = 30
export(PackedScene) var tree;
export var tree_count = 50
export(Material) var land_material
export var world_size = 700
export var subdivisions = 20
export var max_height = 10
onready var Player = $Player
onready var House = $House
onready var terrain = $Terrain

const MIN_X=-150
const MAX_X=150
const MIN_Z=-150
const MAX_Z=150

var complete_land = false
var offset = Vector3(0,1.5,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	#draw_wireframe()
	current_seed =  Inventory.world_seed.hash()
	seed(current_seed)
	#print(current_seed)
	generateWorld()
	place_player()
	place_house()
	
func place_player():
	var pos = Vector3(rand_range(MIN_X,MAX_X),100,rand_range(MIN_Z,MAX_Z))
	var fnl_pos = get_down_raycast(pos)
	if Inventory.player_stats["saved_pos"] != Vector3():
		Player.global_transform.origin = Inventory.player_stats["saved_pos"]
		Player.camera_h.rotation_degrees = Inventory.player_stats["saved_rotation"]
	else:
		Player.global_transform.origin = fnl_pos + offset
	
	
func generateRocks():
	var rocks_placed = 0
	var rock_index = 0
	for i in tree_count:
		var pos = Vector3(rand_range(MIN_X,MAX_X),100,rand_range(MIN_Z,MAX_Z));
		var fnl_pos = get_down_raycast(pos)
		var rot = Vector3(0,rand_range(0,360),0)
		#Using Saved Data to determine spawn
		for index in Inventory.removed_rocks_index:
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
	
func _process(delta):
	if complete_land:
		generate_trees()
		generateRocks()
		set_process(false)
		complete_land = false
		
func place_house():
	var pos = Vector3(rand_range(MIN_X,MAX_X),100,rand_range(MIN_Z,MAX_Z))
	var fnl_pos = get_down_raycast(pos)
	var rot = Vector3(0,rand_range(0,360),0)
	House.transform.origin = fnl_pos
	House.rotation_degrees = rot
	
func generate_trees():
	var trees_placed = 0
	var tree_index
	for i in tree_count:
		var pos = Vector3(rand_range(MIN_X,MAX_X),100,rand_range(MIN_Z,MAX_Z))
		var fnl_pos = get_down_raycast(pos)
		var rot = Vector3(0,rand_range(0,360),0)
		for index in Inventory.removed_trees_index:
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
	

func generateWorld():
	var amesh = ArrayMesh.new()
	var mesh = PlaneMesh.new()
	mesh.size =Vector2(world_size,world_size)
	mesh.subdivide_depth = subdivisions
	mesh.subdivide_width = subdivisions
	amesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,mesh.get_mesh_arrays())
	amesh.surface_set_material(0,land_material)
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(amesh,0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		vertex.y += randf()* max_height
		mdt.set_vertex(i,vertex)
	for face in mdt.get_face_count():
			# Set the face's normal as the normal for one of its points
		var vertex = mdt.get_face_vertex(face, 0)
		var normal = mdt.get_face_normal(face)
		mdt.set_vertex_normal(vertex, normal)
	amesh.surface_remove(0)
	mdt.commit_to_surface(amesh)
	terrain.mesh = amesh
	terrain.create_trimesh_collision()
	complete_land = true

func get_down_raycast(pos):
	var length = 1000;
	var to = Vector3(pos.x,pos.y-length,pos.z)
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(pos,to)
	if result:
		return result.position
	else:
		return Vector3.ZERO

func draw_wireframe():
	VisualServer.set_debug_generate_wireframes(true)
	get_viewport().debug_draw=Viewport.DEBUG_DRAW_WIREFRAME
