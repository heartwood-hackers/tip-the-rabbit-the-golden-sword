extends RigidBody2D
class_name Character

export(Vector2) var rock_speed = Vector2(600,0)
var rock_scene=preload("res://projectiles/Rock.tscn")
signal damaged(player_number, health)
export var health=100 setget _set_health
func _set_health(new_health):
  health = new_health
  $Animations.rotation_degrees = health - 100
  emit_signal("damaged", player_number, health)
  
signal lost_life(player_number, lives)
export var lives = 3
export var ground_acceleration = 100
export var jump_speed = 1000

export var max_ground_speed = 500
export var max_air_speed = 1500
export(int, 1, 4) var player_number

var number_of_jumps = 0

onready var animation_player = $AnimationPlayer

func throw_rock():
  var rock_instance = rock_scene.instance()
  rock_instance.position = $ThrowOrigin.position * (-1 if $Animations.flip_h else 1)
  rock_instance.linear_velocity = rock_speed * (-1 if $Animations.flip_h else 1)
  add_child(rock_instance)


func _on_body_entered(body):
  if(body.is_in_group("floor")):
    number_of_jumps = 0

func _on_attack_body_entered(body):
  if(!body.is_in_group("Characters") or body == self): return # stop hitting yourself
  
  var me_to_you = body.position - self.position
  var unit_mty = me_to_you.normalized()
  body.apply_central_impulse(unit_mty*600)
  
  body.health -= 10
  
  
func respawn(state):
  self.health = 100
  # respawn
  state.transform.origin = Vector2(100, 100)
  # dampen velocity
  state.linear_velocity /= 4
    
  
func _integrate_forces(state):
  # out of bounds:
  if(health <= 0 or position.x > 2000 or position.x < -500 or position.y < -500 or position.y > 1000):
    if(health <= 0):
      lives -= 1
      emit_signal("lost_life", player_number, lives)
      

    if(lives > 0):
      self.respawn(state)
    else:
      self.queue_free()
    return

  var right = strength("move_right") * ground_acceleration
  var left = strength("move_left") * ground_acceleration

  if(right-left != 0):
    state.apply_central_impulse(Vector2(right-left, 0))

  var pressed_jump = pressed("jump", true)
  if(pressed_jump and number_of_jumps < 2):
    # do jump routine
    state.linear_velocity.y = -jump_speed * (1 if number_of_jumps == 0 else .8)
    number_of_jumps += 1
  
  # enforce maximum speeds
  state.linear_velocity = Vector2(
    clamp(state.linear_velocity.x, -max_ground_speed, max_ground_speed),
    clamp(state.linear_velocity.y, -max_air_speed, max_air_speed))


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
