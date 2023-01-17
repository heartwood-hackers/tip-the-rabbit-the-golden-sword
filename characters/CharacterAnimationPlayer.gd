extends AnimationPlayer

export var character_resource: Resource

var animation_sprite_map = [
  ["Air Idle", "jump_sprite"],
  ["Idle", "idle_sprite"],
  ["Land", "jump_sprite"],
  ["Lift Off", "jump_sprite"],
  ["Melee", "melee_sprite"],
  ["RESET", "reset_sprite"],
  ["Run", "run_sprite"],
  ["Throw", "throw_sprite"]
]


func _ready():
  for pair in animation_sprite_map:
    set_animation_texture(pair[0], pair[1])


func set_animation_texture(animation_name, resource_getter):
  var animation: Animation = get_animation(animation_name).duplicate()
  var texture_track = animation.find_track("Animations:texture")
  animation.track_set_key_value(texture_track, 0, character_resource.get(resource_getter))
  remove_animation(animation_name)
  var _ignore = add_animation(animation_name, animation)
