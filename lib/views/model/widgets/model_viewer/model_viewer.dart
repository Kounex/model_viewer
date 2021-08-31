import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'classes/camera.dart';
import 'classes/edge.dart';
import 'classes/face.dart';
import 'classes/light.dart';
import 'classes/model.dart';
import 'model_painter.dart';

class ModelViewer extends StatefulWidget {
  final Model? model;
  final String? objFileName;
  final Camera? camera;
  final Light? light;

  const ModelViewer({
    Key? key,
    this.model,
    this.objFileName,
    this.camera,
    this.light,
  }) : super(key: key);

  @override
  _ModelViewerState createState() => _ModelViewerState();
}

class _ModelViewerState extends State<ModelViewer> {
  late Camera _camera;
  late Light _light;

  late Model _model;

  Future<void> _loadModelFromOBJ(String fileName) async {
    rootBundle.loadString('assets/models/$fileName');

    //TODO: load and parse obj
  }

  @override
  void initState() {
    super.initState();

    _camera = this.widget.camera ?? Camera.base();
    _light = this.widget.light ?? Light.base();

    Model? model = this.widget.model;

    if (this.widget.objFileName != null) {
      _loadModelFromOBJ(this.widget.objFileName!);
    } else {
      _model = model ??
          Model([
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
          ]);
    }

    _camera.setFocusByModel(_model);
  }

  @override
  Widget build(BuildContext context) {
    // print(_camera.position.z);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (moveStart) => setState(() => _camera.moveStart(moveStart)),
      onScaleUpdate: (move) => setState(() => _camera.move(move)),
      onScaleEnd: (moveEnd) => setState(() => _camera.moveEnd(moveEnd)),
      child: Stack(
        children: [
          SizedBox.expand(
            child: Center(
              child: Transform.translate(
                offset: _camera.translation,
                child: Transform.scale(
                  scale: _camera.scale,
                  child: CustomPaint(
                    painter: ModelPainter(
                      camera: _camera,
                      model: _model,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 32.0,
            left: 32.0,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 102.0,
                    child: Text(
                      'Camera\n   x: ${_camera.position.x.toStringAsFixed(2)}\n   y: ${_camera.position.y.toStringAsFixed(2)}\n   z: ${_camera.position.z.toStringAsFixed(2)}',
                    ),
                  ),
                  SizedBox(
                    width: 102.0,
                    child:
                        Text('Scale\n   ${_camera.scale.toStringAsFixed(2)}'),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _camera.reset()),
                    icon: Icon(Icons.restore),
                    label: Text('Reset'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
