import 'package:flutter/gestures.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'edge.dart';
import 'face.dart';
import 'light.dart';
import 'model.dart';

class Camera {
  VectorMath.Vector3 position;
  late VectorMath.Vector3 initialPosition;
  late VectorMath.Vector3 focusPosition;
  double scale = 15.0;
  double initialScale = 15.0;
  Offset translation = Offset.zero;

  double _scaleRun = 1.0;

  ScaleUpdateDetails? _scaleUpdateRun;

  Camera(this.position)
      : initialPosition = VectorMath.Vector3.copy(position),
        focusPosition = VectorMath.Vector3.zero();

  Camera.base() : this(VectorMath.Vector3(10, 10, -10));

  VectorMath.Vector3 get direction =>
      VectorMath.Vector3.copy(this.focusPosition)..sub(this.position);

  void reset() {
    this.position = VectorMath.Vector3.copy(this.initialPosition);
    this.scale = this.initialScale;
    this.translation = Offset.zero;
  }

  void setFocusByModel(Model model) {
    int amountVertices = 0;
    VectorMath.Vector3 runVector = VectorMath.Vector3.zero();
    for (Face face in model.faces) {
      for (Edge edge in face.edges) {
        runVector.add(edge.vertices.item1);
        runVector.add(edge.vertices.item2);
        amountVertices += 2;
      }
    }
    this.focusPosition = VectorMath.Vector3(
      runVector.x / amountVertices,
      runVector.y / amountVertices,
      runVector.z / amountVertices,
    );
  }

  void moveStart(ScaleStartDetails moveStart) {
    this._scaleRun = 1.0;
  }

  void move(ScaleUpdateDetails move, [Light? light, bool rotateLight = false]) {
    if (move.pointerCount == 1 && _scaleUpdateRun != null) {
      Offset moveOffset = move.focalPoint - _scaleUpdateRun!.focalPoint;

      if (moveOffset.distanceSquared > 0) {
        VectorMath.Quaternion rotationQ = VectorMath.Quaternion.euler(
            moveOffset.dx / 100, moveOffset.dy / 100, 0);

        if (light == null || rotateLight)
          this.position.applyQuaternion(rotationQ);

        if (light != null) light.position.applyQuaternion(rotationQ);
      }
    }
    if (move.pointerCount == 2) {
      double deltaScale = move.scale - this._scaleRun;

      this.scale += deltaScale * 5;
      // this.position.scale(deltaScale);

      this._scaleRun = move.scale;
    }
    if (move.pointerCount == 3 && _scaleUpdateRun != null) {
      Offset moveOffset = move.focalPoint - _scaleUpdateRun!.focalPoint;

      this.translation += moveOffset;
      // this.position.add(VectorMath.Vector3(moveOffset.dx, moveOffset.dy, 0));
    }
    _scaleUpdateRun = move;
  }

  void moveEnd(ScaleEndDetails moveEnd) {
    this._scaleRun = 1.0;
    _scaleUpdateRun = null;
  }
}
