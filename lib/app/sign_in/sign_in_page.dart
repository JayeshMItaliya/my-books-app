import 'package:byebye_flutter_app/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:byebye_flutter_app/app/sign_in/sign_in_manager.dart';
import 'package:byebye_flutter_app/app/sign_in/social_sign_in_button.dart';
import 'package:byebye_flutter_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/keys.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/services/apple_sign_in_available.dart';
import 'package:byebye_flutter_app/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../my_constants/design_system.dart';

class SignInPageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, SignInManager manager, __) => SignInPage._(
              isLoading: isLoading.value,
              manager: manager,
              title: 'Hi!',
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  SignInPage._(
      {Key key,
      this.isLoading,
      this.manager,
      this.title,
      this.selectedButtonOption})
      : super(key: key);
  final SignInManager manager;
  final String title;
  final bool isLoading;
  String selectedButtonOption;

  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key emailPasswordButtonKey = Key('email-password');
  static const Key emailLinkButtonKey = Key('email-link');
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

// TODO(marius): Third Party Login Removed due to restriction from App Store.
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
          context,
          Strings.userConvenience,
          Strings.userConvenienceWarning,
          [Strings.ok]);
      if (selectedButtonOption == Strings.ok) {
        await manager.signInWithGoogle();
      }
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
          context,
          Strings.userConvenience,
          Strings.userConvenienceWarning,
          [Strings.ok]);
      if (selectedButtonOption == Strings.ok) {
        await manager.signInWithApple();
      }
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

//
//  Future<void> _signInWithFacebook(BuildContext context) async {
//    try {
//      selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
//          context,
//          Strings.userConvenience,
//          Strings.userConvenienceWarning,
//          [Strings.ok]);
//      if (selectedButtonOption == Strings.ok) {
//        await manager.signInWithFacebook();
//      }
//    } on PlatformException catch (e) {
//      if (e.code != 'ERROR_ABORTED_BY_USER') {
//        _showSignInError(context, e);
//      }
//    }
//  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final navigator = Navigator.of(context);
    await EmailPasswordSignInPage.show(
      context,
      onSignedIn: navigator.pop,
    );
  }

  dynamic _launchURL(String launchUrl) async {
    if (await canLaunch(launchUrl)) {
      await launch(launchUrl);
    } else {
      throw 'Could not launch $launchUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: myBackgroundColor,
        elevation: 0.0,
        // title: Text(title),
      ),*/
      // Hide developer menu while loading in progress.
      // This is so that it's not possible to switch auth service while a request is in progress
      //M/drawer: isLoading ? null : DeveloperMenu(),
      backgroundColor: myBackgroundColor,
      resizeToAvoidBottomPadding: true,
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Text(
                Strings.signInPageWelcome1,
                //Strings.signIn,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w700,
                    color: myPrimaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          Strings.signInPageWelcome2,
          //Strings.signIn,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: myPrimaryColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
              height: 1.5),
        ),
      ],
    );
  }

  Widget _termsAndPrivacy() {
    return RichText(
      text: TextSpan(
        text: Strings.iHaveRead,
        style: const TextStyle(
            color: myPrimaryColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            letterSpacing: 0.0,
            height: 1.5),
        children: <TextSpan>[
          TextSpan(
              text: Strings.termsOfUse,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: myOnSurfaceColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  letterSpacing: 0.0,
                  height: 1.5),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL('https://www.byebye.io/terms-of-use');
                }),
          TextSpan(
            text: Strings.and,
            style: TextStyle(
                color: myPrimaryColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                letterSpacing: 0.0,
                height: 1.5),
          ),
          TextSpan(
              text: Strings.privacyPolicy,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: myOnSurfaceColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  letterSpacing: 0.0,
                  height: 1.5),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL('https://www.byebye.io/privacy-policy');
                }),
        ],
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    final appleSignInAvailable = Provider.of<AppleSignInAvailable>(context);
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 60),
          Container(
/*            height: 250.0,*/
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          _termsAndPrivacy(),
          SizedBox(height: 24.0),
          SignInButton(
            key: emailPasswordButtonKey,
            text: Strings.signInWithEmailPassword,
            onPressed:
                isLoading ? null : () => _signInWithEmailAndPassword(context),
            textColor: myOnSecondaryColor,
            color: myPrimaryColor,
          ),
          SizedBox(height: 70),
          Text(
            Strings.signInPageWelcome3,
            style: TextStyle(
                color: myPrimaryColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.0,
                height: 1.5),
          ),
          SizedBox(height: 12),
          // TODO(marius): Third Party Login Removed due to restriction from App Store.
          SocialSignInButton(
            key: googleButtonKey,
            assetName: 'assets/go-logo.png',
            text: Strings.signInWithGoogle,
            textColor: myPrimaryColor,
            color: mySurfaceColor,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 20),
          if (appleSignInAvailable.isAvailable) ...[
            SocialSignInButton(
              assetName: 'assets/apple-logo.png',
              text: Strings.signInWithApple,
              textColor: myPrimaryColor,
              color: mySurfaceColor,
              onPressed: isLoading ? null : () => _signInWithApple(context),
            ),

            /*AppleSignInButton(
              // TODO(Marius): add key when supported
              style: ButtonStyle.black,
              type: ButtonType.signIn,
              cornerRadius: 0,
              onPressed: isLoading ? null : () => _signInWithApple(context),
            ),*/
          ],

//          SocialSignInButton(
//            key: facebookButtonKey,
//            assetName: 'assets/fb-logo.png',
//            text: Strings.signInWithFacebook,
//            textColor: myPrimaryColor,
//            color: mySurfaceColor,
//            onPressed: isLoading ? null : () => _signInWithFacebook(context),
//            // color: Color(0xFF334D92),//facebook color
//          ),
        ],
      ),
    );
  }
}
