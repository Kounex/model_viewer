import 'dart:math';

import 'package:vector_math/vector_math_64.dart' as VectorMath;

import '../types/classes/camera.dart';
import '../types/classes/face.dart';

class VectorUtils {
  // static VectorMath.Vector3 calcNormVector(VectorMath.Vector3 vector) {
  //   VectorMath.Vector3 anotherNotParallelVector = VectorMath.Vector3.
  // }

  /// Calculate the norm vector for a face:
  ///   - create 2 direction vectors from the vertices of edges in the given face
  ///   - return the cross prod which is the norm (orthogonal) vector of this face
  static VectorMath.Vector3 calcNormVectorForFace(Face face) {
    VectorMath.Vector3 directionVector1 =
        VectorMath.Vector3.copy(face.edges[0].vertices.item2)
          ..sub(face.edges[0].vertices.item1);

    VectorMath.Vector3 directionVector2 =
        VectorMath.Vector3.copy(face.edges[1].vertices.item2)
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
