extends CharacterBody3D

@export var walk_speed := 6.3
@export var sprint_speed := 10.5
@export var acceleration := 22.0
@export var air_acceleration := 6.0
@export var jump_velocity := 7.2
@export var mouse_sensitivity := 0.0018
@export var touch_sensitivity := 0.0026

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var pitch := 0.0
var touch_move := Vector2.ZERO
var touch_jump := false
var spawn_position := Vector3(-55.0, 1.25, 0.0)
var last_safe_position := spawn_position

func _ready() -> void:
    if not OS.has_feature("mobile"):
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    var controls := get_node_or_null("../UI/TouchControls")
    if controls:
        controls.move_changed.connect(_on_touch_move)
        controls.look_delta.connect(_on_touch_look)
        controls.jump_pressed.connect(_on_touch_jump)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        _rotate_view(event.relative, mouse_sensitivity)
    elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    elif event is InputEventMouseButton and event.pressed and not OS.has_feature("mobile"):
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        if velocity.y < 0.0:
            velocity.y = -0.2
        if global_position.y > -8.0:
            last_safe_position = global_position

    if Input.is_action_just_pressed("jump") or touch_jump:
        if is_on_floor():
            velocity.y = jump_velocity
        touch_jump = false

    var kb := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var input_vec := kb
    if touch_move.length() > input_vec.length():
        input_vec = Vector2(touch_move.x, touch_move.y)

    var forward := -global_transform.basis.z
    var right := global_transform.basis.x
    forward.y = 0.0
    right.y = 0.0
    forward = forward.normalized()
    right = right.normalized()
    var desired_dir := (right * input_vec.x + forward * -input_vec.y)
    if desired_dir.length_squared() > 1.0:
        desired_dir = desired_dir.normalized()

    var speed := sprint_speed if Input.is_action_pressed("sprint") else walk_speed
    var desired := desired_dir * speed
    var accel := acceleration if is_on_floor() else air_acceleration
    velocity.x = move_toward(velocity.x, desired.x, accel * delta)
    velocity.z = move_toward(velocity.z, desired.z, accel * delta)

    move_and_slide()

    if global_position.y < -180.0 or Input.is_action_just_pressed("reset_position"):
        _reset_to_safe()

func _rotate_view(delta_pixels: Vector2, sensitivity: float) -> void:
    rotate_y(-delta_pixels.x * sensitivity)
    pitch = clamp(pitch - delta_pixels.y * sensitivity, deg_to_rad(-88.0), deg_to_rad(88.0))
    head.rotation.x = pitch

func _on_touch_move(value: Vector2) -> void:
    touch_move = value

func _on_touch_look(value: Vector2) -> void:
    _rotate_view(value, touch_sensitivity)

func _on_touch_jump() -> void:
    touch_jump = true

func _reset_to_safe() -> void:
    global_position = last_safe_position + Vector3.UP * 0.6
    velocity = Vector3.ZERO
