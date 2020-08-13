import 'package:byebye_flutter_app/common_widgets/platform_widget.dart';
import 'package:byebye_flutter_app/constants/keys.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return
//      Platform.isIOS
//        ? /*await showCupertinoDialog<bool>(
//            context: context,
//            builder: (BuildContext context) => this,
//          )*/
//
//    await showDialog<bool>(
//        context: context,
//        barrierDismissible: false,
//        builder: (BuildContext context) => this,)
//
//        :
        await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => this,
    );
  }

  Widget buildCupertinoWidget(BuildContext context) {
    // TODO(Marius): Build Platform Specific Dialogs.
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    // TODO(Marius): Build Platform Specific Dialogs.
    return AlertDialog(
      backgroundColor: myBackgroundColor,
      title: Text(title),
      titleTextStyle: Theme.of(context)
          .textTheme
          .headline5
          .copyWith(color: myOnBackgroundColor),
      content: Text(content),
      contentTextStyle: Theme.of(context)
          .textTheme
          .headline2
          .copyWith(color: myOnBackgroundColor),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final List<Widget> actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        PlatformAlertDialogAction(
          child: Text(
            cancelActionText,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: myAccentColor, fontWeight: FontWeight.w800),
            key: Key(Keys.alertCancel),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      PlatformAlertDialogAction(
        child: Text(
          defaultActionText,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: myAccentColor, fontWeight: FontWeight.w800),
          key: Key(Keys.alertDefault),
        ),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}

class PlatformAlertDialogAction extends PlatformWidget {
  PlatformAlertDialogAction({this.child, this.onPressed});

  final Widget child;
  final VoidCallback onPressed;

  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      textColor: myAccentColor,
      onPressed: onPressed,
    );
  }
}
