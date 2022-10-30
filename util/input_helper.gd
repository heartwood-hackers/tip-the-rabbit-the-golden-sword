extends Node


static func add_player_action(player_number, action_name, events):
  var player_action = "%s%s" % [action_name, player_number]
  InputMap.add_action(player_action)
  
  for event in events:
    if !event: continue # allow sparse event lists, prettier dsl

    var input_event
    if event.has("device"):
      if event.has("axis"):
        input_event = InputEventJoypadMotion.new()
        input_event.axis = event["axis"]
      elif event.has("button"):
        input_event = InputEventJoypadButton.new()
        input_event.button_index = event["button"]
      else:
        printerr("Bad input: %s %s %s" % [player_number, action_name, event])
      input_event.device = event["device"]
    
    elif event.has("scancode"):
      input_event = InputEventKey.new()
      input_event.scancode = event["scancode"]
    else:
      printerr("Bad input: %s %s %s" % [player_number, action_name, event])

    if input_event:
      InputMap.action_add_event(player_action, input_event)
