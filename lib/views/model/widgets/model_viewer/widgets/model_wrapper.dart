import 'package:flutter/material.dart';

import '../types/classes/camera.dart';
import '../types/classes/light.dart';
import '../types/classes/model.dart';
import '../types/enums/base_color.dart';
import 'camera_light_bar.dart';
import 'model_painter.dart';
import 'properties_bar.dart';

class ModelWrapper extends StatefulWidget {
  final Camera camera;
  final Light light;

  final Model model;

  const ModelWrapper({
    Key? key,
    required this.camera,
    required this.light,
    required this.model,
  }) : super(key: key);

  @override
  _ModelWrapperState createState() => _ModelWrapperState();
}

class _ModelWrapperState extends State<ModelWrapper> {
  bool _useLight = false;
  bool _drawEdges = false;

  bool _rotateLight = false;
  bool _lightFromCamera = false;

  bool _rainbowColor = false;
  Color _color = BaseColor.indigo.color;

  bool _fullscreen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: (moveStart) =>
          setState(() => this.widget.camera.moveStart(moveStart)),
      onScaleUpdate: (move) => setState(
        () => this.widget.camera.move(
            move,
            _useLight && (_rotateLight || _lightFromCamera)
                ? this.widget.light
                : null,
            _lightFromCamera),
      ),
      onScaleEnd: (moveEnd) =>
          setState(() => this.widget.camera.moveEnd(moveEnd)),
      onDoubleTap: () => setState(() => _fullscreen = !_fullscreen),
      child: Stack(
        children: [
          SizedBox.expand(
            child: Center(
              child: Transform.translate(
                offset: this.widget.camera.translation,
                child: Transform.scale(
                  scale: this.widget.camera.scale,
                  child: CustomPaint(
                    painter: ModelPainter(
                      camera: this.widget.camera,
                      light: _useLight ? this.widget.light : null,
                      drawEdges: _drawEdges,
                      model: this.widget.model,
                      color: _color,
                      rainbowColor: _rainbowColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!_fullscreen)
            Positioned(
              top: 24.0,
              left: 24.0,
              child: SafeArea(
                child: CameraLightBar(
                  camera: this.widget.camera,
                  light: this.widget.light,
                  useLight: _useLight,
                  onChangedUseLight: (value) =>
                      setState(() => _useLight = value!),
                  onReset: () => setState(() => this.widget.camera.reset()),
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
                              this.widget.light.position.xyz =
                                  this.widget.camera.position;
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
