import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/classes/face.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/classes/light.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/utils/vector.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'classes/camera.dart';
import 'classes/edge.dart';

class ModelPainter extends CustomPainter {
  final Camera camera;
  final Light? light;

  final List<Face> faces;

  ModelPainter({
    required this.camera,
    required this.faces,
    this.light,
  });

  @override
  void paint(Canvas canvas, Size size) {
    int faceCounter = 0;
    for (Face face in this.faces) {
      if (VectorUtils.isFaceVisible(this.camera, face)) {
        Path facePaths = Path();

        int lastEdgeIndex = face.edges.length - 1;
        int edgeCounter = 0;
        for (Edge edge in face.edges) {
          Matrix4 matrix = VectorMath.makeViewMatrix(this.camera.position,
              VectorMath.Vector3.zero(), VectorMath.Vector3(0, 1, 0));

          VectorMath.Vector3 vertex1 =
              matrix.transform3(VectorMath.Vector3.copy(edge.vertices.item1));
          VectorMath.Vector3 vertex2 =
              matrix.transform3(VectorMath.Vector3.copy(edge.vertices.item2));

          if (edgeCounter == 0) {
            facePaths.moveTo(vertex1.x, vertex1.y);
          } else if (edgeCounter == lastEdgeIndex) {
            facePaths.close();
          } else {
            facePaths.lineTo(vertex1.x, vertex1.y);
            facePaths.lineTo(vertex2.x, vertex2.y);
          }
          edgeCounter++;
        }

        canvas.drawPath(
          facePaths,
          Paint()..color = Colors.primaries[faceCounter],
        );
        faceCounter++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
