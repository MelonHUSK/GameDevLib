extends CharacterBody2D

@export var speed = 150
var Acceleration = 25
const Friction = 25
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
enum {
	MOVE,
	ROLL, 
	ATTACK
}
var state = MOVE

func get_input():
	animationTree.active = true
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity += input_direction * Acceleration  
	velocity = velocity.limit_length(speed) 
	input_direction = input_direction.normalized() 
	
	if input_direction == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO, Friction)
		animationState.travel("Idle") 
	else: 
		animationTree.set("parameters/Run/blend_position", input_direction)
		animationTree.set("parameters/Idle/blend_position", input_direction)
		animationTree.set("parameters/Attack/blend_position", input_direction)
		animationState.travel("Run")
		
		if Input.is_action_pressed("ui_attack"):
			state = ATTACK

func _physics_process(_delta):
	match state:
		MOVE:
			get_input()
			move_and_slide()
		ROLL:
			pass
		ATTACK:
			attackState()

func attackState():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE
