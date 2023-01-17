extends AnimationPlayer

export var character_resource: Resource


func _ready():
  print(self.get_animation_list())

  set_animation_texture("Air Idle", "jump_sprite")
  set_animation_texture("Idle", "idle_sprite")
  set_animation_texture("Land", "jump_sprite")
  set_animation_texture("Lift Off", "jump_sprite")
  set_animation_texture("Melee", "melee_sprite")
  set_animation_texture("RESET", "reset_sprite")
  set_animation_texture("Run", "run_sprite")
  set_animation_texture("Throw", "throw_sprite")


func set_animation_texture(animation_name, resource_getter):
  var animation: Animation = get_animation(animation_name)
  var texture_track = animation.find_track("Animations:texture")
  animation.track_set_key_value(texture_track, 0, character_resource.get(resource_getter))
