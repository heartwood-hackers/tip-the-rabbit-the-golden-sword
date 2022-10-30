extends Control

var input = preload("res://util/input_helper.gd")

# input player number attached to this card
export(int, 1, 4) var player_number = 1

# modes and transitions
enum {Attract, Select, Active}
export var mode = Attract
func _set_mode(new_mode: int):
  mode = new_mode
  for child in get_children():
    child.visible = false

  if(mode == Attract):
    $AttractMode.visible = true
  elif(mode == Select):
    $SelectMode.visible = true
  elif(mode == Active):
    $ActiveMode.visible = true

func _ready():
  self._set_mode(mode)

  # register input listeners
  if(player_number == 1 or player_number == 2):
    input.add_player_action(player_number, "move_right", [
      { "device": player_number, "axis": -JOY_AXIS_1 }
    ])
    input.add_player_action(player_number, "move_left", [
      { "device": player_number, "axis": JOY_AXIS_1 }
    ])
    input.add_player_action(player_number, "jump", [
      { "device": player_number, "button": JOY_XBOX_A }
    ])
    input.add_player_action(player_number, "attack_melee", [
      { "device": player_number, "button": JOY_XBOX_X }
    ])
    input.add_player_action(player_number, "attack_range", [
      { "device": player_number, "button": JOY_XBOX_B }
    ])

  elif(player_number == 3):
    input.add_player_action(player_number, "move_right", [
      { "scancode": KEY_D }
    ])
    input.add_player_action(player_number, "move_left", [
      { "scancode": KEY_A }
    ])
    input.add_player_action(player_number, "jump", [
      { "scancode": KEY_W }, { "scancode": KEY_V }
    ])
    input.add_player_action(player_number, "attack_melee", [
      { "scancode": KEY_B }
    ])
    input.add_player_action(player_number, "attack_range", [
      { "scancode": KEY_N }
    ])

  elif(player_number == 4):
    input.add_player_action(player_number, "move_right", [
      { "scancode": KEY_RIGHT }
    ])
    input.add_player_action(player_number, "move_left", [
      { "scancode": KEY_LEFT }
    ])
    input.add_player_action(player_number, "jump", [
      { "scancode": KEY_UP }
    ])
    input.add_player_action(player_number, "attack_melee", [
      { "scancode": KEY_SLASH }
    ])
    input.add_player_action(player_number, "attack_range", [
      { "scancode": KEY_PERIOD }
    ])

func _input(_param):
  # TODO: change to select mode upon input in attract mode
  pass
