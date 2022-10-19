extends Node2D

func _ready():
  var tween = get_node("Tween")
  tween.interpolate_property($TitleGraphicBad, "scale",
          Vector2(0, 0), Vector2(0.8, 0.8), 5,
          Tween.TRANS_BOUNCE, Tween.EASE_OUT)
  tween.start()
