import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/secret_service.dart';

/// remember at first you must have to initialize the,
/// SecretService with key.
/// may be we already initiate in secondary auth screen/page.
SecretService secretService = SecretService();

// Encrypt data
Map<String, dynamic> encrypt(Map<String, dynamic> input) {
  printer("addPasskey data encrypt ${input.toString()}");
  return input.map((key, value) {
    // keep id unencrypted and if the value are empty/null it's also.
    // because it's throw an error.
    if (key == "id" || isNull(value)) return MapEntry(key, value);
    return MapEntry(key, secretService.encrypt(value));
  });
}

// decrypt data
Map<String, dynamic> decrypt(Map<String, dynamic> input) {
  return input.map((key, value) {
    // keep id undecrypted and if the value are empty/null it's also.
    // because it's throw an error.
    if (key == "id" || isNull(value)) return MapEntry(key, value);
    return MapEntry(key, secretService.decrypt(value));
  });
}
