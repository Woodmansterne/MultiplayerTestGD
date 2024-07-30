extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var id_label: Label = %IDLabel
@onready var camera_2d: Camera2D = %Camera2D

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	position = Vector2(randi_range(32,512),randi_range(32,256))
	
func _ready() -> void:
	sprite_2d.modulate = Color(randf(),randf(),randf(),1)
	id_label.text = "ID: %s" % name
	if is_multiplayer_authority():
		camera_2d.enabled = true
		camera_2d.make_current()
	

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		var direction := Input.get_vector("move_left","move_right","move_up","move_down").normalized()
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
