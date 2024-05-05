@tool
extends EditorPlugin

var button = Button.new()
var HeightmapGenerator = preload("generator.gd")

func _enter_tree() -> void:
	# Add node type
	add_custom_type(
		"Heightmap Generator", 
		"Node3D",
		HeightmapGenerator, 
		preload("icon.png")
	)
	
	# Add button to execute generator
	button.text = "Generate Heightmap"
	button.connect("pressed", _on_button_pressed)
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, button)
	button.hide()


func _exit_tree() -> void:
	# Remove node type
	remove_custom_type("Heightmap Generator")

	# Remove button
	remove_control_from_container(CONTAINER_SPATIAL_EDITOR_MENU, button)
	button.free()


func _on_button_pressed() -> void:
	var selected_nodes = get_editor_interface().get_selection().get_selected_nodes()
	if selected_nodes.size() > 0:
		var selected = selected_nodes[0]
		if selected and selected.get_script() == HeightmapGenerator:
			selected.generate_heightmap()


## From Godot docs:
## Implement this function if your plugin edits a specific type of object (Resource or Node).
## If you return true, then you will get the functions _edit and _make_visible called when the
## editor requests them. If you have declared the methods _forward_canvas_gui_input and
## _forward_3d_gui_input these will be called too. Note: Each plugin should handle only one
## type of objects at a time. If a plugin handes more types of objects and they are edited at
## the same time, it will result in errors.
func _handles(object):
	return object.get_script() == HeightmapGenerator


## From Godot docs:
## This function is used for plugins that edit specific object types (nodes or resources).
## It requests the editor to edit the given object. object can be null if the plugin was
## editing an object, but there is no longer any selected object handled by this plugin.
## It can be used to cleanup editing state.
func _edit(object):
	if object and object.get_script() == HeightmapGenerator:
		button.show()
	else:
		button.hide()
