import 'package:byebye_flutter_app/common_widgets/custom_raised_button.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';

import '../my_constants/design_system.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    Key key,
    String text,
    bool loading = false,
    VoidCallback onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(color: myOnPrimaryColor, fontSize: 14.0),
          ),
          height: 60.0, //initial value: 44
          color: myPrimaryColor,
          textColor: myOnPrimaryColor,
          borderRadius: 1.0,
          loading: loading,
          onPressed: onPressed,
        );
}
