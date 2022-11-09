extends Control

var input = preload("res://util/input_helper.gd")

# input player number attached to this card
export(int, 1, 4) var player_number = 1

# modes and transitions
enum {Attract, Select, Active}
export var mode = Attract setget _set_mode
func _set_mode(new_mode: int):
  mode = new_mode
  for child in get_children():
    child.visible = false

  if(mode == Attract):
    $AttractMode.visible = true

  elif(mode == Select):
    # TODO: clear any nodes we own
    # initialize the selector portraits
    preview_character()
    $SelectMode.visible = true

  elif(mode == Active):
    $ActiveMode.visible = true


var actions = ["move_right", "move_left", "jump", "attack_melee", "attack_range", "cancel"]
func _ready():
  self.mode = mode

  # register input listeners
  if(player_number == 1 or player_number == 2):
    input.add_player_action(player_number, "move_right", [
      { "device": player_number-1, "axis": JOY_AXIS_0 }
    ])
    input.add_player_action(player_number, "move_left", [
      { "device": player_number-1, "axis": JOY_AXIS_0, "flipped": true }
    ])
    input.add_player_action(player_number, "jump", [
      { "device": player_number-1, "button": JOY_XBOX_A }
    ])
    input.add_player_action(player_number, "attack_melee", [
      { "device": player_number-1, "button": JOY_XBOX_X }
    ])
    input.add_player_action(player_number, "attack_range", [
      { "device": player_number-1, "button": JOY_XBOX_B }
    ])
    input.add_player_action(player_number, "cancel", [
      { "device": player_number-1, "button": JOY_SELECT }
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
    input.add_player_action(player_number, "cancel", [
      { "scancode": KEY_TAB }
    ])

  elif(player_number == 4):
    input.add_player_action(player_number, "move_right", [
      { "scancode": KEY_RIGHT }
    ])
    input.add_player_action(player_number, "move_left", [
      { "scancode": KEY_LEFT }
    ])
    input.add_player_action(player_number, "jump", [
      { "scancode": KEY_UP }, { "scancode": KEY_COMMA }
    ])
    input.add_player_action(player_number, "attack_melee", [
      { "scancode": KEY_SLASH }
    ])
    input.add_player_action(player_number, "attack_range", [
      { "scancode": KEY_PERIOD }
    ])
    input.add_player_action(player_number, "cancel", [
      { "scancode": KEY_SEMICOLON }
    ])


signal select_character(player_number, character_name)
var last_action
var last_action_time = Time.get_ticks_msec()
func _input(event):
  var action = parse_action(event)
  if(!action): return # not ours, bail

  var ready_after = last_action_time + 500
  var this_action_time = Time.get_ticks_msec()
  # throttle rapidly repeated inputs
  if(action == last_action and this_action_time < ready_after): return
  last_action = action
  last_action_time = this_action_time

  # do nothing if active, Character script handles the input
  if(mode == Active):
    # cancel returns to character select
    if(action == "cancel"): self.mode = Select
  
  elif(mode == Attract):
    # anything but cancel starts character select
    if(action != "cancel"): self.mode = Select

  elif(mode == Select):
    if(action == "cancel"): self.mode = Attract

    # left and right: cycle character selector
    elif(action == "move_left"):
      preview_previous_character()
    elif(action == "move_right"):
      preview_next_character()

    # attack or jump selects the character
    elif(action == "jump" or action == "attack_melee" or action == "attack_range"):
      emit_signal("select_character", player_number, current_character())
      self.mode = Active


func parse_action(event):
  for action in actions:
    if(event.is_action("%s%s" % [action, player_number])):
      return action
  
var character_cursor = 0
var characters = ["turtle", "rabbit", "owl"]
func current_character(): return characters[character_cursor]

func preview_previous_character():
  character_cursor = 0 if (character_cursor >= characters.size()-1) else character_cursor + 1
  preview_character()

func preview_next_character():
  character_cursor = characters.size()-1 if (character_cursor <= 0) else character_cursor - 1
  preview_character()

func preview_character():
  var name: String = current_character().capitalize()
  # set the name node
  $SelectMode/MarginContainer/VBoxContainer/HBoxContainer/CharacterName.text = name
  $ActiveMode/MarginContainer/VBoxContainer/CharacterName.text = name
  # set the portrait node
  var portrait_texture = load("res://characters/%s/portrait.png" % name)
  $SelectMode/MarginContainer/VBoxContainer/MarginContainer/CharacterPortrait.texture = portrait_texture
  $ActiveMode/MarginContainer/VBoxContainer/MarginContainer/CharacterPortrait.texture = portrait_texture
  
