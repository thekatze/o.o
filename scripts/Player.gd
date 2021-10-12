extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var m_velocity = Vector2.ZERO;
var m_animation_tree: AnimationTree;
var m_animation_state: AnimationNodeStateMachinePlayback;


const MaxSpeed = 500;
const Accelleration = MaxSpeed * 17;
const Friction = MaxSpeed * 15;

# Called when the node enters the scene tree for the first time.
func _ready():
	m_animation_tree = get_node("AnimationTree");
	m_animation_state = m_animation_tree.get("parameters/playback");

func _physics_process(delta):
	var input_vector = Vector2.ZERO;
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
	
	if input_vector != Vector2.ZERO:
		m_animation_tree.set("parameters/idle/blend_position", input_vector.x);
		m_animation_tree.set("parameters/walk/blend_position", input_vector.x);

		m_animation_state.travel("walk");

		m_velocity = (m_velocity + input_vector.normalized() * Accelleration * delta).clamped(MaxSpeed);
	else:
		m_animation_state.travel("idle");
		m_velocity = m_velocity.move_toward(Vector2.ZERO, Friction * delta);
	
	
	var _discard = move_and_slide(m_velocity);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
