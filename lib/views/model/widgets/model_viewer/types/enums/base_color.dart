import 'package:flutter/material.dart';

enum BaseColor {
  amber,
  black,
  blue,
  brown,
  cyan,
  green,
  grey,
  indigo,
  lime,
  orange,
  pink,
  purple,
  red,
  teal,
  white,
}

extension BaseColorsFunctions on BaseColor {
  Color get color => {
        BaseColor.amber: Colors.amber,
        BaseColor.black: Colors.black,
        BaseColor.blue: Colors.blue,
        BaseColor.brown: Colors.brown,
        BaseColor.cyan: Colors.cyan,
        BaseColor.green: Colors.green,
        BaseColor.grey: Colors.grey,
        BaseColor.indigo: Colors.indigo,
        BaseColor.lime: Colors.lime,
        BaseColor.orange: Colors.orange,
        BaseColor.pink: Colors.pink,
        BaseColor.purple: Colors.purple,
        BaseColor.red: Colors.red,
        BaseColor.teal: Colors.teal,
        BaseColor.white: Colors.white,
      }[this]!;

  String get name => {
        BaseColor.amber: 'Amber',
        BaseColor.black: 'Black',
        BaseColor.blue: 'Blue',
        BaseColor.brown: 'Brown',
        BaseColor.cyan: 'Cyan',
        BaseColor.green: 'Green',
        BaseColor.grey: 'Grey',
        BaseColor.indigo: 'Indigo',
        BaseColor.lime: 'Lime',
        BaseColor.orange: 'Orange',
        BaseColor.pink: 'Pink',
        BaseColor.purple: 'Purple',
        BaseColor.red: 'Red',
        BaseColor.teal: 'Teal',
        BaseColor.white: 'White',
      }[this]!;
}
