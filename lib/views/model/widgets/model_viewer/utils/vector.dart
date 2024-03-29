import 'dart:math';

import 'package:vector_math/vector_math_64.dart' as VectorMath;

import '../types/classes/camera.dart';
import '../types/classes/edge.dart';
import '../types/classes/face.dart';

class VectorUtils {
  /// Calculate the center of a face (position)
  static VectorMath.Vector3 centerFace(Face face) {
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

  /// Calculate the norm vector for a face:
  ///   - create 2 direction vectors from the vertices of edges in the given face
  ///   - return the cross prod which is the norm (orthogonal) vector of this face
  static VectorMath.Vector3 calcNormVectorForFace(Face face) {
    VectorMath.Vector3 directionVector1 = face.edges[0].vertices.item2.xyz
      ..sub(face.edges[0].vertices.item1);

    VectorMath.Vector3 directionVector2 = face.edges[1].vertices.item2.xyz
      ..sub(face.edges[1].vertices.item1);

    return directionVector2.cross(directionVector1);
  }

  /// Calculate angle between 2 vectors in radian
  static double calcRadianAngleBetweenVectors(
          VectorMath.Vector3 vector1, VectorMath.Vector3 vector2) =>
      acos((vector1.dot(vector2) / (vector1.length * vector2.length)));

  /// Determines if a face needs to be drawn (is visible from the
  /// given camera position). Basically:
  ///   - take the norm (orthogonal) vector of the given face
  ///   - calculate angle between camera direction vector and the norm vector
  ///   - if the angle is smaller than pi / 2 (90°) its visible and should be drawn
  ///
  /// CAUTION: given faces need to be on the correct side (outside faces)
  static bool isFaceVisible(Camera camera, Face face) {
    VectorMath.Vector3 normVectorFaceToDraw =
        VectorUtils.calcNormVectorForFace(face);
    return VectorUtils.calcRadianAngleBetweenVectors(
                normVectorFaceToDraw, camera.direction)
            .abs() <
        pi / 2;
  }
}
