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
  character_node.connect("damaged", self, "_character_damaged")
  add_child(character_node)


func _on_Player1Card_unselect_character(player_number):
  for child in get_children():
    if(child.name == "SpawnPoints"): continue
    if child.player_number == player_number:
      remove_child(child)

signal update_life(character, life)
func _character_damaged(character, life):
  emit_signal("update_life", character, life)
