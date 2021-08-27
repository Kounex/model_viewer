import 'package:flutter/gestures.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/utils/vector.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

class Camera {
  VectorMath.Vector3 position;
  late VectorMath.Vector3 initialPosition;
  double scale = 10.0;

  double _scaleRun = 1.0;
  ScaleUpdateDetails? _scaleUpdateRun;

  Camera(this.position) : initialPosition = VectorMath.Vector3.copy(position);

  Camera.base() : this(VectorMath.Vector3(-5, -5, -5));

  void moveStart(ScaleStartDetails moveStart) {
    this._scaleRun = 1.0;
  }

  void move(ScaleUpdateDetails move) {
    if (move.pointerCount == 1 && _scaleUpdateRun != null) {
      print('1 Touch');
      // this.position.ad
      // VectorMath.Vector3.zero().distanceToSquared(this.position);
    }
    if (move.pointerCount == 2) {
      // print('2 Touch');
      double deltaScale = move.scale - this._scaleRun;

      this.scale += deltaScale * 3;
      // this.position.scale(deltaScale);

      this._scaleRun = move.scale;
    }
    if (move.pointerCount == 3 && _scaleUpdateRun != null) {
      print('3 Touch');
      Offset moveOffset = move.focalPoint - _scaleUpdateRun!.focalPoint;
      this.position.add(VectorMath.Vector3(moveOffset.dx, moveOffset.dy, 0));
      print(this.position);
    }
    _scaleUpdateRun = move;
  }

  void moveEnd(ScaleEndDetails moveEnd) {
    this._scaleRun = 1.0;
    _scaleUpdateRun = null;
  }
}
