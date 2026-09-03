extends Control

signal move_changed(value: Vector2)
signal look_delta(value: Vector2)
signal jump_pressed

var left_touch_id := -1
var right_touch_id := -1
var left_origin := Vector2.ZERO
var left_current := Vector2.ZERO
var right_last := Vector2.ZERO
var move_value := Vector2.ZERO
var joystick_radius := 92.0
var jump_radius := 62.0
var touch_ui_visible := false

func _ready() -> void:
    touch_ui_visible = OS.has_feature("mobile") or DisplayServer.is_touchscreen_available()
    set_process_input(touch_ui_visible)
    queue_redraw()

func _notification(what: int) -> void:
    if what == NOTIFICATION_RESIZED:
        queue_redraw()

func _input(event: InputEvent) -> void:
    if not touch_ui_visible:
        return
    if event is InputEventScreenTouch:
        _handle_touch(event)
    elif event is InputEventScreenDrag:
        _handle_drag(event)

func _handle_touch(event: InputEventScreenTouch) -> void:
    if event.pressed:
        if _inside_jump(event.position):
            jump_pressed.emit()
            return
        if event.position.x < size.x * 0.46 and left_touch_id == -1:
            left_touch_id = event.index
            left_origin = event.position
            left_current = event.position
            move_value = Vector2.ZERO
            move_changed.emit(move_value)
            queue_redraw()
        elif right_touch_id == -1:
            right_touch_id = event.index
            right_last = event.position
    else:
        if event.index == left_touch_id:
            left_touch_id = -1
            move_value = Vector2.ZERO
            move_changed.emit(move_value)
            queue_redraw()
        elif event.index == right_touch_id:
            right_touch_id = -1

func _handle_drag(event: InputEventScreenDrag) -> void:
    if event.index == left_touch_id:
        left_current = event.position
        var delta := left_current - left_origin
        if delta.length() > joystick_radius:
            delta = delta.normalized() * joystick_radius
            left_current = left_origin + delta
        move_value = delta / joystick_radius
        move_changed.emit(move_value)
        queue_redraw()
    elif event.index == right_touch_id:
        var delta := event.position - right_last
        right_last = event.position
        look_delta.emit(delta)

func _inside_jump(point: Vector2) -> bool:
    return point.distance_to(_jump_center()) <= jump_radius * 1.35

func _jump_center() -> Vector2:
    return Vector2(size.x - 104.0, size.y - 116.0)

func _draw() -> void:
    if not touch_ui_visible:
        return
    var base_center := left_origin if left_touch_id != -1 else Vector2(118.0, size.y - 128.0)
    var knob_center := left_current if left_touch_id != -1 else base_center
    draw_circle(base_center, joystick_radius, Color(1, 1, 1, 0.055))
    draw_arc(base_center, joystick_radius, 0.0, TAU, 64, Color(1, 1, 1, 0.16), 2.0)
    draw_circle(knob_center, 34.0, Color(1, 1, 1, 0.15))
    var jc := _jump_center()
    draw_circle(jc, jump_radius, Color(1, 1, 1, 0.07))
    draw_arc(jc, jump_radius, 0.0, TAU, 48, Color(1, 1, 1, 0.22), 2.0)
    draw_string(ThemeDB.fallback_font, jc + Vector2(-9, 7), "↑", HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color(1, 1, 1, 0.55))
