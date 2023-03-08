extends Node2D

func _ready():
  yield($StartTimer, "timeout")

  whoosh()
  var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).set_parallel(true)
  tween.tween_property($TitleGraphicBad, "rotation_degrees", 720.0, 3)
  tween.tween_property($TitleGraphicBad, "scale", Vector2(0.75, 0.75), 3)

  var tween3 = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
  tween3.tween_property($TitleGraphicTip, "position", Vector2(503.0, 30.0), 3)
  tween3.tween_callback(self, "splat")

  tween3.tween_property($TitleGraphicTip, "rotation_degrees", -2000.0, 3).set_ease(Tween.EASE_OUT)
  tween3.set_parallel(true)
  tween3.tween_property($TitleGraphicTip, "position", Vector2(280.0, 46.0), 3).set_trans(Tween.TRANS_LINEAR)
  
  tween3.set_parallel(false)
  tween3.tween_callback(self, "splat")
  tween3.tween_property($TitleGraphicTip, "position", Vector2(0.0, 600.0), 3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
  
  tween3.tween_callback(self, "onwards")
  
func onwards():
  yield(splat(), "finished")
  var _change_status = get_tree().change_scene("res://Game.tscn")

func splat():
  $AudioStreamPlayer.play()
  return $AudioStreamPlayer

func whoosh():
  $AudioStreamPlayer2.play()
