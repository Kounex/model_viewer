import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/types/enums/base_color.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/widgets/camera_light_bar.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/widgets/properties_bar.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'types/classes/camera.dart';
import 'types/classes/edge.dart';
import 'types/classes/face.dart';
import 'types/classes/light.dart';
import 'types/classes/model.dart';
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

  Future<Model>? _model;

  bool _useLight = false;
  bool _drawEdges = false;

  bool _rotateLight = false;
  bool _lightFromCamera = false;

  bool _rainbowColor = false;
  Color _color = BaseColor.indigo.color;

  bool _fullscreen = false;

  Future<Model> _loadModelFromOBJ(String fileName) async {
    String objString = await rootBundle.loadString('assets/models/$fileName');

    List<String> objSnippets = objString.split('\n');

    List<VectorMath.Vector3> vertices = [];
    List<Face> faces = [];

    for (int i = 0; i < objSnippets.length; i++) {
      String snippet = objSnippets[i].trim();

      if (snippet.startsWith('v ')) {
        List<String> vertex = snippet.split(' ');
        vertices.add(VectorMath.Vector3(double.parse(vertex[1]),
            double.parse(vertex[2]), double.parse(vertex[3])));
      }

      if (snippet.startsWith('f ')) {
        List<String> face = snippet.split(' ');
        List<Edge> edges = [];

        for (int j = 1; j < face.length; j++) {
          edges.add(Edge(
              vertices[int.parse(face[j].split('/')[0]) - 1],
              vertices[int.parse(
                      face[j < face.length - 1 ? j + 1 : 1].split('/')[0]) -
                  1]));
        }

        faces.add(Face(edges));
      }
    }

    return Model(faces);
  }

  @override
  void initState() {
    super.initState();

    _camera = this.widget.camera ?? Camera.base();
    _light = this.widget.light ?? Light.base();

    Model? model = this.widget.model;

    if (this.widget.objFileName != null) {
      _model = _loadModelFromOBJ(this.widget.objFileName!);
    } else {
      _model = SynchronousFuture(model ??
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
          ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (moveStart) => setState(() => _camera.moveStart(moveStart)),
      onScaleUpdate: (move) => setState(() => _camera.move(
          move,
          _useLight && (_rotateLight || _lightFromCamera) ? _light : null,
          _lightFromCamera)),
      onScaleEnd: (moveEnd) => setState(() => _camera.moveEnd(moveEnd)),
      onDoubleTap: () => setState(() => _fullscreen = !_fullscreen),
      child: Stack(
        children: [
          FutureBuilder<Model>(
            future: _model,
            builder: (context, modelSnapshot) {
              if (modelSnapshot.connectionState == ConnectionState.done) {
                if (modelSnapshot.hasData) {
                  _camera.setFocusByModel(modelSnapshot.data!);

                  return SizedBox.expand(
                    child: Center(
                      child: Transform.translate(
                        offset: _camera.translation,
                        child: Transform.scale(
                          scale: _camera.scale,
                          child: CustomPaint(
                            painter: ModelPainter(
                              camera: _camera,
                              light: _useLight ? _light : null,
                              drawEdges: _drawEdges,
                              model: modelSnapshot.data!,
                              color: _color,
                              rainbowColor: _rainbowColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: Text(
                      'Error loading model\n\n${modelSnapshot.error!.toString()}'),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          if (!_fullscreen)
            Positioned(
              top: 24.0,
              left: 24.0,
              child: SafeArea(
                child: CameraLightBar(
                  camera: _camera,
                  light: _light,
                  useLight: _useLight,
                  onChangedUseLight: (value) =>
                      setState(() => _useLight = value!),
                  onReset: () => setState(() => _camera.reset()),
                ),
              ),
            ),
          if (!_fullscreen)
            Positioned(
              bottom: 18.0,
              left: 18.0,
              child: SafeArea(
                child: PropertiesBar(
                  rotateLight: _rotateLight,
                  lightFromCamera: _lightFromCamera,
                  drawEdges: _drawEdges,
                  useRainbowColor: _rainbowColor,
                  color: _color,
                  onChangedRotateLight: (value) => setState(() {
                    _rotateLight = value!;
                    if (_rotateLight) _lightFromCamera = false;
                  }),
                  onChangedLightFromCamera: _useLight
                      ? (value) => setState(() {
                            _lightFromCamera = value!;
                            if (_lightFromCamera) {
                              _rotateLight = false;
                              _light.position =
                                  VectorMath.Vector3.copy(_camera.position);
                            }
                          })
                      : null,
                  onChangedDrawEdges: (value) =>
                      setState(() => _drawEdges = value!),
                  onChangedUseRainbowColor: (value) =>
                      setState(() => _rainbowColor = value!),
                  onChangedColor: (color) => setState(() => _color = color!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
