import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'edge.dart';
import 'face.dart';

class Light {
  VectorMath.Vector3 position;

  Light({required this.position});

  Light.base() : this.position = VectorMath.Vector3(-10, -10, -10);

  VectorMath.Vector3 directionTo(Face face) =>
      _centerFace(face)..sub(this.position);

  VectorMath.Vector3 _centerFace(Face face) {
    int amountVertices = 0;
    VectorMath.Vector3 runVector = VectorMath.Vector3.zero();

    for (Edge edge in face.edges) {
      runVector.add(edge.vertices.item1);
      runVector.add(edge.vertices.item2);
      amountVertices += 2;
    }

    return VectorMath.Vector3(
      runVector.x / amountVertices,
      runVector.y / amountVertices,
      runVector.z / amountVertices,
    );
  }
}
