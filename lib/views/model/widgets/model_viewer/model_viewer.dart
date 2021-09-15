import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'types/classes/camera.dart';
import 'types/classes/edge.dart';
import 'types/classes/face.dart';
import 'types/classes/light.dart';
import 'types/classes/model.dart';
import 'widgets/model_wrapper.dart';

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

  Model _baseCube() => Model(
        [
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
        ],
      );

  VectorMath.Vector3 _initialCameraPosition(Model model) {
    double highestZ = 0;

    for (Face face in model.faces) {
      for (Edge edge in face.edges) {
        highestZ = max(highestZ,
            max(edge.vertices.item1.z.abs(), edge.vertices.item2.z.abs()));
      }
    }

    return VectorMath.Vector3(0, 0, -highestZ);
  }

  void _setupCameraAndLight(Model model) {
    if (this.widget.camera == null)
      _camera.setInitialPosition(_initialCameraPosition(model));
    if (this.widget.light == null)
      _light.setInitialPosition(_camera.position.xyz
        ..applyQuaternion(VectorMath.Quaternion.euler(10, 10, 10)));

    _camera.setFocusByModel(model);
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
      _model = SynchronousFuture(model ?? _baseCube());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Model>(
      future: _model,
      builder: (context, modelSnapshot) {
        if (modelSnapshot.connectionState == ConnectionState.done) {
          if (modelSnapshot.hasData) {
            _setupCameraAndLight(modelSnapshot.data!);

            return ModelWrapper(
              camera: _camera,
              light: _light,
              model: modelSnapshot.data!,
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
    );
  }
}
