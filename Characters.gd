extends Node2D

onready var spawn_points = $SpawnPoints.get_children()
onready var camera = $DynamicCamera
func _process(_delta):
  var character_extents = get_character_position_extents()
  camera.zoom_to_extents(character_extents)

func get_character_position_extents():
  var minimum
  var maximum
  for child in get_children():
    if(child.name == "SpawnPoints" or child.name == "DynamicCamera"): continue
    if !minimum: minimum = child.position
    if !maximum: maximum = child.position
    if minimum.x > child.position.x: minimum.x = child.position.x
    if minimum.y > child.position.y: minimum.y = child.position.y
    if maximum.x < child.position.x: maximum.x = child.position.x
    if maximum.y < child.position.y: maximum.y = child.position.y
  
  if minimum:
    return Rect2(minimum, maximum-minimum)
  else:
    return Rect2(0, 0, 800, 600)

func _character_selected(player_number: int, character_name: String):
  var spawn_point = get_node("SpawnPoints/SpawnPoint%s"%player_number)
  var character_scene_path = "res://characters/%s/%s.tscn" % [character_name, character_name.capitalize()]
  var character = load(character_scene_path).instance()

  character.player_number = player_number
  character.position = spawn_point.position
  character.connect("damaged", self, "_character_damaged")
  character.connect("lost_life", self, "_character_died")

  add_child(character)


func _on_unselect_character(player_number):
  for child in get_children():
    if(child.name == "SpawnPoints" or child.name == "DynamicCamera"): continue
    if child.player_number == player_number:
      child.queue_free()


signal update_health(character, health)
func _character_damaged(character, health):
  emit_signal("update_health", character, health)


signal update_lives(character, lives)
func _character_died(character, lives):
  emit_signal("update_lives", character, lives)
