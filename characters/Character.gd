extends RigidBody2D
class_name Character

export var damage=0
export var speed=400
export var jump_speed=400
export var player_number=1
var previous_velocity
var current_velocity

func _on_body_entered(body):
  if(body.is_in_group("boundaries")): body._collide_with_character(self)

  if(!body.is_in_group("Characters")): return

  var my_magnitude = self.previous_velocity.length()
  var body_magnitude = body.previous_velocity.length()
  
  if(my_magnitude > body_magnitude):
    body.apply_central_impulse((self.previous_velocity-body.previous_velocity)*2)


func _physics_process(_delta):
  previous_velocity = current_velocity
  current_velocity = self.linear_velocity

func _integrate_forces(state):
  var right = Input.get_action_strength("move_right%s"%player_number)*speed
  var left = Input.get_action_strength("move_left%s"%player_number)*speed
  var lateral_velocity=linear_velocity.x if (right-left==0) else right-left
  var jumped = Input.is_action_just_pressed("jump%s"%player_number)
  var up_velocity = -jump_speed if jumped else linear_velocity.y
  
  state.linear_velocity = Vector2(lateral_velocity, up_velocity)

func _process(_delta):
  if $Animations:
    if linear_velocity.x < -1:
      $Animations.flip_h = true
    if linear_velocity.x > 1:
      $Animations.flip_h = false

#  if !$AnimationPlayer: return
#
#  if $AnimationPlayer.current_animation != "Melee" and $AnimationPlayer.current_animation != "Throw":
#    if Input.is_action_pressed("move_left2") or Input.is_action_pressed("move_right2"):
#      $AnimationPlayer.play("Run")
#
#    if Input.is_action_just_pressed("jump2"):
#      $AnimationPlayer.play("Lift Off")
#
#    if Input.is_action_just_pressed("attack_melee2"):
#      $AnimationPlayer.play("Melee")
#
#    if Input.is_action_just_pressed("attack_range2"):
#      $AnimationPlayer.play("Throw")
#
#  if !$AnimationPlayer.is_playing():
#    if linear_velocity.y != 0:
#      $AnimationPlayer.play("Air Idle")
#    else:
#      $AnimationPlayer.play("Idle")
