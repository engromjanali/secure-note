import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

dynamic generateRandomData(int length, {bool asUint8List = false}) {
  // 1. Create a cryptographically secure random number generator.
  final random = Random.secure();

  // 2. Create a list of 'length' random bytes.
  final Uint8List bytes = Uint8List.fromList(
    List<int>.generate(length, (i) => random.nextInt(256)),
  );
  if (asUint8List) return bytes;
  // 3. Encode the bytes to a Base64 URL-safe string.
  // This avoids characters like '+' and '/' which can cause issues in URLs.
  final String base64String = base64UrlEncode(bytes);

  return base64String;
}
