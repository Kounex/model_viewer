// Copyright (c) 2014, the tuple project authors. Please see the AUTHORS
// file for details. All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

// Taken from: https://github.com/google/tuple.dart/blob/master/lib/tuple.dart

/// Represents a 2-tuple, or pair.
class Tuple<T> {
  /// Returns the first item of the tuple
  final T item1;

  /// Returns the second item of the tuple
  final T item2;

  /// Creates a new tuple value with the specified items.
  const Tuple(this.item1, this.item2);

  /// Create a new tuple value with the specified list [items].
  factory Tuple.fromList(List items) {
    if (items.length != 2) {
      throw ArgumentError('items must have length 2');
    }

    return Tuple<T>(items[0] as T, items[1] as T);
  }

  /// Returns a tuple with the first item set to the specified value.
  Tuple<T> withItem1(T v) => Tuple<T>(v, item2);

  /// Returns a tuple with the second item set to the specified value.
  Tuple<T> withItem2(T v) => Tuple<T>(item1, v);

  /// Creates a [List] containing the items of this [Tuple].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) =>
      List.from([item1, item2], growable: growable);

  T? firstWhere(bool Function(T) check) {
    if (check(this.item1)) return item1;
    if (check(this.item2)) return item2;
    return null;
  }

  @override
  String toString() => '[$item1, $item2]';

  @override
  bool operator ==(Object other) =>
      other is Tuple && other.item1 == item1 && other.item2 == item2;
}
