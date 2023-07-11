@tool
extends Node2D

var layers: = []
var extra_layers = []
@export var colors = {
	# "layername": Color("HEXCODE")
}
@export var extra_colors = {
	
}
@export var exclude_layers: Array[String] = []
@export var direction: int = 1

@export var age: String = "kitten"
@export var variant: int = 0
@export var marking: String = ""
@export var whitemarking: int = -1
@export var color_palette: int = -1

# Draw order of layers
var render_order: Array[String] = [
	"eyes",
	"nose",
	"line",
	"shadow",
	"whitespot",
	"marking3",
	"marking2",
	"marking1",
	"base"
]

func randomize_cat():
	randomize()
	
	age = SpritesLoader.loaded_sprites.keys().pick_random()
	
	# Make newborns rarer
	while age == "newborn":
		if randf() > 0.99:
			break
		
		age = SpritesLoader.loaded_sprites.keys().pick_random()
	
	age = "kitten" # debug
	
	variant = randi_range(0, len(SpritesLoader.loaded_sprites[age]) - 1)
	variant = [0, 1].pick_random() # debug
	
	direction = [1, 1, 1, -1, -1].pick_random()
	
	var loaded_sprite = SpritesLoader.loaded_sprites[age][variant]
	if len(loaded_sprite["markings"].keys()) > 0:
		marking = loaded_sprite["markings"].keys().pick_random()
	
	var whitemarkings_dir = "%s/%s/%d/whitemarkings" % [SpritesLoader.asset_dir, age, variant+1]
	whitemarking = randi_range(0, len(SpritesLoader.listdirs(whitemarkings_dir)) - 1) if DirAccess.dir_exists_absolute(whitemarkings_dir) else -1
	
	color_palette = randi_range(0, len(SpritesLoader.palettes) - 1)

func filter_null(the_list):
	var new_list = []
	
	for item in the_list:
		if item.get("texture", null) != null:
			new_list.append(item)
	
	return new_list

func load_colors():
	if color_palette >= 0:
		var i = 0
		for layername in ["base", "marking1", "marking2", "marking3", "whitespot"]:
			colors[layername] = SpritesLoader.palettes[color_palette][i]
			
			i += 1

func load_sprite():
	# need to construct a modified sprite w/ the markings and whitemarkings
	var loaded_sprite = SpritesLoader.loaded_sprites[age][variant].duplicate(true)
	layers.clear() # No more eldritch horrors
	
	# Load whitemarkings
	if whitemarking >= 0 and len(loaded_sprite["whitemarkings"]) > 0:
		loaded_sprite["whitespot"] = loaded_sprite["whitemarkings"][whitemarking]["whitespot"]
	
	# Load markings
	if marking != "" and len(loaded_sprite["markings"].keys()) > 0:
		for layer_name in loaded_sprite["markings"][marking].keys():
			loaded_sprite[layer_name] = loaded_sprite["markings"][marking][layer_name]
	
	var render_order_dup = [] + render_order
	# Godot renders high before low (the opposite of layer lists in drawing programs)
	render_order_dup.reverse() 
	
	for key in render_order_dup:
		if key not in exclude_layers:
			layers.append({"name": key, "texture": loaded_sprite.get(key, null)})

func apply_chosen():
	load_sprite()
	load_colors()
	
	for child in get_children():
		child.queue_free()
	
	for texture in filter_null(layers):
		var sprite = Sprite2D.new()
		sprite.texture = texture["texture"]
		sprite.self_modulate = colors.get(texture["name"], sprite.self_modulate)
		
		add_child(sprite)
		
	for texture in filter_null(extra_layers):
		var sprite = Sprite2D.new()
		sprite.texture = texture["texture"]
		sprite.self_modulate = extra_colors.get(texture["name"], sprite.self_modulate)
		
		add_child(sprite)
	
	scale.x = direction

func _ready():
	apply_chosen()

func init():
	randomize_cat()
	
	apply_chosen()
	
func _input(_event):
	if Input.is_action_just_pressed("refresh"):
		_ready()
