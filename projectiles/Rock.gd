extends RigidBody2D


func _on_timeout():
  self.queue_free()


func _integrate_forces(state):
  custom_integrator = false
  
  var contact_count = state.get_contact_count()
  if contact_count > 0:
    for contact_number in range(contact_count):
      var target = state.get_contact_collider_object(contact_number)
      
      if target.is_in_group("Characters"):
        custom_integrator = true

        if target != get_parent():
          var me_to_you = self.position-target.position
          var unit_mty = me_to_you.normalized()
          target.apply_central_impulse(unit_mty*200)  
          self.linear_velocity = Vector2(-unit_mty*30)
          target.life -= 10
    self.queue_free()
