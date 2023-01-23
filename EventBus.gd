extends Node


signal player_health_updated(player, new_health, old_health)
signal player_lives_updated(player, new_lives, old_lives)

func _ready():
  # TODO: find better way to suppress warnings
  emit_signal("player_health_updated")
  emit_signal("player_lives_updated")
