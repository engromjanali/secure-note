import 'package:flutter/material.dart';

extension ExExpanded on Widget {
  Widget expd({int? value}) => Expanded(flex: value ?? 1, child: this);
  Widget withKey(Key key) => KeyedSubtree(key: key, child: this);
}
