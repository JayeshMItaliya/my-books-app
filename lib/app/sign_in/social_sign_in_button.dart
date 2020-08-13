import 'package:byebye_flutter_app/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';

import '../../my_constants/design_system.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    Key key,
    String assetName,
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : super(
    key: key,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(assetName),
              fit: BoxFit.fill
            ),
          ),
        ),

        Text(
          text,
          style: TextStyle(color: textColor, fontSize: 14.0),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(assetName),
        ),
      ],
    ),
    color: color,
    onPressed: onPressed,
  );
}

class SignInButton extends CustomRaisedButton {
  SignInButton({
    Key key,
    @required String text,
    @required Color color,
    @required VoidCallback onPressed,
    Color textColor = mySurfaceColor,
    double height = 60.0,//M/initial value: 50
  }) : super(
          key: key,
          child: Text(text, style: TextStyle(color: textColor, fontSize: 14.0)),
          color: color,
          textColor: textColor,
          height: height,
          onPressed: onPressed,
        );
}
