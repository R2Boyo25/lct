extends VBoxContainer

func update_cat():
	%CatEditViewPort.get_child(0).apply_chosen()

func update_variant():
	$Variantbox/Variant.max_value = len(SpritesLoader.loaded_sprites[%CatEditViewPort.get_child(0).age]) - 1
	$Variantbox/Variant.tick_count = $Variantbox/Variant.max_value + 1
	
	$Variantbox/Variant.value = %CatEditViewPort.get_child(0).variant
	
	update_whitemarking()
	update_marking()

func update_whitemarking():
	$Whitemarkingbox/Whitemarking.max_value = len(SpritesLoader.loaded_sprites[%CatEditViewPort.get_child(0).age][%CatEditViewPort.get_child(0).variant]["whitemarkings"]) - 1
	$Whitemarkingbox/Whitemarking.tick_count = $Variantbox/Variant.max_value + 1 
	
	$Whitemarkingbox/Whitemarking.value = %CatEditViewPort.get_child(0).whitemarking if %CatEditViewPort.get_child(0).whitemarking != -1 else 0
	
	$Whitemarkingbox/CheckButton.button_pressed = %CatEditViewPort.get_child(0).whitemarking >= 0
	
func update_marking():
	$MarkingBox/Marking.clear()
	
	for marking in SpritesLoader.loaded_sprites[%CatEditViewPort.get_child(0).age][%CatEditViewPort.get_child(0).variant]["markings"]:
		$MarkingBox/Marking.add_item(marking)
		
	set_optionbox_selection(%CatEditViewPort.get_child(0).marking, $MarkingBox/Marking)

func update_colors():
	$Palette/Palette.max_value = len(SpritesLoader.palettes) - 1
	$Palette/Palette.tick_count = $Palette/Palette.max_value + 1
	
	$Palette/Palette.value = %CatEditViewPort.get_child(0).color_palette if %CatEditViewPort.get_child(0).color_palette != -1 else 0
	
	var i = 0
	for color in SpritesLoader.palettes[%CatEditViewPort.get_child(0).color_palette]:
		$Colors.get_children()[i].color = color
		
		i += 1

func init():
	$Agebox/Age.clear()
	
	for age in SpritesLoader.ages:
		$Agebox/Age.add_item(age)
	
	set_optionbox_selection(%CatEditViewPort.get_child(0).age, $Agebox/Age)
	update_variant()
	update_colors()
	$DirectionBox/Direction.button_pressed = %CatEditViewPort.get_child(0).direction != 1
	$ShadingBox/Shading.button_pressed = "shadow" in %CatEditViewPort.get_child(0).exclude_layers

func _ready():
	%CatEditViewPort.get_child(0).init()
	
	init()

func set_optionbox_selection(value, box):
	for item in range(box.item_count):
		if box.get_item_text(item) == value:
			box.select(item)
			
			break

func _on_age_item_selected(index):
	%CatEditViewPort.get_child(0).age = $Agebox/Age.get_item_text(index)
	%CatEditViewPort.get_child(0).variant = 0
	
	update_variant()
	update_cat()

func _on_variant_value_changed(value):
	%CatEditViewPort.get_child(0).variant = value
	
	update_whitemarking()
	update_marking()
	update_cat()


func _on_marking_item_selected(index):
	%CatEditViewPort.get_child(0).marking = $MarkingBox/Marking.get_item_text(index)
	
	update_cat()


func _on_whitemarking_value_changed(value):
	if $Whitemarkingbox/CheckButton.button_pressed:
		%CatEditViewPort.get_child(0).whitemarking = value
	
	update_cat()


func _on_whitemarking_toggled(button_pressed):
	%CatEditViewPort.get_child(0).whitemarking = $Whitemarkingbox/Whitemarking.value if button_pressed else -1
	
	update_cat()


func _on_direction_toggled(button_pressed):
	%CatEditViewPort.get_child(0).direction = -1 if button_pressed else 1
	
	update_cat()


func _on_palette_value_changed(value):
	%CatEditViewPort.get_child(0).color_palette = value
	
	update_cat()
	update_colors()


func _on_shading_toggled(button_pressed):
	%CatEditViewPort.get_child(0).exclude_layers.clear()
	
	if button_pressed:
		%CatEditViewPort.get_child(0).exclude_layers.append("shadow")
	
	update_cat()


func _on_randomize_pressed():
	%CatEditViewPort.get_child(0).randomize_cat()
	update_cat()
	_ready()
