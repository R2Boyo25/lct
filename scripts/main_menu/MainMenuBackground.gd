@tool
extends TextureRect


var background_images = [
	"background_berries.png",
	"background_rock.png",
	"background_tree.png"
]

const asset_dir = "res://assets/main_menu/"

func _ready():
	texture = load(asset_dir + background_images.pick_random())

func _input(_event):
	if Input.is_action_just_pressed("refresh"):
		var selected_image = load(asset_dir + background_images.pick_random())
	
		while selected_image == texture:
			selected_image = load(asset_dir + background_images.pick_random())
			
		texture = selected_image
	
	elif Input.is_action_just_pressed("fullscreen"):
		$/root.mode = Window.MODE_FULLSCREEN if $/root.mode != Window.MODE_FULLSCREEN else Window.MODE_WINDOWED
