import 'package:flutter/material.dart';

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
      ),
    );
  }
}
