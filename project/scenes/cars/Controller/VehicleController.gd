@tool
extends CharacterBody3D



@export_category("Model")
@export var model : Node3D

@export_group("Wheels", "wheel_")
@export var wheel_back_left_cage   : MeshInstance3D
@export var wheel_back_right_cage  : MeshInstance3D
@export var wheel_front_left_cage  : MeshInstance3D
@export var wheel_front_right_cage : MeshInstance3D

@export_subgroup("Circumferences", "wheel_circumference_")
@export_tool_button("Autocalculate", "CircleShape2D") var wheel_circumference_autocalculate = autocalculate_wheel_circumferences
@export var wheel_circumference_front_left  : float = 0.0 :
	set(value):
		if wheels[0]:
			wheels[0].circumference = value
	get():
		if not wheels[0]:
			return 0.0
		return wheels[0].circumference
@export var wheel_circumference_front_right : float = 0.0 :
	set(value):
		if wheels[1]:
			wheels[1].circumference = value
	get():
		if not wheels[1]:
			return 0.0
		return wheels[1].circumference
@export var wheel_circumference_back_left   : float = 0.0 :
	set(value):
		if wheels[2]:
			wheels[2].circumference = value
	get():
		if not wheels[2]:
			return 0.0
		return wheels[2].circumference
@export var wheel_circumference_back_right  : float = 0.0 :
	set(value):
		if wheels[3]:
			wheels[3].circumference = value
	get():
		if not wheels[3]:
			return 0.0
		return wheels[3].circumference

## FL, FR, BL, BR
var wheels : Array[VehicleWheel] = []



class VehicleWheel:
	var cage : MeshInstance3D
	var circumference : float
	var tire : MeshInstance3D :
		get():
			return cage.get_node("Tire")
	
	func _init(tirecage: MeshInstance3D) -> void:
		cage = tirecage
	
	func autocalculate_circumference() -> void:
		var radius = tire.global_position.y
		circumference = 2*PI*radius


func _ready():
	add_wheel(wheel_front_left_cage)
	add_wheel(wheel_front_right_cage)
	add_wheel(wheel_back_left_cage)
	add_wheel(wheel_back_right_cage)


func _process(delta: float) -> void:
	pass

func add_wheel(tirecage: MeshInstance3D) -> void:
	wheels.append(VehicleWheel.new(tirecage))


func travel_wheel() -> void:
	pass

func autocalculate_wheel_circumferences() -> void:
	if not len(wheels):
		print("No VehicleWheels found in \'wheels\' array.")
		return
	
	print()
	print("Ensure all tires are flat on the ground.")
	
	for i in len(wheels):
		wheels[i]
		wheels[i].autocalculate_circumference()
		print("wheel ", i, " = ", wheels[i].circumference)
	
	print("Calculated.")
