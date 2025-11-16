import 'package:flutter/material.dart';

/// 🧵 ThemeExtension on BuildContext
/// A rich set of helpers to easily access `ThemeData`, text styles,
/// screen dimensions, and focus control from any widget context.
/// 🧩 Includes:
/// - TextStyles, card color, fillColor
/// - Width & height of screen
/// - Focus-related methods: `unFocus`, `switchFocus`
/// 🪄 Greatly improves UI building and readability!

extension KeyboardExtension on BuildContext {
  void unFocus() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Unfocuses [unfocusNode] and requests focus on [nextFocusNode]
  void switchFocus({required FocusNode unfocusNode, required FocusNode nextFocusNode}) {
    unfocusNode.unfocus();
    FocusScope.of(this).requestFocus(nextFocusNode);
  }
}
