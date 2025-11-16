import 'package:flutter/services.dart';

/// 📋 Copies [value] to the system clipboard.
/// ✅ Handy for share buttons, copy tokens, etc.
/// 🧪 Example: `copyToClipBoard("Hello World")`

Future<void> copyToClipBoard(String value) {
  return Clipboard.setData(ClipboardData(text: value));
}
