extends Node2D

export(PackedScene) var level

func _ready():
  if(!level):
    var rng = RandomNumberGenerator.new()
    rng.randomize()
    var level_num = rng.randi_range(0, 1)

    if level_num == 0:
      level = load("res://levels/cyberpunk_street/CyberpunkStreet.tscn")
    elif level_num == 1:
      level = load("res://levels/glacial_mountain/GlacialMountain.tscn")
  
  var level_instance = level.instance()
  $Level.add_child(level_instance)
