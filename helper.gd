class_name Helper
extends CharacterBody3D

signal button_pressed(color)

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var press_button_timer = $PressButtonTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var should_jump = false
var can_press_button = true
var is_jumping = false
var assigned_color: PatternManager.PatternColor

func jump():
	await get_tree().create_timer(1).timeout
	should_jump = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		is_jumping = false

	# Handle Jump.
	if should_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		should_jump = false
		is_jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector3.ZERO
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	handle_collisions()

func handle_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var object = collision.get_collider()
		if object is PatternButton and can_press_button and is_jumping:
			button_pressed.emit(object.color_name)
			can_press_button = false
			press_button_timer.start()

func _on_press_button_timer_timeout():
	can_press_button = true
