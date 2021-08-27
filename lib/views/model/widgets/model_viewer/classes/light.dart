import 'package:vector_math/vector_math_64.dart' as VectorMath;

class Light {
  VectorMath.Vector3 position;

  Light({required this.position});

  Light.base() : this.position = VectorMath.Vector3(-100, -100, -100);
}