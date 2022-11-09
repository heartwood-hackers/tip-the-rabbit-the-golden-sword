extends RigidBody2D
class_name Character

var rock_scene=preload("res://projectiles/Rock.tscn")
export var damage=0
export var speed=100
export var jump_speed=800
export(int, 1, 4) var player_number

onready var animation_player = $AnimationPlayer

func throw_rock():
  var rock_instance = rock_scene.instance()
  rock_instance.position = $ThrowOrigin.position * (-1 if $Animations.flip_h else 1)
  rock_instance.linear_velocity = Vector2(600,0) * (-1 if $Animations.flip_h else 1)
  add_child(rock_instance)


func _on_attack_body_entered(body):
  if(!body.is_in_group("Characters") or body == self): return # stop hitting yourself
  
  var me_to_you = body.position - self.position
  var unit_mty = me_to_you.normalized()
  body.apply_central_impulse(unit_mty*600)  
  
  
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

  if(right-left != 0):
    state.apply_central_impulse(Vector2(right-left, 0))

  var jumped = pressed("jump", true)
  if(jumped):
    state.apply_central_impulse(Vector2(0, -jump_speed))
  
  state.linear_velocity = Vector2(clamp(state.linear_velocity.x, -400, 400), clamp(state.linear_velocity.y, -400, 400))

func action(action_name: String):
  return "%s%s" % [action_name, player_number]

func strength(action_name: String):
  return Input.get_action_strength(action(action_name))

func pressed(action_name: String, just: bool=false):
  if just: return Input.is_action_just_pressed(action(action_name))
  else: return Input.is_action_pressed(action(action_name))

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
