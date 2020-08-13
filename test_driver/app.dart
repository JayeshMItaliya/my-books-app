//import 'package:byebye_flutter_app/main.dart' as app;
import 'package:byebye_flutter_app/main.dart';
import 'package:byebye_flutter_app/services/apple_sign_in_available.dart';
import 'package:byebye_flutter_app/services/auth_service_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  runApp(MyApp(
    initialAuthServiceType: AuthServiceType.mock,
    appleSignInAvailable: AppleSignInAvailable(false),
  ));
}
