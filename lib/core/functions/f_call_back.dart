import 'package:flutter/material.dart';

/// ⏱️📦 callBackFunction
/// Executes a callback **after** the current frame is rendered.
/// 🔄 Usage:
/// Ensures that the `callback()` runs *after the widget tree* is built,
/// which is useful when we need to interact with context-dependent
/// elements like `Scaffold`, `BuildContext`, etc.
/// 📌 Internally uses:
/// `WidgetsBinding.instance.addPostFrameCallback(...)`
/// ✅ Best for post-render logic like navigation, snackbars, focus changes.

void callBackFunction(Function callback) {
  // Ensure WidgetsBinding is initialized
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}
