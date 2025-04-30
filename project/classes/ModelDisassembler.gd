@tool
extends Node
class_name ModelDisassembler



@export var model : Node3D
@export_tool_button("Format Help", "Help") var button_format_help = format_help
@export_tool_button("Disassemble", "ActionCut") var button_disassemble_model = disassemble_model

@export var wheel_connections : Array[Node3D] = []
@export var tire_cages        : Array[Node3D] = []
@export var body_extras       : Array[Node3D] = []
@export var tire_cage_extras  : Array[Array]  = []

var rgx_match_wheelconnection = RegEx.new()

# Match against strings like "TireCage_BL"
var rgx_match_tirecage = RegEx.new()

# Match against strings like "Tire_BL"
var rgx_match_tire = RegEx.new()



func _ready():
	rgx_match_wheelconnection.compile("^wheelconnection_?([a-z][a-z]+)?$")
	rgx_match_tirecage.compile("^tirecage_?([a-z][a-z]+)?$")
	rgx_match_tire.compile("^tire_?([a-z][a-z]+)?$")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func format_help() -> void:
	print("\n\n")
	
	const line_color : String = "web_gray"
	const node3d_color : String = "orange_red"
	
	print_rich("[b]Make sure your model is formatted as such[/b] :")
	
	print()
	
	print_rich("[color="+node3d_color+"][i]Node3D[/i][/color] \"Model\"")
	print_rich(" [color="+line_color+"]╷[/color]")
	print_rich(" [color="+line_color+"]└─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"Body\"")
	print_rich("     [color="+line_color+"]╷[/color]")
	print_rich("     [color="+line_color+"]├─[/color] [color="+node3d_color+"][i]Node3D[/i][/color] \"WheelConnection_BL\"")
	print_rich("     [color="+line_color+"]│   └─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"TireCage_BL\" (or \"TireCage\")")
	print_rich("     [color="+line_color+"]│       ├─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"Tire_BL\" (or \"Tire\")")
	print_rich("     [color="+line_color+"]│       └─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"ExtraTireMesh\" (or \"Tire\")")
	print_rich("     [color="+line_color+"]│[/color]")
	print_rich("     [color="+line_color+"]├─[/color] [color="+node3d_color+"][i]Node3D[/i][/color] \"WheelConnection_BR\"")
	print_rich("     [color="+line_color+"]│   └─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"TireCage_BR\" (or \"TireCage\")")
	print_rich("     [color="+line_color+"]│       └─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"Tire_BR\" (or \"Tire\")")
	print_rich("     [color="+line_color+"]│[/color]")
	print_rich("     [color="+line_color+"]├─[/color] [color="+node3d_color+"][i]Node3D[/i][/color] \"WheelConnection_FL\"")
	print_rich("     [color="+line_color+"]│   └─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"TireCage_FL\" (or \"TireCage\")")
	print_rich("     [color="+line_color+"]│       └─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"Tire_FL\" (or \"Tire\")")
	print_rich("     [color="+line_color+"]│[/color]")
	print_rich("     [color="+line_color+"]├─[/color] [color="+node3d_color+"][i]Node3D[/i][/color] \"WheelConnection_FR\"")
	print_rich("     [color="+line_color+"]│   └─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"TireCage_FR\" (or \"TireCage\")")
	print_rich("     [color="+line_color+"]│       └─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"Tire_FR\" (or \"Tire\")")
	print_rich("     [color="+line_color+"]│[/color]")
	print_rich("     [color="+line_color+"]├─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"ExtraMesh\"")
	print_rich("     [color="+line_color+"]└─[/color] [color="+node3d_color+"][i]MeshInstance3D[/i][/color] \"ExtraMesh2\"")
	
	print("\n\n")

func disassemble_model() -> void:
	print()
	
	wheel_connections.clear()
	tire_cages.clear()
	body_extras.clear()
	tire_cage_extras.clear()
	
	if model == null:
		Racer.error("IMPORT ERROR", "No model given. ABORTING.")
		return
	
	Racer.safe("Disassembling model...")
	
	var model_node : Node3D = model.get_node_or_null("Model")
	
	var model : Node3D = model
	
	if model != null:
		if model_node != null:
			model = model_node
	
	print("Model .. ", model)
	
	var body : MeshInstance3D = model.get_node_or_null("Body")
	
	if body == null:
		Racer.error("FORMAT ERROR", "No Body found in Model node. ABORTING.")
		#print_rich("[color="+Racer.ERROR_COLOR+"]FORMAT ERROR, no Body found in Model node. ABORTING.[/color]")
		return
	
	print("Body .. ", body)
	
	if body.get_child_count() == 0:
		Racer.error("FORMAT ERROR", "No nodes found in Body. Make sure the capitalization of all nodes is correct. ABORTING.")
		return
	
	for child in body.get_children():
		var child_name: String = child.name.to_lower()
		
		#if child_name.begins_with("TireCage_"):
			#tirecages.append(child)
			#print("Tirecage .. ", child)
		if rgx_match_wheelconnection.search(child_name) != null:
			wheel_connections.append(child)
			print("Wheel Connection .. ", child)
		elif rgx_match_tirecage.search(child_name) != null:
			Racer.error("FORMAT ERROR", "TireCages are supposed to be children of a WheelConnection node. Use the \"Format Help\" button. ABORTING.")
			return
		elif rgx_match_tire.search(child_name) != null:
			Racer.error("FORMAT ERROR", "Tire are supposed to be children of a TireCage node. Use the \"Format Help\" button. ABORTING.")
			return
		else:
			body_extras.append(child)
			print("Body Extra .. ", child)
	
	for connection in wheel_connections:
		for child in connection.get_children():
			var child_name : String = child.name.to_lower()
			
			if rgx_match_tirecage.search(child_name) != null:
				tire_cages.append(child)
				print("Wheel Connection -> Tire Cage .. ", child)
				
				continue
	
	#var tirecages : Array[Node3D] = []
	#
	#if len(tirecages) == 0:
		#Racer.error("FORMAT ERROR", "No TireCages found in Body.\nEach Tire should be a child of a TireCage.\nTireCages have their origin at the insertion point of the top rotation joint, but Tires themselves have their own rotation points in their center.\n\nABORTING.")
		#return
	#
	#if len(wheel_connections) == 0:
		#Racer.error("FORMAT ERROR", "No WheelConnections found in Body.\nFor each TireCage, there should be a WheelConnection at the TireCage's rotation origin.\n\nABORTING.")
		#return
	#
	#if len(tirecages) != len(wheel_connections):
		#Racer.error("FORMAT ERROR", ("More" if len(tirecages) > len(wheel_connections) else "Less") + " TireCages than WheelConnections found in Body.\nFor each TireCage, there should be a WheelConnection at the TireCage's rotation origin.\n\nABORTING.")
		#return
