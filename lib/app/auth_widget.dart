import 'package:byebye_flutter_app/app/bottom_navigation_bar_controller.dart';

import 'package:byebye_flutter_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../onboarding/onboarding_1.dart';

/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Note: this class used to be called [LandingPage].
class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      /*return userSnapshot.hasData ? HomePage() : SignInPageBuilder();*/
      return userSnapshot.hasData
          ? BottomNavigationBarController(userUid: userSnapshot.data.uid)
          : Onboarding1();
          /*: SignInPageBuilder();*/
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
