import 'package:byebye_flutter_app/bloc/book_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/constants.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/library/item_add_new.dart';
import 'package:byebye_flutter_app/library/item_regret.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../my_constants/design_system.dart';

class MyItem extends StatefulWidget {
  const MyItem({this.bookDetails, this.viewType, this.bookLoverName});

  final dynamic bookDetails;
  final dynamic viewType;
  final String bookLoverName;

  @override
  _MyItemState createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {
  final _key = GlobalKey<ScaffoldState>();
  var formatDate = DateFormat('MM yyyy');
  String selectedButtonOption;
  bool _isRegretSwitched = false;
  String regret = '';

  @override
  Widget build(BuildContext context) {
    final dynamic dateOfPurchase = formatDate
        .format(widget.bookDetails.bookPurchaseDate)
        .replaceAll(' ', '/');
    return Scaffold(
      key: _key,
      appBar: myItemAppBar(),
      body: Container(
        child: DefaultTabController(
          length: 3,
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(24, 28, 8, 24),
                  height: 110,
                  color: myPrimaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                        child: Text(
                          widget.viewType == BookViewType.bookLover
                              ? widget.bookLoverName == ''
                                  ? 'Anonymous'
                                  : widget.bookLoverName
                              : widget.bookDetails.bookGenre.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 21,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: myOnPrimaryColor),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        padding: EdgeInsets.only(right: 24),
                        child: Row(
                          children: [
                            Visibility(
                              visible: widget.bookDetails.bookVolumes == '1'
                                  ? false
                                  : true,
                              child: CircleAvatar(
                                backgroundColor: mySurfaceColor,
                                radius: 10,
                                child: Text(
                                  widget.bookDetails.bookVolumes,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  widget.bookDetails.bookName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          color: myOnPrimaryColor,
                                          letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: mySurfaceColor,
                    /*border: Border(
                      bottom: BorderSide(width: 1, color: myPrimaryColor),
                    ),*/
                  ),
                  height: 72,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      MyHorizontalReportTile(Strings.itemDetailsStripePrice,
                          widget.bookDetails.bookPrice),
                      MyHorizontalReportTile(
                          Strings.itemDetailsStripePurchased, dateOfPurchase),
                      MyHorizontalReportTile(Strings.itemDetailsStripeUsed,
                          widget.bookDetails.bookRead.toString()),
                      // START //
                      Visibility(
                        visible: widget.viewType == BookViewType.bookLover
                            ? false
                            : true,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(24, 16, 8, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(Strings.itemDetailsStripeRegret,
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: regretSwitch(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // END //
                      // START //
                      Container(
                        padding: EdgeInsets.fromLTRB(24, 16, 8, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(Strings.itemDetailsStripeLink,
                                  style: Theme.of(context).textTheme.caption),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.bookDetails.sellerLink == '') {
                                    _key.currentState.showSnackBar(
                                      SnackBar(
                                        backgroundColor: myAccentColor,
                                        content: Text(
                                          Strings.itemDetailsStripeNoLink,
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(color: myOnAccentColor),
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    copySellerLink(
                                        widget.bookDetails.sellerLink);
                                  }
                                },
                                child: Icon(Icons.link,
                                    color: widget.bookDetails.sellerLink == ''
                                        ? myOnSurfaceColor
                                        : myPrimaryColor,
                                    size: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // END //
//                      MyHorizontalReportTile('OTHER PARAM.', 0),
                    ],
                  ),
                ),
                /*widget.bookDetails.bookPhoto == ''
                    ? Container()
                    : Container(
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.bookDetails.bookPhoto),
                          ),
                        ),
                      ),*/
                Container(
                  decoration: BoxDecoration(
                    color: myBackgroundColor,
                    border: Border(
                      bottom: BorderSide(width: 1, color: myPrimaryColor),
                    ),
                  ),
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      TabBar(
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 4,
                              color: myPrimaryColor,
                            ),
                            insets:
                                EdgeInsets.only(left: 0, right: 0, bottom: 0)),
                        isScrollable: true,
                        labelPadding: EdgeInsets.only(
                            left: 16, right: 12, top: 10, bottom: 4),
                        tabs: [
                          Tab(
                            child: Text(Strings.itemDetailsStripePhotoTab,
                                style: Theme.of(context).textTheme.button),
                          ),
                          Tab(
                            child: Text(Strings.itemDetailsStripeStoryTab,
                                style: Theme.of(context).textTheme.button),
                          ),
                          Tab(
                            child: Text(Strings.itemDetailsStripeRegretTab,
                                style: Theme.of(context).textTheme.button),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      children: [
                        //tab1
                        widget.bookDetails.bookPhoto == ''
                            ? Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            AssetImage('assets/nophoto1.png'),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, -0.2),
                                    child: Text(
                                      Strings.itemDetailsStripePhotoOverlay,
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              color: myPrimaryColor,
                                              height: 1.6),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                /*height: 300,*/
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      widget.bookDetails.bookPhoto,
                                    ),
                                  ),
                                ),
                              ),
                        //tab2
                        Container(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                          child: ListView(
                            children: [
                              widget.bookDetails.descriptionOfBook == ''
                                  ? Container(
                                      child: Text(
                                        Strings.itemDetailsStripeNoStoryText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                                color: myAccentColor,
                                                height: 1.6,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  : SelectableText(
                                      widget.bookDetails.descriptionOfBook,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2),
                            ],
                          ),
                        ),
                        //tab3
                        Container(
                          padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                          child: ListView(
                            children: [
                              widget.bookDetails.regretOfBook == '' &&
                                      regret == ''
                                  ? Text(
                                      Strings.itemDetailsStripeNoRegretText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                              color: myAccentColor,
                                              height: 1.6,
                                              fontWeight: FontWeight.w700),
                                    )
                                  : regret == ''
                                      ? SelectableText(
                                          widget.bookDetails.regretOfBook,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                  color: myOnBackgroundColor,
                                                  height: 1.6),
                                        )
                                      : Text(
                                          regret ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                  color: myOnBackgroundColor,
                                                  height: 1.6),
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: MyBottomNavigationBar(),
    );
  }

  Widget myItemAppBar() {
    //theme:
    MyFirstTheme().theme;
    const String _myAppBarText = '';
    return AppBar(
      centerTitle: false,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () => {Navigator.pop(context)},
      ),
      titleSpacing: 0.0,
      title: Text(
        '$_myAppBarText',
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
      actions: [
//        IconButton(icon: Icon(Icons.share, size: 20), onPressed: () {}),
//        IconButton(icon: Icon(Icons.shopping_cart, size: 20), onPressed: () {}),

        //marius help text
        Visibility(
          visible: widget.viewType == BookViewType.bookLover ? false : true,
          child: IconButton(
              icon: Icon(Icons.info, size: 20, color: myOnPrimaryColor),
              onPressed: () {
                showHelpText(context);
              }),
        ),
        //marius help text over

        Visibility(
          visible: widget.viewType == BookViewType.bookLover ? false : true,
          child: GestureDetector(
            onLongPress: () {
              unReadBook();
            },
            child: IconButton(
                icon: Icon(Icons.refresh, size: 24, color: myOnPrimaryColor),
                onPressed: () {
                  /*showHelpText(context);*/
                  readBook();
                }),
          ),
        ),
        Visibility(
          visible: widget.viewType == BookViewType.bookLover ? false : true,
          child: IconButton(
              icon: Icon(Icons.tune, size: 24, color: myOnPrimaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MyNewItem(
                      itemType: BookCreateType.editBook,
                      editType: BookEditType.fromBookDetail,
                      bookDetails: widget.bookDetails,
                    ),
                  ),
                );
              }),
        ),
        Visibility(
          visible: widget.viewType == BookViewType.bookLover ? false : true,
          child: IconButton(
              icon: Icon(Icons.delete, size: 24, color: myOnPrimaryColor),
              onPressed: () {
                deleteBook();
              }),
        ),
      ],
    );
  }

  dynamic unReadBook() async {
    if (widget.bookDetails.bookRead != 0) {
      await bookBloc
          .readBook(widget.bookDetails.bookId, widget.bookDetails.bookRead - 1)
          .then((result) {
        if (result[0]) {
          widget.bookDetails.bookRead = widget.bookDetails.bookRead - 1;
          setState(() {});
          bookBloc.bookList(widget.bookDetails.bookGenre, 0);
        } else {
          if (result[1] != null) {
            Loader().hideLoader(context);
            PlatformAlertDialog(
              title: Strings.network,
              content: Strings.networkError,
              defaultActionText: Strings.cancel,
            ).show(context);
          } else {
            Loader().hideLoader(context);
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

  dynamic readBook() async {
    await bookBloc
        .readBook(widget.bookDetails.bookId, widget.bookDetails.bookRead + 1)
        .then((result) {
      if (result[0]) {
        widget.bookDetails.bookRead = widget.bookDetails.bookRead + 1;
        setState(() {});
        bookBloc.bookList(widget.bookDetails.bookGenre, 0);
      } else {
        if (result[1] != null) {
          Loader().hideLoader(context);
          PlatformAlertDialog(
            title: Strings.network,
            content: Strings.networkError,
            defaultActionText: Strings.cancel,
          ).show(context);
        } else {
          Loader().hideLoader(context);
          PlatformAlertDialog(
            title: Strings.network,
            content: Strings.networkError,
            defaultActionText: Strings.cancel,
          ).show(context);
        }
      }
    });
  }

  dynamic deleteBook() async {
    selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
        context,
        Strings.bookDelete,
        Strings.bookDeleteWarning,
        [Strings.ok, Strings.cancel]);
    if (selectedButtonOption == Strings.ok) {
      Loader().showLoader(context);
      await bookBloc
          .deleteBook(widget.bookDetails.bookId, widget.bookDetails.bookName)
          .then((result) {
        if (result[0]) {
          Loader().hideLoader(context);
          _key.currentState.showSnackBar(
            SnackBar(
              backgroundColor: myAccentColor,
              content: Text(
                Strings.itemDeleted,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myOnAccentColor),
              ),
              duration: Duration(seconds: 1),
            ),
          );
          Future.delayed(Duration(seconds: 2)).then((_) {
            Navigator.of(context).pop();
          });
        } else {
          if (result[1] != null) {
            Loader().hideLoader(context);
            PlatformAlertDialog(
              title: Strings.network,
              content: Strings.networkError,
              defaultActionText: Strings.cancel,
            ).show(context);
          } else {
            Loader().hideLoader(context);
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

  dynamic copySellerLink(String sellerLink) {
    Clipboard.setData(ClipboardData(text: sellerLink));
    setState(() {});
    _key.currentState.showSnackBar(
      SnackBar(
        backgroundColor: myAccentColor,
        content: Text(
          Strings.itemDetailsStripeLinkedCopiedSnack,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: myOnAccentColor),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Widget regretSwitch() {
    _isRegretSwitched = widget.bookDetails.regretOfBook == '' && regret == ''
        ? false
        : regret == null ? false : true;

    return Switch(
      activeColor: myAccentColor,
      inactiveThumbColor: mySurfaceColor,
      activeTrackColor: myBackgroundColor,
      inactiveTrackColor: myBackgroundColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: (val) async {
        if (val) {
          if (widget.bookDetails.isFavourite) {
            PlatformAlertDialog(
              title: Strings.favouriteBookRegret,
              content: Strings.favouriteBookRegretError,
              defaultActionText: Strings.cancel,
            ).show(context);
          } else {
            selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
                context,
                Strings.bookRegretWarn,
                Strings.bookRegretWarning,
                [Strings.ok, Strings.cancel]);
            if (selectedButtonOption == Strings.ok) {
              final getRegret = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyBookRegret(
                      widget.bookDetails.bookId, widget.bookDetails.bookGenre),
                ),
              );
              setState(() {
                regret = getRegret;
              });
            } else {
              val = !val;
              setState(() {});
            }
          }
        } else {
          selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
              context,
              Strings.bookRegretDel,
              Strings.bookRegretDelete,
              [Strings.ok, Strings.cancel]);
          if (selectedButtonOption == Strings.ok) {
            bookBloc
                .removeRegretOfBook(widget.bookDetails.bookId)
                .then((result) {
              if (result[0]) {
                regret = '';
                widget.bookDetails.regretOfBook = '';
                _key.currentState.showSnackBar(
                  SnackBar(
                    backgroundColor: myAccentColor,
                    content: Text(
                      Strings.itemDetailsStripeRegretUpdatedSnack,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: myOnAccentColor),
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
                val = !val;
                setState(() {});
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
          } else {
            val = !val;
            setState(() {});
          }
        }
        setState(() {
          return _isRegretSwitched = val;
        });
      },
      value: _isRegretSwitched,
    );
  }
}

class MyHorizontalReportTile extends StatelessWidget {
  const MyHorizontalReportTile(
      this.myHorizontalReportTileHeader, this.myHorizontalReportTileValue);

  final String myHorizontalReportTileHeader;
  final dynamic myHorizontalReportTileValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 16, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text('$myHorizontalReportTileHeader',
                  style: Theme.of(context).textTheme.caption),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text('$myHorizontalReportTileValue',
                  style: Theme.of(context).textTheme.headline5),
            ),
          ],
        ),
      ),
    );
  }
}

//Marius alert dialog in app bar

dynamic showHelpText(BuildContext context) {
  // set up the button
  final Widget okButton = FlatButton(
    child: Text(
      Strings.reuseAlertDialogButton,
      style: Theme.of(context)
          .textTheme
          .button
          .copyWith(color: myAccentColor, fontWeight: FontWeight.w800),
    ),
    onPressed: () => Navigator.pop(context),
  );

  final AlertDialog alert = AlertDialog(
    backgroundColor: myBackgroundColor,
    title: Text(Strings.reuseAlertDialogTitle),
    titleTextStyle: Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: myOnBackgroundColor),
    content: Text(Strings.reuseAlertDialogText),
    contentTextStyle: Theme.of(context)
        .textTheme
        .headline2
        .copyWith(color: myOnBackgroundColor),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
