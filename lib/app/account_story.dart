import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:byebye_flutter_app/constants/strings.dart';

class MyAccountStory extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController userStory = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userStory.text = prefsObject.getString('userStory');
    const String _myAccountStoryAppBarText = Strings.accountStoryAppBar;
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
            TextField(
              controller: userStory,
              cursorColor: myAccentColor,
              decoration: InputDecoration(
                hintText: Strings.accountStoryHintText,
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
        Strings.accountStoryButton,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myOnPrimaryColor),
      ),
      color: myPrimaryColor,
      height: 60,
      minWidth: 220,
      onPressed: () {
        updateUserStory(userStory.text, context);
      },
    );
  }

  dynamic updateUserStory(String userStory, context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Firestore.instance
        .collection('users')
        .document(prefsObject.getString('uid'))
        .updateData({'userStory': userStory}).then((_) {
      prefsObject.setString('userStory', userStory);
      _key.currentState.showSnackBar(
        SnackBar(
          backgroundColor: myAccentColor,
          content: Text(
            Strings.accountStoryStackStoryUpdate,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: myOnAccentColor),
          ),
          duration: Duration(seconds: 1),
        ),
      );
    });
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }
}

class MyAccountStoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyAccountStoryAppBar(this.myAccountStoryAppBarText);

  final String myAccountStoryAppBarText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () => {Navigator.pop(context)},
      ),
      titleSpacing: 0.0,
      title: Text(
        Strings.accountStoryAppBar,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
      /*actions: [
        IconButton(
          icon: Icon(Icons.share, color: myOnPrimaryColor),
          onPressed: () => {},
        ),
        IconButton(
            icon: Icon(Icons.search, color: myOnPrimaryColor),
            onPressed: () => {}),
      ],*/
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
