import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'classes/camera.dart';
import 'classes/edge.dart';
import 'classes/face.dart';
import 'classes/light.dart';
import 'classes/model.dart';
import 'utils/vector.dart';

class ModelPainter extends CustomPainter {
  final Camera camera;
  final Light? light;

  final Model model;

  ModelPainter({
    required this.camera,
    required this.model,
    this.light,
  });

  @override
  void paint(Canvas canvas, Size size) {
    int faceCounter = 0;
    for (Face face in this.model.faces) {
      if (VectorUtils.isFaceVisible(this.camera, face)) {
        Path facePath = Path();

        int lastEdgeIndex = face.edges.length - 1;
        int edgeCounter = 0;
        for (Edge edge in face.edges) {
          Matrix4 matrix = VectorMath.makeViewMatrix(this.camera.position,
              this.camera.focusPosition, VectorMath.Vector3(0, 1, 0));

          VectorMath.Vector3 vertex1 =
              matrix.transform3(VectorMath.Vector3.copy(edge.vertices.item1));
          VectorMath.Vector3 vertex2 =
              matrix.transform3(VectorMath.Vector3.copy(edge.vertices.item2));

          if (edgeCounter == 0) {
            facePath.moveTo(vertex1.x, vertex1.y);
          } else if (edgeCounter == lastEdgeIndex) {
            facePath.close();
          } else {
            facePath.lineTo(vertex1.x, vertex1.y);
            facePath.lineTo(vertex2.x, vertex2.y);
          }
          edgeCounter++;
        }

        canvas.drawPath(
          facePath,
          Paint()..color = Colors.primaries[faceCounter],
        );
      }
      faceCounter++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
