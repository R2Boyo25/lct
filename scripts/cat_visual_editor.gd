extends Panel

signal SetCat(cat)
signal Exit(cat)


var DUPFLAGS: int = DUPLICATE_SIGNALS | DUPLICATE_GROUPS | DUPLICATE_SCRIPTS


func _ready():
	$CatEditViewPort.get_child(0).init()
	$CatBackupContainer.add_child($CatEditViewPort.get_child(0).duplicate(DUPFLAGS))
	$Buttons/PanelContainer/Export.get_popup().connect("index_pressed", _on_export_selected)


func _on_set_cat(cat):
	SpritesLoader.replace_and_free($CatEditViewPort.get_child(0), cat.duplicate(DUPFLAGS))
	
	for child in $CatBackupContainer.get_children():
		child.queue_free()
	
	$CatBackupContainer.add_child($CatEditViewPort.get_child(0).duplicate(DUPFLAGS))
	$EditorSplit/Control/VBoxContainer.init()


func _on_cancel_pressed():
	emit_signal("Exit", $CatBackupContainer.get_children()[0].duplicate(DUPFLAGS))


func _on_revert_pressed():
	SpritesLoader.replace_and_free($CatEditViewPort.get_child(0), $CatBackupContainer.get_children()[0].duplicate(DUPFLAGS))
	$EditorSplit/Control/VBoxContainer.init()


func _on_save_pressed():
	emit_signal("Exit", $CatEditViewPort.get_child(0).duplicate(DUPFLAGS))


var save_mode: int = 0


func _on_export_selected(index):
	save_mode = index
	$Control/FileDialog.visible = true


func _on_save_file_selected(path):
	# Texture, JSON
	pass
