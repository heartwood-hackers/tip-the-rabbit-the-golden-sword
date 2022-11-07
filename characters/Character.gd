extends RigidBody2D
class_name Character

var rock_scene=preload("res://projectiles/Rock.tscn")
export var damage=0
export var speed=400
export var jump_speed=400
export var player_number=1
var previous_velocity
var current_velocity

onready var animation_player = $AnimationPlayer

func throw_rock():
  var rock_instance = rock_scene.instance()
  rock_instance.position = $ThrowOrigin.position * (-1 if $Animations.flip_h else 1)
  rock_instance.linear_velocity = Vector2(600,0) * (-1 if $Animations.flip_h else 1)
  add_child(rock_instance)


func _on_attack_body_entered(body):
  if(body == self): return # stop hitting yourself
  
  print('hit %s' % body)
#  if(body.is_in_group("boundaries")): body._collide_with_character(self)

func _on_body_entered(body):
  if(body.is_in_group("boundaries")): body._collide_with_character(self)

# character collisions off for now
#  if(!body.is_in_group("Characters")): return
#
#  var my_magnitude = self.previous_velocity.length()
#  var body_magnitude = body.previous_velocity.length()
#
#  if(my_magnitude > body_magnitude):
#    body.apply_central_impulse((self.previous_velocity-body.previous_velocity)*2)


func _physics_process(_delta):
  previous_velocity = current_velocity
  current_velocity = self.linear_velocity

func _integrate_forces(state):
  # out of bounds:
  if(position.x > 2000 or position.x < -500 or position.y < -500 or position.y > 1000):
    # respawn
    state.transform.origin = Vector2(100, 100)
    # dampen velocity
    state.linear_velocity /= 4
    return

  var right = strength("move_right")*speed
  var left = strength("move_left")*speed
  var lateral_velocity=linear_velocity.x if (right-left==0) else right-left
  var jumped = pressed("jump", true)
  var up_velocity = -jump_speed if jumped else linear_velocity.y
  
  state.linear_velocity = Vector2(lateral_velocity, up_velocity)

func strength(action: String):
  return Input.get_action_strength("%s%s" % [action, player_number])

func pressed(action: String, just: bool=false):
  return Input.is_action_just_pressed("%s%s" % [action, player_number]) if just else Input.is_action_pressed("%s%s" % [action, player_number])

func _process(_delta):
  if linear_velocity.x < -1:
    $Animations.flip_h = true
    $AttackSprite.flip_h = true
  if linear_velocity.x > 1:
    $Animations.flip_h = false
    $AttackSprite.flip_h = false

  if !animation_player: return

  if $AnimationPlayer.current_animation != "Melee" and $AnimationPlayer.current_animation != "Throw":
    if pressed("move_left") or pressed("move_right"):
      $AnimationPlayer.play("Run")

    if pressed("jump"):
      $AnimationPlayer.play("Lift Off")

    if pressed("attack_melee", true):
      $AnimationPlayer.play("Melee")

    if pressed("attack_range", true):
      $AnimationPlayer.play("Throw")

  if !$AnimationPlayer.is_playing():
    if linear_velocity.y != 0:
      $AnimationPlayer.play("Air Idle")
      $AnimationPlayer.queue("RESET")
    else:
      $AnimationPlayer.play("Idle")
