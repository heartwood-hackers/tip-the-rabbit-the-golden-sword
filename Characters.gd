extends Node2D

onready var spawn_points = $SpawnPoints.get_children()
func _character_selected(player_number: int, character_name: String):
#  print("player %s chose %s" %[player_number, character_name])
  
  var character_scene = load("res://characters/%s/%s.tscn" % [character_name, character_name.capitalize()])
  var character_node = character_scene.instance()
  character_node.player_number = player_number
  var spawn_point = get_node("SpawnPoints/SpawnPoint%s"%player_number)
  character_node.position = spawn_point.position
  print(character_node, position)
  add_child(character_node)
