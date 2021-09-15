import 'package:vector_math/vector_math_64.dart' as VectorMath;

import '../../utils/vector.dart';
import 'face.dart';

class Light {
  VectorMath.Vector3 position = VectorMath.Vector3.zero();
  VectorMath.Vector3 initialPosition = VectorMath.Vector3.zero();

  Light(this.position) {
    initialPosition.xyz = position.xyz;
  }

  Light.base() : this(VectorMath.Vector3(-100, -100, -100));

  VectorMath.Vector3 directionTo(Face face) =>
      VectorUtils.centerFace(face)..sub(this.position);

  void reset() {
    this.position.xyz = this.initialPosition.xyz;
  }

  void setInitialPosition(VectorMath.Vector3 position) {
    this.position.xyz = position.xyz;
    this.initialPosition.xyz = position.xyz;
  }
}
