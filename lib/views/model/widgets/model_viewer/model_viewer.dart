import 'package:flutter/material.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/classes/face.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'classes/camera.dart';
import 'classes/edge.dart';
import 'classes/light.dart';
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
  late Light _light;

  late List<Face> _faces;

  @override
  void initState() {
    super.initState();

    _camera = Camera.base();
    _light = Light.base();

    _faces = [
      Face(
        [
          Edge(
            VectorMath.Vector3(0, 0, 0),
            VectorMath.Vector3(10, 0, 0),
          ),
          Edge(
            VectorMath.Vector3(10, 0, 0),
            VectorMath.Vector3(10, 10, 0),
          ),
          Edge(
            VectorMath.Vector3(10, 10, 0),
            VectorMath.Vector3(0, 10, 0),
          ),
          Edge(
            VectorMath.Vector3(0, 10, 0),
            VectorMath.Vector3(0, 0, 0),
          ),
        ],
      ),
      Face(
        [
          Edge(
            VectorMath.Vector3(0, 0, 10),
            VectorMath.Vector3(10, 0, 10),
          ),
          Edge(
            VectorMath.Vector3(10, 0, 10),
            VectorMath.Vector3(10, 0, 0),
          ),
          Edge(
            VectorMath.Vector3(10, 0, 0),
            VectorMath.Vector3(0, 0, 0),
          ),
          Edge(
            VectorMath.Vector3(0, 0, 0),
            VectorMath.Vector3(0, 0, 10),
          ),
        ],
      ),
      Face(
        [
          Edge(
            VectorMath.Vector3(0, 10, 10),
            VectorMath.Vector3(10, 10, 10),
          ),
          Edge(
            VectorMath.Vector3(10, 10, 10),
            VectorMath.Vector3(10, 0, 10),
          ),
          Edge(
            VectorMath.Vector3(10, 0, 10),
            VectorMath.Vector3(0, 0, 10),
          ),
          Edge(
            VectorMath.Vector3(0, 0, 10),
            VectorMath.Vector3(0, 10, 10),
          ),
        ],
      ),
      Face(
        [
          Edge(
            VectorMath.Vector3(0, 10, 0),
            VectorMath.Vector3(10, 10, 0),
          ),
          Edge(
            VectorMath.Vector3(10, 10, 0),
            VectorMath.Vector3(10, 10, 10),
          ),
          Edge(
            VectorMath.Vector3(10, 10, 10),
            VectorMath.Vector3(0, 10, 10),
          ),
          Edge(
            VectorMath.Vector3(0, 10, 10),
            VectorMath.Vector3(0, 10, 0),
          ),
        ],
      ),
      Face(
        [
          Edge(
            VectorMath.Vector3(10, 0, 0),
            VectorMath.Vector3(10, 0, 10),
          ),
          Edge(
            VectorMath.Vector3(10, 0, 10),
            VectorMath.Vector3(10, 10, 10),
          ),
          Edge(
            VectorMath.Vector3(10, 10, 10),
            VectorMath.Vector3(10, 10, 0),
          ),
          Edge(
            VectorMath.Vector3(10, 10, 0),
            VectorMath.Vector3(10, 0, 0),
          ),
        ],
      ),
      Face(
        [
          Edge(
            VectorMath.Vector3(0, 0, 10),
            VectorMath.Vector3(0, 0, 0),
          ),
          Edge(
            VectorMath.Vector3(0, 0, 0),
            VectorMath.Vector3(0, 10, 0),
          ),
          Edge(
            VectorMath.Vector3(0, 10, 0),
            VectorMath.Vector3(0, 10, 10),
          ),
          Edge(
            VectorMath.Vector3(0, 10, 10),
            VectorMath.Vector3(0, 0, 10),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // print(_camera.position.z);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (moveStart) => setState(() => _camera.moveStart(moveStart)),
      onScaleUpdate: (move) => setState(() => _camera.move(move)),
      onScaleEnd: (moveEnd) => setState(() => _camera.moveEnd(moveEnd)),
      child: SizedBox.expand(
        child: Center(
          child: Transform.scale(
            scale: _camera.scale,
            child: CustomPaint(
              painter: ModelPainter(
                camera: _camera,
                faces: _faces,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
