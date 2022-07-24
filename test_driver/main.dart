import 'package:integration_test/integration_test_driver.dart';
import "package:flutter_driver/driver_extension.dart";

Future<void> main() {
  enableFlutterDriverExtension();
  return integrationDriver();
}
