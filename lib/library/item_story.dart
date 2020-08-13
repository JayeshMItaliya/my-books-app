import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:flutter/services.dart';

class MyBookStory extends StatefulWidget {
  const MyBookStory({this.itemType, this.bookStory});

  final dynamic itemType;
  final dynamic bookStory;

  @override
  _MyBookStoryState createState() => _MyBookStoryState();
}

class _MyBookStoryState extends State<MyBookStory> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController bookStoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bookStoryController.text = widget.bookStory;
    const String _myAccountStoryAppBarText = Strings.itemStoryAppBar;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _key,
      appBar: MyAccountStoryAppBar('$_myAccountStoryAppBarText'),
      body: GestureDetector(
        onPanDown: (_) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
//          final FocusScopeNode currentFocus = FocusScope.of(context);
//          if (!currentFocus.hasPrimaryFocus) {
//            currentFocus.unfocus();
//          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: bookStoryController,
                cursorColor: myAccentColor,
                decoration: InputDecoration(
                  hintText: Strings.itemStoryHintText,
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
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  Widget myMaterialButtonText(BuildContext context) {
    return MaterialButton(
      child: Text(
        Strings.itemStoryButton,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myOnPrimaryColor),
      ),
      color: myPrimaryColor,
      height: 60,
      minWidth: 220,
      onPressed: () {
        updateUserStory(context);
      },
    );
  }

  dynamic updateUserStory(context) {
    Navigator.of(context).pop(bookStoryController.text);
  }
}

//class MyBookStory extends StatelessWidget {
//  MyBookStory({this.itemType, this.bookStory});
//
//  final dynamic itemType;
//  final dynamic bookStory;
//  final GlobalKey<ScaffoldState> _key = GlobalKey();
//  final TextEditingController bookStoryController = TextEditingController();
//
//  @override
//  Widget build(BuildContext context) {
//    bookStoryController.text = bookStory;
//    const String _myAccountStoryAppBarText = Strings.itemStoryAppBar;
//    return Scaffold(
//      resizeToAvoidBottomInset: false,
//      key: _key,
//      appBar: MyAccountStoryAppBar('$_myAccountStoryAppBarText'),
//      body: GestureDetector(
//        onPanDown: (_) {
//          final FocusScopeNode currentFocus = FocusScope.of(context);
//          if (!currentFocus.hasPrimaryFocus) {
//            currentFocus.unfocus();
//          }
//        },
//        child: Padding(
//          padding: const EdgeInsets.all(24.0),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              TextField(
//                controller: bookStoryController,
//                cursorColor: myAccentColor,
//                decoration: InputDecoration(
//                  hintText: Strings.itemStoryHintText,
//                  hintStyle: Theme.of(context).textTheme.headline2.copyWith(
//                      color: myAccentColor, fontStyle: FontStyle.italic),
//                ),
//                style: Theme.of(context)
//                    .textTheme
//                    .headline2
//                    .copyWith(color: myPrimaryColor),
//                scrollPadding: EdgeInsets.all(20.0),
//                keyboardType: TextInputType.multiline,
////                maxLines: 10,
//                autofocus: true,
//              ),
//              myMaterialButtonText(context),
//            ],
//          ),
//        ),
//      ),
//      resizeToAvoidBottomPadding: true,
//    );
//  }
//
//  Widget myMaterialButtonText(BuildContext context) {
//    return MaterialButton(
//      child: Text(
//        Strings.itemStoryButton,
//        style: Theme.of(context)
//            .textTheme
//            .button
//            .copyWith(color: myOnSecondaryColor),
//      ),
//      color: mySecondaryColor,
//      height: 60,
//      minWidth: 220,
//      onPressed: () {
//        updateUserStory(context);
//      },
//    );
//  }
//
//  dynamic updateUserStory(context) {
//    Navigator.of(context).pop(bookStoryController.text);
//  }
//}

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
