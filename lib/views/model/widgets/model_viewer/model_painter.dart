import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'types/classes/camera.dart';
import 'types/classes/edge.dart';
import 'types/classes/face.dart';
import 'types/classes/light.dart';
import 'types/classes/model.dart';
import 'utils/vector.dart';

class ModelPainter extends CustomPainter {
  final Camera camera;
  final Light? light;

  final Model model;

  final bool drawEdges;

  final Color color;
  final bool rainbowColor;

  ModelPainter({
    required this.camera,
    required this.model,
    this.light,
    this.drawEdges = false,
    this.color = Colors.purple,
    this.rainbowColor = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    List<Face> sortedFaces = [...this.model.faces]..sort((f1, f2) =>
        VectorUtils.centerFace(f2)
            .distanceToSquared(this.camera.position)
            .round() -
        VectorUtils.centerFace(f1)
            .distanceToSquared(this.camera.position)
            .round());

    int faceCounter = 0;
    for (Face face in sortedFaces) {
      if (VectorUtils.isFaceVisible(this.camera, face)) {
        Path facePath = Path();

        int lastEdgeIndex = face.edges.length - 1;
        int edgeCounter = 0;
        for (Edge edge in face.edges) {
          Matrix4 matrix = VectorMath.makeViewMatrix(this.camera.position,
              this.camera.focusPosition, VectorMath.Vector3(0, 1, 0));

          VectorMath.Vector3 vertex1 =
              matrix.transform3(edge.vertices.item1.xyz);

          VectorMath.Vector3 vertex2 =
              matrix.transform3(edge.vertices.item2.xyz);

          if (edgeCounter == 0) {
            facePath.moveTo(vertex1.x, vertex1.y);
            facePath.lineTo(vertex2.x, vertex2.y);
          } else if (edgeCounter == lastEdgeIndex) {
            facePath.close();
          } else {
            facePath.lineTo(vertex1.x, vertex1.y);
            facePath.lineTo(vertex2.x, vertex2.y);
          }
          edgeCounter++;
        }

        Color color = !this.rainbowColor
            ? this.color
            : Colors.primaries[faceCounter % Colors.primaries.length];

        if (this.light != null) {
          double darkness = (VectorUtils.calcRadianAngleBetweenVectors(
                      VectorUtils.calcNormVectorForFace(face),
                      this.light!.directionTo(face)) /
                  (pi / 2))
              .abs();

          color = Color.alphaBlend(
            color.withAlpha(darkness >= 1 ? 0 : (255 * (1 - darkness)).floor()),
            Colors.black,
          );
        }

        canvas.drawPath(
          Path()
            ..moveTo(1, 1)
            ..lineTo(2, 3)
            ..lineTo(4, 2)
            ..close(),
          Paint(),
        );

        canvas.drawPath(
          facePath,
          Paint()..color = color,
        );

        if (this.drawEdges)
          canvas.drawPath(
            facePath,
            Paint()..style = PaintingStyle.stroke,
          );
      }
      faceCounter++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
