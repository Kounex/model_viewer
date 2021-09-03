import 'package:vector_math/vector_math_64.dart' as VectorMath;

import '../../utils/vector.dart';
import 'face.dart';

class Light {
  VectorMath.Vector3 position;

  Light({required this.position});

  Light.base() : this.position = VectorMath.Vector3(-10, -10, -10);

  VectorMath.Vector3 directionTo(Face face) =>
      VectorUtils.centerFace(face)..sub(this.position);
}
