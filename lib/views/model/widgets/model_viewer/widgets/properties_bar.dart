import 'package:flutter/material.dart';

import '../types/enums/base_color.dart';

class PropertiesBar extends StatelessWidget {
  final bool rotateLight;
  final bool lightFromCamera;

  final bool drawEdges;
  final bool useRainbowColor;

  final Color color;

  final void Function(bool?)? onChangedRotateLight;
  final void Function(bool?)? onChangedLightFromCamera;

  final void Function(bool?)? onChangedDrawEdges;
  final void Function(bool?)? onChangedUseRainbowColor;

  final void Function(Color?)? onChangedColor;

  const PropertiesBar({
    Key? key,
    required this.rotateLight,
    required this.lightFromCamera,
    required this.drawEdges,
    required this.useRainbowColor,
    required this.color,
    this.onChangedRotateLight,
    this.onChangedLightFromCamera,
    this.onChangedDrawEdges,
    this.onChangedUseRainbowColor,
    this.onChangedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 152,
              child: CheckboxListTile(
                value: this.rotateLight,
                onChanged: this.onChangedRotateLight,
                title: Text('Rotate Light'),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                activeColor: Colors.lightBlue,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            SizedBox(
              width: 192,
              child: CheckboxListTile(
                value: this.lightFromCamera,
                onChanged: this.onChangedLightFromCamera,
                title: Text('Light from camera'),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                activeColor: Colors.lightBlue,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              width: 192,
              child: CheckboxListTile(
                value: this.drawEdges,
                onChanged: this.onChangedDrawEdges,
                title: Text('Draw Edges'),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                activeColor: Colors.lightBlue,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              width: 192,
              child: CheckboxListTile(
                value: this.useRainbowColor,
                onChanged: this.onChangedUseRainbowColor,
                title: Text('Rainbow Colors'),
                dense: true,
                contentPadding: EdgeInsets.all(0),
                activeColor: Colors.lightBlue,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            DropdownButton<Color>(
              value: this.color,
              items: BaseColor.values
                  .map(
                    (baseColor) => DropdownMenuItem<Color>(
                      value: baseColor.color,
                      child: Text(baseColor.name),
                    ),
                  )
                  .toList(),
              onChanged: !this.useRainbowColor ? this.onChangedColor : null,
            ),
          ],
        ),
      ],
    );
  }
}
