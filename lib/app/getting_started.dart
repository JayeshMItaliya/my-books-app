import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import '../my_constants/design_system.dart';

class GettingStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mySecondaryColor,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        title: Text(Strings.gettingStartedAppBar,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: myOnPrimaryColor)),
        titleSpacing: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: ListView(
          children: [
            SizedBox(height: 12),
            Container(
              child: Text(Strings.gettingStartedIntro,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: myOnPrimaryColor)),
            ),
            SizedBox(height: 36),
            GettingStartedTile(
              '1',
              Strings.gettingStartedTileTitle1,
              Strings.gettingStartedTileText1,
              '',
            ),
            GettingStartedTile(
              '2',
              Strings.gettingStartedTileTitle2,
              Strings.gettingStartedTileText2,
              '',
            ),
            GettingStartedTile(
              '3',
              Strings.gettingStartedTileTitle3,
              Strings.gettingStartedTileText3,
              '',
            ),
            GettingStartedTile(
              '4',
              Strings.gettingStartedTileTitle4,
              Strings.gettingStartedTileText4,
              '',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: MyMaterialButton(Strings.gettingStartedButton),
            ),
          ],
        ),
      ),
    );
  }
}

class MyMaterialButton extends StatelessWidget {
  const MyMaterialButton(this.myButtonText);

  final String myButtonText;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      child: Text(
        '$myButtonText',
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myBackgroundColor),
      ),
      color: myAccentColor,
      height: 50,
/*      minWidth: 220,*/
      onPressed: () => Navigator.pop(context),
    );
  }
}

class GettingStartedTile extends StatelessWidget {
  const GettingStartedTile(this._number, this._title, this._info, this.url);

  final String _number;
  final String _title;
  final String _info;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      margin: EdgeInsets.only(bottom: 36),
      child: Stack(
        children: [
          //Numbering
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: CircleAvatar(
              backgroundColor: myAccentColor,
              radius: 16,
              child: Text(
                _number,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myBackgroundColor),
              ),
            ),
          ),

          //Title
          Padding(
            padding: const EdgeInsets.fromLTRB(42, 8, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: myBackgroundColor),
                ),
                SizedBox(height: 4),
                Text(
                  _info,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: myBackgroundColor),
                ),
              ],
            ),
          ),

          //BodyText
        ],
      ),
    );
  }
}
