@tool
extends Node



const SAFE_COLOR : String = "deep_sky_blue"
const ERROR_COLOR : String = "firebrick"



func _ready():
	# runs in game and editor.
	pass
	
	if Engine.is_editor_hint():
		# runs in only editor.
		pass
		
		return
	
	# runs only in game.
	pass



func _process(delta: float) -> void:
	pass

static func safe(text: String):
	print_rich("[color="+Racer.SAFE_COLOR+"]"+text+"[/color]")

static func error(err_name: String, err_text: String):
	print_stack()
	print_rich("[color="+Racer.ERROR_COLOR+"]["+err_name+"] "+err_text+"[/color]")
