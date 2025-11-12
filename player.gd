extends Node2D

var speed = 200
enum Mode {INTERACT, ATTACK}
var current_mode = Mode.INTERACT

func _ready():
	position = Vector2(100, 500)

func _process(delta):
	var direction = Vector2()
	if Input.is_key_pressed(KEY_W):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
	
	position += direction.normalized() * speed * delta

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_LEFT:
				if current_mode == Mode.INTERACT:
					var mouse_pos = get_global_mouse_position()
					var space_state = get_world_2d().direct_space_state
					var results = space_state.intersect_point(mouse_pos)
					for result in results:
						if result.collider.has_method("interact"):
							result.collider.interact()
				elif current_mode == Mode.ATTACK:
					print("Attack!")
			elif event.button_index == BUTTON_WHEEL_UP:
				current_mode = [Mode.INTERACT, Mode.ATTACK][(current_mode + 1) % 2]
				print("Switched to ", current_mode)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				current_mode = [Mode.INTERACT, Mode.ATTACK][(current_mode - 1 + 2) % 2]
				print("Switched to ", current_mode)
