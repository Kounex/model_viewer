import 'package:flutter/gestures.dart';
import 'package:vector_math/vector_math.dart';

class Camera {
  Vector3 position;

  Camera(this.position);

  Camera.base() : this.position = Vector3(0, 0, 200);

  void move(DragUpdateDetails drag) {}
}
