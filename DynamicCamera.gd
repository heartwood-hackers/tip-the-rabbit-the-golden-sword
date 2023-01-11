extends Camera2D

func zoom_to_extents(extents:Rect2):
#  print("zooming to %s" % extents)
  position = Vector2(extents.position.x + extents.size.x/2, extents.position.y + extents.size.y/2)
  var viewport_size = self.get_viewport().size
  # what ratio to zoom to in order to view all characters
  var zoom_ratio = max((extents.size.x+300) / viewport_size.x, (extents.size.y+300) / viewport_size.y)
  zoom = Vector2(1,1)*clamp(zoom_ratio, 1, 4)
