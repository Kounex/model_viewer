import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

class ModelPainter extends CustomPainter {
  final List<VectorMath.Vector3> vertices;

  ModelPainter({required this.vertices});

  @override
  void paint(Canvas canvas, Size size) {
    Vertices vertices = Vertices(VertexMode.triangles, [
      Offset(0, 0),
      Offset(size.width, size.height / 2),
      Offset(0, size.height),
    ]);
    canvas.drawVertices(
      vertices,
      BlendMode.color,
      Paint()..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
