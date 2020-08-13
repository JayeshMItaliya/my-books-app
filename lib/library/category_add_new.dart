import 'package:byebye_flutter_app/bloc/add_genre_bloc.dart';
import 'package:byebye_flutter_app/bloc/genre_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';

class MyNewCategory extends StatelessWidget {
  MyNewCategory({Key key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  final TextEditingController newGenreName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //theme:
    MyFirstTheme().theme;
    const _myAppBarText = Strings.inventoryNewCategory;

    return Scaffold(
      key: _key,
      appBar: MyNewCategoryAppBar('$_myAppBarText'),
      body: Container(
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: //marketplace search field start //
                      Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addGenreTextField(context),
                      ],
                    ),
                  ),
                  //marketplace search field end //
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: addGenreButton(context),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: MyBottomNavigationBar(),
    );
  }

  Widget addGenreTextField(context) {
    return Container(
      height: 120,
      padding: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16, top: 16, bottom: 0, right: 16),
                    child: Text(
                      Strings.inventoryYourNewCategory,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnBackgroundColor),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 16, top: 16, bottom: 0, right: 16),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: newGenreName,
                      cursorColor: myAccentColor,
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.inventoryNewCategoryEmpty;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: Strings.inventoryNewCategoryHint,
                        hintStyle: Theme.of(context).textTheme.button.copyWith(
                            color: myAccentColor, fontWeight: FontWeight.w700),
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: mySurfaceColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5, color: myOnBackgroundColor),
                        ),
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: myPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addGenreButton(context) {
    return MaterialButton(
      child: Text(
        Strings.inventoryNewCategoryButton,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myOnPrimaryColor),
      ),
      color: myPrimaryColor,
      elevation: 0,
      height: 60,
      minWidth: 220,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          Loader().showLoader(context);
          addGenreBloc.addNewGenre(newGenreName.text).then((response) {
            if (!response) {
              genreBloc.genreList(prefsObject.getString('uid'));
              _key.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: myAccentColor,
                  content: Text(
                    '${newGenreName.text.toUpperCase()}' +
                        Strings.inventoryNewCategorySnackBar,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: myBackgroundColor),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
              Future.delayed(Duration(seconds: 2)).then((_) {
                Loader().hideLoader(context);
                newGenreName.clear();
                Navigator.of(context).pop();
              });
            } else {
              Loader().hideLoader(context);
              newGenreName.clear();
              PlatformAlertDialog(
                title: Strings.genre,
                content: Strings.genreDuplicate,
                defaultActionText: Strings.cancel,
              ).show(context);
            }
          });
        }
      },
    );
  }
}

class MyNewCategoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyNewCategoryAppBar(this._myNewCategoryAppBarText);

  final String _myNewCategoryAppBarText;

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
        '$_myNewCategoryAppBarText',
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
