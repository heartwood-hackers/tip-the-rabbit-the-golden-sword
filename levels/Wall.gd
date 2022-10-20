extends RigidBody2D

func _collide_with_character(character: Character):
  character.apply_central_impulse(Vector2(0, -80))
