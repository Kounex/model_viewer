import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'classes/camera.dart';
import 'model_painter.dart';

class ModelViewer extends StatefulWidget {
  final List<VectorMath.Vector3> vertices;

  const ModelViewer({
    Key? key,
    required this.vertices,
  }) : super(key: key);

  @override
  _ModelViewerState createState() => _ModelViewerState();
}

class _ModelViewerState extends State<ModelViewer> {
  late Camera _camera;

  @override
  void initState() {
    super.initState();

    _camera = Camera.base();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: _camera.move,
        child: CustomPaint(
          painter: ModelPainter(vertices: this.widget.vertices),
          size: Size(100, 100),
        ),
      ),
    );
  }
}
