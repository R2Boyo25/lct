extends Panel


func _ready():
	$CatViewPort/CatRender.init()


func _on_edit_visuals_pressed():
	$CatEditor.emit_signal("SetCat", $CatViewPort.get_child(0))
	$CatEditor.visible = true


func _on_cat_editor_exit(cat):
	SpritesLoader.replace_and_free($CatViewPort.get_child(0), cat)
	$CatEditor.visible = false
