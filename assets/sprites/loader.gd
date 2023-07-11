extends Node

const asset_dir: String = "res://assets/sprites"


func replace_and_free(replace: Node, by: Node):
	var parent = replace.get_parent()

	parent.remove_child(replace)
	parent.add_child(by)
	
	replace.propagate_call("queue_free")


func listfiles(dirpath: String):
	return DirAccess.get_files_at(dirpath)
	
func listdirs(dirpath: String):
	return DirAccess.get_directories_at(dirpath)

func _load(path: String):
	if not FileAccess.file_exists(path):
		return null
	
	return load(path)

func is_ext(filepath: String, ext: String):
	return filepath.get_extension().to_lower() == ext
	
func get_not_ext(files: Array[String], ext: String):
	var tmp = []
	
	for file in files:
		if not is_ext(file, ext):
			tmp.append(file)
			
	return tmp
	
func get_ext(files: Array[String], ext: String):
	var tmp = []
	
	for file in files:
		if is_ext(file, ext):
			tmp.append(file)
			
	return tmp

func sorted(the_list):
	var dup = [] + Array(the_list)
	
	dup.sort()
	
	return dup

func load_assets(age: String, amount: int):
	var tmp_assets = []
	
	for i in range(1, amount+1):
		var tmp_dict = {"markings":{}, "whitemarkings":[]}
		var basepath = "%s/%s/%d/" % [asset_dir, age, i]
		
		for file in get_ext(listfiles(basepath), "png"):
			tmp_dict[file.get_file().split(".")[0]] = _load(basepath + file)
		
		var markings_dir = basepath + "markings"
		if DirAccess.dir_exists_absolute(markings_dir):
			for dir in listdirs(markings_dir):
				var marking_dict = {}
				
				var marking_dir = "%s/%s/" % [markings_dir, dir]
				for file in get_ext(listfiles(marking_dir), "png"):
					marking_dict[file.get_file().split(".")[0]] = _load(marking_dir + file)
				
				tmp_dict["markings"][dir] = marking_dict
		
		var whitemarkings_dir = basepath + "whitemarkings"
		if DirAccess.dir_exists_absolute(whitemarkings_dir):
			for dir in sorted(listdirs(whitemarkings_dir)):
				var whitemarking_dict = {}
				
				var whitemarking_dir = "%s/%s/" % [whitemarkings_dir, dir]
				for file in get_ext(listfiles(whitemarking_dir), "png"):
					whitemarking_dict[file.get_file().split(".")[0]] = _load(whitemarking_dir + file)
				
				tmp_dict["whitemarkings"].append(whitemarking_dict)
		
		tmp_assets.append(tmp_dict)
		
	return tmp_assets

var ages = listdirs(asset_dir)

func load_all(ages_to_load):
	var temp_dict = {}
	
	for age in ages_to_load:
		temp_dict[age] = load_assets(age, len(listdirs("%s/%s/" % [asset_dir, age])))
		
	return temp_dict

var loaded_sprites = load_all(ages)

func load_palette(image: Image, i):
	var colors = []
	
	for j in range(5):
		colors.append(image.get_pixel(1 + i * 6, 1 + j * 6))
	
	return colors

func load_palettes():
	var palette = load("%s/palettes.png" % asset_dir)
	
	var palette_size = palette.get_size()
	var palette_count = (palette_size.x - 1) / 6
	
	var tmp_palettes = []
	
	for i in range(0, palette_count):
		tmp_palettes.append(load_palette(palette, i))
		
	return tmp_palettes

var palettes = load_palettes()

func _ready():
	pass
	#print(JSON.stringify(loaded_sprites, "   "))
