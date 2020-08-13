import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// colors (for backgrounds)
const myPrimaryColor = Color(0xFF1d1d1f);
const mySecondaryColor = Color(0xFF383838);
const myAccentColor = Color(0xFFf64a24);
const myAccentShadeColor = Color(0xFFFF8F76);
const mySurfaceColor = Color(0xFFc1bbad);
const myBackgroundColor = Color(0xFFe9e2d0);
const myErrorColor = Color(0xFF0069c7);
const myShadowColor = Color(0xFFFFFFFF);

//on-colors (for texts on the colors above)
const myOnPrimaryColor = Color(0xFFe9e2d0);
const myOnSecondaryColor = Color(0xFFe8eae3);
const myOnAccentColor = Color(0xFFe8eae3);
const myOnSurfaceColor = Color(0xFF463e3c);
const myOnBackgroundColor = Color(0xFF463e3c);
const myOnErrorColor = Color(0xFFFFFFFF);

// colors (for backgrounds)  <--changed in June29
/*const myPrimaryColor = Color(0xFF282828);
const mySecondaryColor = Color(0xFF383838);
const myAccentColor = Color(0xFFa21313);
const myAccentShadeColor = Color(0xFFC67270);
const mySurfaceColor = Color(0xFFD7D2CF);
const myBackgroundColor = Color(0xFFe8eae3);
const myErrorColor = Color(0xFFCC0099);
const myShadowColor = Color(0xFFFFFFFF);

//on-colors (for texts on the colors above)
const myOnPrimaryColor = Color(0xFFe8eae3);
const myOnSecondaryColor = Color(0xFFe8eae3);
const myOnAccentColor = Color(0xFFe8eae3);
const myOnSurfaceColor = Color(0xFF000000);
const myOnBackgroundColor = Color(0xFF757575);
const myOnErrorColor = Color(0xFFFFFFFF);*/

//dark-mode-for-chat
const myDarkSurfaceColor = Color(0xFF313131);
const myDarkBackgroundColor = Color(0xFF323232);
const myDarkOnBackgroundColor = Color(0xFFe1e1e1);
const myDarkAccentColor = Color(0xFF520000);
const myDarkOnPrimaryColor = Color(0xFFe8eae3);

//Globally use for SharedPreferences.
SharedPreferences prefsObject;

class MyFirstTheme {
  ThemeData get theme => ThemeData(
        // primarySwatch: myPrimaryColor,
        primaryColor: myPrimaryColor,
        accentColor: myAccentColor,
        scaffoldBackgroundColor: myBackgroundColor,
        cardColor: mySurfaceColor,
        textSelectionColor: myAccentColor,
        errorColor: myErrorColor,

        fontFamily: 'Montserrat',

        textTheme: TextTheme(
          headline5: TextStyle(
            //horizontal report tile values,
            fontSize: 18,
            letterSpacing: 0,
            fontWeight: FontWeight.w700,
            color: myPrimaryColor,
          ),
          subtitle2: TextStyle(
            //appbar, tabs, titles,
            fontSize: 16,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
            color: myPrimaryColor,
          ),
          headline4: TextStyle(
            // Users name in People, Chat,
            fontSize: 14,
            letterSpacing: 0,
            fontWeight: FontWeight.w700,
            color: myPrimaryColor,
          ),
          headline3: TextStyle(
            // Story output, Regret texts, Paragraphs, user since
            fontSize: 12,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
            color: myOnBackgroundColor,
            height: 1.5,
          ),
          headline2: TextStyle(
            // Story input
            fontSize: 16,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
            color: myOnBackgroundColor,
            height: 1.8,
          ),
          bodyText2: TextStyle(
            //categories, item titles,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            color: myOnBackgroundColor,
          ),
          /*bodyText1: TextStyle( //tabs level 2
            fontSize: 12,
            letterSpacing: 0,
            fontWeight: FontWeight.w700,
            color: myOnBackgroundColor,
          ),*/
          button: TextStyle(
            //buttons
            fontSize: 14,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
          caption: TextStyle(
            //horizontal stripe titles, switcher legend, stats dropdowns, details in people tile
            fontSize: 10,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w700,
            color: myPrimaryColor,
          ),
          overline: TextStyle(
            fontSize: 8,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class Loader {
  void showLoader(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(myAccentColor),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void hideLoader(BuildContext context) {
    Navigator.pop(context);
  }
}

class AlertBoxDialog {
  Future<String> showCustomAlertDialog(BuildContext context, String title,
      String subtitle2, List<String> buttonTitles) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
// TODO(Marius): Build Platform specific dialogs.
        return
//          Platform.isIOS
//            ? CupertinoAlertDialog(
//                title: Text(title),
//                content: Padding(
//                  padding: const EdgeInsets.only(top: 10),
//                  child: Text(subtitle2),
//                ),
//                actions: _cupertinoAlertActions(context, buttonTitles),
//              )
//            :
            AlertDialog(
          backgroundColor: myBackgroundColor,
          title: Text(title),
          titleTextStyle: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: myOnBackgroundColor),
          content: Text(subtitle2),
          contentTextStyle: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(color: myOnBackgroundColor),
          actions: _materialAlertActions(context, buttonTitles),
        );
      },
    );
  }

  List<Widget> _materialAlertActions(
      BuildContext context, List<String> buttonTitles) {
    final List<Widget> listAlertActions = [];
    for (dynamic buttonTitle in buttonTitles) {
      final Widget alertAction = FlatButton(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              buttonTitle,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: myAccentColor, fontWeight: FontWeight.w800),
            ),
          ),
          textColor: myAccentColor,
          onPressed: () {
            Navigator.of(context).pop(buttonTitle);
          });
      listAlertActions.add(alertAction);
    }

    return listAlertActions;
  }

//  List<Widget> _cupertinoAlertActions(
//      BuildContext context, List<String> buttonTitles) {
//    final List<Widget> listAlertActions = [];
//    for (dynamic buttonTitle in buttonTitles) {
//      final Widget alertAction = CupertinoDialogAction(
//          child: Padding(
//            padding: const EdgeInsets.only(top: 5, bottom: 5),
//            child: Text(buttonTitle),
//          ),
//          onPressed: () {
//            Navigator.of(context).pop(buttonTitle);
//          });
//      listAlertActions.add(alertAction);
//    }
//
//    return listAlertActions;
//  }
}
