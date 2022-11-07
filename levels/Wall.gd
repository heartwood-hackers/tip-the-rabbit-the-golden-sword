extends Area2D

func _collide_with_character(character: Character):
  var lateral_velocity = character.linear_velocity.x
  character.apply_central_impulse(Vector2(-lateral_velocity*.75, -80))


func _on_body_entered(body):
  if(body.is_in_group("Characters")):
    _collide_with_character(body as Character)
