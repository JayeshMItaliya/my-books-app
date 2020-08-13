import 'package:byebye_flutter_app/bloc/book_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';

class MyBookRegret extends StatelessWidget {
  MyBookRegret(this.bookId, this.bookGenre);

  final String bookId;
  final String bookGenre;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController bookRegret = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const String _myAccountStoryAppBarText = Strings.itemRegretAppBar;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      appBar: MyAccountStoryAppBar('$_myAccountStoryAppBarText'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: bookRegret,
              cursorColor: myAccentColor,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: Strings.itemRegretHintText,
                hintStyle: Theme.of(context).textTheme.button.copyWith(
                    color: myAccentColor, fontWeight: FontWeight.w700),
              ),
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: myPrimaryColor),
              scrollPadding: EdgeInsets.all(20.0),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              autofocus: true,
            ),
            myMaterialButtonText(context),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  Widget myMaterialButtonText(BuildContext context) {
    return MaterialButton(
      child: Text(
        Strings.itemRegretButton,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myOnPrimaryColor),
      ),
      color: myPrimaryColor,
      height: 60,
      elevation: 0,
      minWidth: 220,
      onPressed: () {
        updateBookRegret(context, bookId);
      },
    );
  }

  dynamic updateBookRegret(context, bookId) async {
    if (bookRegret.text == '' || bookRegret.text == null) {
      PlatformAlertDialog(
        title: Strings.bookRegret,
        content: Strings.bookRegretError,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else {
      await bookBloc.updateRegretOfBook(bookId, bookRegret.text).then((result) {
        if (result[0]) {
          _key.currentState.showSnackBar(
            SnackBar(
              backgroundColor: myAccentColor,
              content: Text(
                Strings.itemRegretConfirmationSnack,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myOnAccentColor),
              ),
              duration: Duration(seconds: 1),
            ),
          );
          Future.delayed(Duration(seconds: 2)).then((_) {
            Navigator.of(context).pop(bookRegret.text);
          });
        } else {
          if (result[1] != null) {
            PlatformAlertDialog(
              title: Strings.network,
              content: Strings.networkError,
              defaultActionText: Strings.cancel,
            ).show(context);
          } else {
            PlatformAlertDialog(
              title: Strings.network,
              content: Strings.networkError,
              defaultActionText: Strings.cancel,
            ).show(context);
          }
        }
      });
    }
  }
}

class MyAccountStoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyAccountStoryAppBar(this._myAccountStoryAppBarText);

  final String _myAccountStoryAppBarText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () => {Navigator.pop(context)},
      ),
      titleSpacing: 0.0,
      title: Text(
        '$_myAccountStoryAppBarText',
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
