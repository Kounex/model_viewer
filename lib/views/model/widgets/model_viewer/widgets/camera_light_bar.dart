import 'package:flutter/material.dart';

import '../types/classes/camera.dart';

class CameraLightBar extends StatelessWidget {
  final Camera camera;

  final VoidCallback? onReset;

  const CameraLightBar({
    Key? key,
    required this.camera,
    this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 102.0,
          child: Text(
            'Camera\n   x: ${this.camera.position.x.toStringAsFixed(2)}\n   y: ${this.camera.position.y.toStringAsFixed(2)}\n   z: ${this.camera.position.z.toStringAsFixed(2)}',
          ),
        ),
        SizedBox(
          width: 102.0,
          child: Text('Scale\n   ${this.camera.scale.toStringAsFixed(2)}'),
        ),
        TextButton.icon(
          onPressed: this.onReset,
          icon: Icon(Icons.restore),
          label: Text('Reset'),
        ),
      ],
    );
  }
}
