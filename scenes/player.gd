extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 0.25
const DECELERATION = 0.1

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var id_label: Label = %IDLabel
@onready var camera_2d: Camera2D = %Camera2D

@onready var status_label: Label = %StatusLabel
@onready var game_hud: Control = %GameHUD

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	position = Vector2(randi_range(32,512),randi_range(32,256))
	
func _ready() -> void:
	sprite_2d.modulate = Color(randf(),randf(),randf(),1)
	id_label.text = "ID: %s" % name
	if is_multiplayer_authority():
		camera_2d.enabled = true
		camera_2d.make_current()
	
	
##Controls and shit
func update_movement():
	var direction := Input.get_vector("move_left","move_right","move_up","move_down").normalized()
	if direction:
		velocity = lerp(velocity,direction * SPEED,ACCELERATION)
	else:
		velocity = lerp(velocity,Vector2.ZERO,DECELERATION)
		#velocity.x = move_toward(velocity.x, 0, DECELERATION)
		#velocity.y = move_toward(velocity.y, 0, DECELERATION)

func update_mouse_look():
	if get_window().has_focus():
		look_at(get_global_mouse_position())
	
func update_camera():
	if get_window().has_focus():
		var mousePos = get_global_mouse_position()
		var dist = clamp((position-mousePos).length() / 2.0,8,192)
		var newAngle = int(rad_to_deg(rotation)) % 360 ##Modulo doesnt work with floats??????
		camera_2d.position = Vector2(
			position.x + dist * cos(deg_to_rad(newAngle)),
			position.y + dist * sin(deg_to_rad(newAngle))
		)
	
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		status_label.text = Globals.GameStatus
	else:
		game_hud.visible = false
	
func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		update_movement()
		update_mouse_look()
		update_camera()

	move_and_slide()
