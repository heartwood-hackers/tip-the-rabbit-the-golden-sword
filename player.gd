extends RigidBody2D

export var speed=400
export var jump_speed=400
export var player_number=1

func _integrate_forces(state):
  var right = Input.get_action_strength("move_right%s"%player_number)*speed
  var left = Input.get_action_strength("move_left%s"%player_number)*speed
  var lateral_velocity=linear_velocity.x if (right-left==0) else right-left
  var jumped = Input.is_action_just_pressed("jump%s"%player_number)
  var up_velocity = -jump_speed if jumped else linear_velocity.y
  
  state.linear_velocity = Vector2(lateral_velocity, up_velocity)
