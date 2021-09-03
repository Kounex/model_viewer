import 'package:flutter/material.dart';
import 'package:model_viewer/views/model/widgets/model_viewer/types/classes/camera.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

import 'widgets/model_viewer/model_viewer.dart';

class ModelView extends StatefulWidget {
  const ModelView({Key? key}) : super(key: key);

  @override
  _ModelViewState createState() => _ModelViewState();
}

class _ModelViewState extends State<ModelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModelViewer(
        objFileName: 'Sting-Sword-lowpoly.obj',
        camera: Camera(VectorMath.Vector3(5, -7, -10)),
      ),
    );
  }
}
