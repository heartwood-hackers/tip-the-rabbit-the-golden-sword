extends RigidBody2D


func _on_timeout():
  self.queue_free()
