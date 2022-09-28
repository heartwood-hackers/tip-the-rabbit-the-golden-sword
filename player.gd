extends RigidBody2D

func _integrate_forces(_state):
  var right = Input.get_action_strength("move_right")*400
  var left = Input.get_action_strength("move_left")*400
  
  var jumped = Input.is_action_just_pressed("jump")
  var up_velocity = -400.0 if jumped else linear_velocity.y
  
  if(jumped): print("jumped!", up_velocity)

  linear_velocity = Vector2(right-left, up_velocity)
  
#  if right > 0:
#    linear_velocity = Vector2(right*700, 0)
#
#  elif left > 0:
#    linear_velocity = Vector2(left*-700, 0)
#
#  else:
#    linear_velocity = Vector2()
