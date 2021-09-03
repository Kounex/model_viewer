import 'package:flutter/material.dart';

import '../types/classes/camera.dart';
import '../types/classes/light.dart';

class CameraLightBar extends StatefulWidget {
  final Camera camera;
  final Light light;

  final bool useLight;
  final void Function(bool?)? onChangedUseLight;

  final VoidCallback? onReset;

  const CameraLightBar({
    Key? key,
    required this.camera,
    required this.light,
    required this.useLight,
    this.onChangedUseLight,
    this.onReset,
  }) : super(key: key);

  @override
  _CameraLightBarState createState() => _CameraLightBarState();
}

class _CameraLightBarState extends State<CameraLightBar> {
  late TextEditingController _cameraX;
  late TextEditingController _cameraY;
  late TextEditingController _cameraZ;

  late TextEditingController _lightX;
  late TextEditingController _lightY;
  late TextEditingController _lightZ;

  @override
  void initState() {
    super.initState();

    _cameraX = TextEditingController(
        text: this.widget.camera.position.x.toStringAsFixed(2));
    _cameraY = TextEditingController(
        text: this.widget.camera.position.y.toStringAsFixed(2));
    _cameraZ = TextEditingController(
        text: this.widget.camera.position.z.toStringAsFixed(2));

    _lightX = TextEditingController(
        text: this.widget.light.position.x.toStringAsFixed(2));
    _lightY = TextEditingController(
        text: this.widget.light.position.y.toStringAsFixed(2));
    _lightZ = TextEditingController(
        text: this.widget.light.position.z.toStringAsFixed(2));
  }

  @override
  void didUpdateWidget(covariant CameraLightBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    _cameraX.text = this.widget.camera.position.x.toStringAsFixed(2);
    _cameraY.text = this.widget.camera.position.y.toStringAsFixed(2);
    _cameraZ.text = this.widget.camera.position.z.toStringAsFixed(2);

    _lightX.text = this.widget.light.position.x.toStringAsFixed(2);
    _lightY.text = this.widget.light.position.y.toStringAsFixed(2);
    _lightZ.text = this.widget.light.position.z.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 92.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  'Camera',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            SizedBox(
              width: 64.0,
              child: TextField(
                controller: _cameraX,
                focusNode: FocusNode()
                  ..addListener(
                    () => _cameraX.selection = TextSelection(
                        baseOffset: 0, extentOffset: _cameraX.text.length),
                  ),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'X',
                ),
                onSubmitted: (pos) {
                  double? parsed = double.tryParse(pos);
                  if (parsed != null) {
                    _cameraX.text = parsed.toStringAsFixed(2);
                    this.widget.camera.position.x = parsed;
                  }
                },
              ),
            ),
            SizedBox(width: 12.0),
            SizedBox(
              width: 64.0,
              child: TextField(
                controller: _cameraY,
                focusNode: FocusNode()
                  ..addListener(
                    () => _cameraY.selection = TextSelection(
                        baseOffset: 0, extentOffset: _cameraY.text.length),
                  ),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Y',
                ),
                onSubmitted: (pos) {
                  double? parsed = double.tryParse(pos);
                  if (parsed != null) {
                    _cameraY.text = parsed.toStringAsFixed(2);
                    this.widget.camera.position.y = parsed;
                  }
                },
              ),
            ),
            SizedBox(width: 12.0),
            SizedBox(
              width: 64.0,
              child: TextField(
                controller: _cameraZ,
                focusNode: FocusNode()
                  ..addListener(
                    () => _cameraZ.selection = TextSelection(
                        baseOffset: 0, extentOffset: _cameraZ.text.length),
                  ),
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Z',
                ),
                onSubmitted: (pos) {
                  double? parsed = double.tryParse(pos);
                  if (parsed != null) {
                    _cameraZ.text = parsed.toStringAsFixed(2);
                    this.widget.camera.position.z = parsed;
                  }
                },
              ),
            ),

            // SizedBox(
            //   width: 102.0,
            //   child: Text(
            //     'Camera\n   x: ${this.camera.position.x.toStringAsFixed(2)}\n   y: ${this.camera.position.y.toStringAsFixed(2)}\n   z: ${this.camera.position.z.toStringAsFixed(2)}',
            //   ),
            // ),
            // SizedBox(
            //   width: 102.0,
            //   child: Text('Scale\n   ${this.camera.scale.toStringAsFixed(2)}'),
            // ),
            // TextButton.icon(
            //   onPressed: this.onReset,
            //   icon: Icon(Icons.restore),
            //   label: Text('Reset'),
            // ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 92,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: Offset(-10, 0),
                    child: Checkbox(
                      value: this.widget.useLight,
                      onChanged: this.widget.onChangedUseLight,
                      activeColor: Colors.lightBlue,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  Text(
                    'Light',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: this.widget.useLight ? 1.0 : 0,
              duration: Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 64.0,
                      child: TextField(
                        controller: _lightX,
                        focusNode: FocusNode()
                          ..addListener(
                            () => _lightX.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: _lightX.text.length),
                          ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'X',
                        ),
                        onSubmitted: (pos) {
                          double? parsed = double.tryParse(pos);
                          if (parsed != null) {
                            _lightX.text = parsed.toStringAsFixed(2);
                            this.widget.light.position.x = parsed;
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 12.0),
                    SizedBox(
                      width: 64.0,
                      child: TextField(
                        controller: _lightY,
                        focusNode: FocusNode()
                          ..addListener(
                            () => _lightY.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: _lightY.text.length),
                          ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Y',
                        ),
                        onSubmitted: (pos) {
                          double? parsed = double.tryParse(pos);
                          if (parsed != null) {
                            _lightY.text = parsed.toStringAsFixed(2);
                            this.widget.light.position.y = parsed;
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 12.0),
                    SizedBox(
                      width: 64.0,
                      child: TextField(
                        controller: _lightZ,
                        focusNode: FocusNode()
                          ..addListener(
                            () => _lightZ.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: _lightZ.text.length),
                          ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Z',
                        ),
                        onSubmitted: (pos) {
                          double? parsed = double.tryParse(pos);
                          if (parsed != null) {
                            _lightZ.text = parsed.toStringAsFixed(2);
                            this.widget.light.position.z = parsed;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
