import 'package:byebye_flutter_app/app/auth_widget_builder.dart';
import 'package:byebye_flutter_app/app/email_link_error_presenter.dart';
import 'package:byebye_flutter_app/app/auth_widget.dart';
import 'package:byebye_flutter_app/services/apple_sign_in_available.dart';
import 'package:byebye_flutter_app/services/auth_service.dart';
import 'package:byebye_flutter_app/services/auth_service_adapter.dart';
import 'package:byebye_flutter_app/services/firebase_email_link_handler.dart';
import 'package:byebye_flutter_app/services/email_secure_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  SharedPreferences.getInstance().then((prefs) {
    prefsObject = prefs;
    runApp(MyApp(appleSignInAvailable: appleSignInAvailable));
  });
}

class MyApp extends StatefulWidget {
  const MyApp(
      {this.initialAuthServiceType = AuthServiceType.firebase,
      this.appleSignInAvailable});

  final AuthServiceType initialAuthServiceType;
  final AppleSignInAvailable appleSignInAvailable;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkKeychain();
  }

  dynamic checkKeychain() async {
    try {
      if (prefsObject.getString('uid') == null) {
        return _firebaseAuth.signOut();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(myPrimaryColor); //

    // MultiProvider for top-level services that can be created right away
    return MultiProvider(
      providers: [
        Provider<AppleSignInAvailable>.value(
            value: widget.appleSignInAvailable),
        Provider<AuthService>(
          create: (_) => AuthServiceAdapter(
            initialAuthServiceType: widget.initialAuthServiceType,
          ),
          dispose: (_, AuthService authService) => authService.dispose(),
        ),
        Provider<EmailSecureStore>(
          create: (_) => EmailSecureStore(
            flutterSecureStorage: FlutterSecureStorage(),
          ),
        ),
        ProxyProvider2<AuthService, EmailSecureStore, FirebaseEmailLinkHandler>(
          update: (_, AuthService authService, EmailSecureStore storage, __) =>
              FirebaseEmailLinkHandler.createAndConfigure(
            auth: authService,
            userCredentialsStorage: storage,
          ),
          dispose: (_, linkHandler) => linkHandler.dispose(),
        ),
      ],
      child: AuthWidgetBuilder(
          builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'GB'),
          ],
          //M
          theme: MyFirstTheme().theme,
          //M
          //theme: ThemeData(primarySwatch: Colors.indigo),
          home: EmailLinkErrorPresenter.create(
            context,
            child: AuthWidget(userSnapshot: userSnapshot),
          ),
        );
      }),
    );
  }
}

//class MyApp extends StatelessWidget {
//  // [initialAuthServiceType] is made configurable for testing
//  const MyApp({this.initialAuthServiceType = AuthServiceType.firebase});
//
//  final AuthServiceType initialAuthServiceType;
//
//  @override
//  Widget build(BuildContext context) {
//    FlutterStatusbarcolor.setStatusBarColor(myPrimaryColor); //
//
//    // MultiProvider for top-level services that can be created right away
//    return MultiProvider(
//      providers: [
//        Provider<AuthService>(
//          create: (_) => AuthServiceAdapter(
//            initialAuthServiceType: initialAuthServiceType,
//          ),
//          dispose: (_, AuthService authService) => authService.dispose(),
//        ),
//        Provider<EmailSecureStore>(
//          create: (_) => EmailSecureStore(
//            flutterSecureStorage: FlutterSecureStorage(),
//          ),
//        ),
//        ProxyProvider2<AuthService, EmailSecureStore, FirebaseEmailLinkHandler>(
//          update: (_, AuthService authService, EmailSecureStore storage, __) =>
//              FirebaseEmailLinkHandler.createAndConfigure(
//            auth: authService,
//            userCredentialsStorage: storage,
//          ),
//          dispose: (_, linkHandler) => linkHandler.dispose(),
//        ),
//      ],
//      child: AuthWidgetBuilder(
//          builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
//        return MaterialApp(
//          debugShowCheckedModeBanner: false,
//          localizationsDelegates: GlobalMaterialLocalizations.delegates,
//          supportedLocales: const [
//            Locale('en', 'US'),
//            Locale('en', 'GB'),
//          ],
//          //M
//          theme: MyFirstTheme().theme,
//          //M
//          //theme: ThemeData(primarySwatch: Colors.indigo),
//          home: EmailLinkErrorPresenter.create(
//            context,
//            child: AuthWidget(userSnapshot: userSnapshot),
//          ),
//        );
//      }),
//    );
//  }
//}
