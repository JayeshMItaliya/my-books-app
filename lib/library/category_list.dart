import 'package:byebye_flutter_app/bloc/genre_bloc.dart';
import 'package:byebye_flutter_app/bloc/library_status_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/library/category_add_new.dart';
import 'package:byebye_flutter_app/library/item_details.dart';
import 'package:byebye_flutter_app/library/item_list.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../my_constants/design_system.dart';
import 'item_add_new.dart';

class MyCategories extends StatefulWidget {
  const MyCategories({Key key}) : super(key: key);

  @override
  _MyCategoriesState createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  bool activeSearch = false;
  final _key = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  final genreNameController = TextEditingController();
  dynamic oldGenreName;
  dynamic selectedGenreOption;
  List<String> popUpOption;
  String selectedButtonOption;
  bool libraryStatus = false;
  dynamic libraryStatusValue;
  String selectedLibraryOption;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    genreBloc.genreList(prefsObject.getString('uid'));
    genreBloc.aboutGenre();
  }

  @override
  void initState() {
    super.initState();
    getLibraryStatus();
  }

  dynamic getLibraryStatus() async {
    libraryStatusValue = await libraryStatusBloc.getLibraryStatus();
    libraryStatus = libraryStatusValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    popUpOption = <String>[
      Strings.inventoryListEdit,
      Strings.inventoryListDelete,
    ];
    //theme:
    MyFirstTheme().theme;

    return Scaffold(
      key: _key,
      appBar: myCategoriesAppBar(),
      body: Container(
        child: Column(
          children: [
            // HORIZONTAL LIST VIEW STARTS //
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: mySurfaceColor,
                /*border: Border(
                  bottom: BorderSide(width: 1, color: myPrimaryColor),
                ),*/
              ),
              child: StreamBuilder<dynamic>(
                  stream: genreBloc.aboutGenresStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.aboutGenres.isEmpty) {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          MyHorizontalReportTile(
                              Strings.inventoryStripeItems, 0),
                          MyHorizontalReportTile(
                              Strings.inventoryItemStripeValue, 0),
                          MyHorizontalReportTile(
                              Strings.inventoryItemStripeFavourite, 0),
                          MyHorizontalReportTile(
                              Strings.inventoryStripeRegrets, 0),
//                          MyHorizontalReportTile('OTHER PARAM.', 0),
                        ],
                      );
                    } else {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          MyHorizontalReportTile(Strings.inventoryStripeItems,
                              snapshot.data.aboutGenres[0].toString()),
                          MyHorizontalReportTile(
                              Strings.inventoryItemStripeValue,
                              snapshot.data.aboutGenres[1].toString()),
                          MyHorizontalReportTile(
                              Strings.inventoryItemStripeFavourite,
                              snapshot.data.aboutGenres[2].toString()),
                          MyHorizontalReportTile(Strings.inventoryStripeRegrets,
                              snapshot.data.aboutGenres[3].toString()),
//                          MyHorizontalReportTile('OTHER PARAM.', 0),
                        ],
                      );
                    }
                  }),
            ),
            // HORIZONTAL LIST VIEW ENDS
            Expanded(
              child: StreamBuilder<dynamic>(
                stream: genreBloc.genreStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(myPrimaryColor),
                      ),
                    );
                  } else {
                    return snapshot.data.isEmpty
                        ? emptyDataUi()
                        : ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int index) {
                              return myCategoryTile(snapshot.data, index);
                            },
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: myFloatingActionButtonAddCategory(),
    );
  }

  Widget myCategoriesAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
      //   onPressed: () {
      //     Navigator.push<dynamic>(
      //       context,
      //       MaterialPageRoute<dynamic>(
      //         builder: (context) => BottomNavigationBarController(
      //           userUid: prefsObject.getString('uid'),
      //           routeType: NavigateFrom.library,
      //         ),
      //       ),
      //     );
      //   },
      // ),
      titleSpacing: 20.0,
      title: !activeSearch
          ? Text(
              Strings.inventoryAppBarMain,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: myOnPrimaryColor),
            )
          : TextField(
              autofocus: true,
              onChanged: (value) {
                genreBloc.searchGenre(value);
              },
              controller: searchController,
              cursorColor: myOnPrimaryColor,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: myOnPrimaryColor),
              decoration: InputDecoration(
                hintText: Strings.inventoryAppBarSearch,
                hintStyle: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myOnPrimaryColor),
                border: InputBorder.none,
              ),
            ),
      actions: !activeSearch
          ? [
              Row(
                children: [
                  /*Text(
                    'open',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                  ),*/
                  Switch(
                    activeColor: myAccentColor,
                    inactiveThumbColor: mySurfaceColor,
                    activeTrackColor: mySurfaceColor,
                    inactiveTrackColor: myOnBackgroundColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (val) async {
                      if (val) {
                        selectedLibraryOption = await AlertBoxDialog()
                            .showCustomAlertDialog(
                                context,
                                Strings.closeLibrary,
                                Strings.closeLibraryWarning,
                                [Strings.ok, Strings.cancel]);
                        if (selectedLibraryOption == Strings.ok) {
                          await libraryStatusBloc
                              .changeLibraryStatus(true)
                              .then((result) {
                            if (result[0]) {
                              _key.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: myAccentColor,
                                  content: Text(
                                    Strings.inventoryClosedSnack,
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(color: myOnPrimaryColor),
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
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
                      } else {
                        selectedLibraryOption = await AlertBoxDialog()
                            .showCustomAlertDialog(
                                context,
                                Strings.openLibrary,
                                Strings.openLibraryWarning,
                                [Strings.ok, Strings.cancel]);
                        if (selectedLibraryOption == Strings.ok) {
                          await libraryStatusBloc
                              .changeLibraryStatus(false)
                              .then((result) {
                            if (result[0]) {
                              _key.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: myAccentColor,
                                  content: Text(
                                    Strings.inventoryOpenSnack,
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(color: myOnPrimaryColor),
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
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
                        return libraryStatus = val;
                      });
                    },
                    value: libraryStatus,
                  ),
                  Text(
                    Strings.SwitchInventoryClosed,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: myOnPrimaryColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showShareDialog(context);
                },
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Icon(Icons.share, color: myAccentColor),
                  ),
                  Text(
                    Strings.inventoryshare,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: myOnPrimaryColor),
                  ),
                ]),
              ),
              SizedBox(width: 8),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              //   child: IconButton(
              //     icon: Icon(Icons.search, color: myOnPrimaryColor),
              //     onPressed: () {
              //       activeSearch = !activeSearch;
              //       setState(() {});
              //     },
              //   ),
              // ),
            ]
          : [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: myOnPrimaryColor,
                    ),
                    onPressed: () {
                      searchController.clear();
                      genreBloc.searchGenre('');
                      activeSearch = !activeSearch;
                      setState(() {});
                    }),
              )
            ],
    );
  }

  Widget myCategoryTile(dynamic genreList, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyItemList(
              genreDetails: genreList[index],
            ),
          ),
        ).then(
          (value) => genreBloc.genreList(prefsObject.getString('uid')),
        );
      },
      child: Container(
        height: 72,
        margin: index == 0
            ? EdgeInsets.only(left: 12, top: 8, right: 72, bottom: 0)
            : EdgeInsets.only(left: 12, top: 8, right: 24, bottom: 0),

        /*margin: EdgeInsets.only(left: 24, top: 0, right: 24, bottom: 0),*/
        padding: EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: mySurfaceColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //m-start
            IconButton(
              icon: Icon(Icons.add, color: myAccentColor, size: 20),
              onPressed: () {
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (context) => MyNewItem(
                      genreName: genreList[index].genreName,
                    ),
                  ),
                );
              },
            ),
            //m-over
            Expanded(
              child: Text(
                genreList[index].genreName.toString().toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: myOnBackgroundColor),
              ),
            ),
            Row(
              children: [
                Container(
                  child: Text(
                    genreList[index].booksCount,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: myOnBackgroundColor),
                  ),
                ),
                Visibility(
                  visible: index == 0 ? false : true,
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: myOnBackgroundColor,
                    ),
                    onSelected: (result) async {
                      final response = genreBloc.genreOptions(result);
                      if (response == Strings.inventoryListEdit) {
                        editGenreName(genreList[index].genreName,
                            genreList[index].genreId);
                      } else {
                        selectedButtonOption = await AlertBoxDialog()
                            .showCustomAlertDialog(
                                context,
                                Strings.genreDelete,
                                Strings.genreDeleteWarning,
                                [Strings.ok, Strings.cancel]);
                        if (selectedButtonOption == Strings.ok) {
                          await genreBloc
                              .deleteGenre(genreList[index].genreName,
                                  genreList[index].genreId)
                              .then(
                            (result) {
                              if (result[0]) {
                                PlatformAlertDialog(
                                  title: Strings.genreDeleteError,
                                  content: Strings.genreDeleteErrorDes,
                                  defaultActionText: Strings.cancel,
                                ).show(context);
                              } else {
                                if (result[1] != null) {
                                  Navigator.of(context).pop();
                                  PlatformAlertDialog(
                                    title: Strings.network,
                                    content: Strings.networkError,
                                    defaultActionText: Strings.cancel,
                                  ).show(context);
                                } else {
                                  genreBloc
                                      .genreList(prefsObject.getString('uid'));
                                  _key.currentState.showSnackBar(
                                    SnackBar(
                                      backgroundColor: myAccentColor,
                                      content: Text(
                                        Strings.inventoryCategoryDeleted,
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(color: myOnPrimaryColor),
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        }
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return popUpOption.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(
                            choice,
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: myOnBackgroundColor),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myFloatingActionButtonAddCategory() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(builder: (context) => MyNewCategory()),
        );
      },
      backgroundColor: myAccentColor,
      foregroundColor: myOnPrimaryColor,
      elevation: 0,
      mini: false,
      child: Icon(
        Icons.playlist_add,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(36.0),
        ),
      ),
    );
  }

  Future<dynamic> editGenreName(dynamic genreName, dynamic genreId) {
    genreNameController.text = genreName;
    oldGenreName = genreName;
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            color: myBackgroundColor,
            height: 160,
            width: 500,
            padding:
                const EdgeInsets.only(top: 0, bottom: 10, left: 0, right: 0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: myBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          Strings.inventoryCategoryEdit,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: myOnBackgroundColor),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: myOnBackgroundColor,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MyGenreNameTextField(genreNameController),
                  ),
                ),
                Container(
                  height: 50,
                  child: editGenreNameButton(genreId, oldGenreName),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget editGenreNameButton(genreId, oldGenreName) {
    return MaterialButton(
      child: Text(
        Strings.buttonSave,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myOnPrimaryColor),
      ),
      color: myAccentColor,
      height: 50,
      minWidth: 286,
      onPressed: () {
        genreBloc
            .editGenreName(genreNameController.text, oldGenreName, genreId)
            .then((result) {
          if (result[0]) {
            PlatformAlertDialog(
              title: Strings.genre,
              content: Strings.genreDuplicate,
              defaultActionText: Strings.cancel,
            ).show(context);
          } else {
            if (result[1] != null) {
              Navigator.of(context).pop();
              PlatformAlertDialog(
                title: Strings.network,
                content: Strings.networkError,
                defaultActionText: Strings.cancel,
              ).show(context);
            } else {
              genreBloc.genreList(prefsObject.getString('uid'));
              Navigator.of(context).pop();
              _key.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: myAccentColor,
                  content: Text(
                    Strings.inventoryCategoryEditedSnack,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: myOnPrimaryColor),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          }
        });
      },
    );
  }

  ///When user didn't have category show this UI.
  Widget emptyDataUi() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 100,
          ),
          Text(
            Strings.inventoryaddYourFirstList,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: myOnBackgroundColor, fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Strings.inventoryhint1,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: myOnBackgroundColor, fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Strings.inventoryhint2,
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: myOnBackgroundColor, fontSize: 13),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Strings.inventoryhint3,
            textAlign: TextAlign.justify,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: myOnBackgroundColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  dynamic showShareDialog(BuildContext context) {
    final Widget okButton = FlatButton(
      child: Text(
        Strings.lockInfoButton,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myAccentColor, fontWeight: FontWeight.w800),
      ),
      onPressed: () {
        Clipboard.setData(
          ClipboardData(
            text: Strings.shareInventoryLink + prefsObject.getString('name'),
          ),
        ).then((_) {
          showShareSnackBar();
        });
        Navigator.pop(context);
      },
    );

    final AlertDialog alert = AlertDialog(
      backgroundColor: myBackgroundColor,
      titleTextStyle: Theme.of(context)
          .textTheme
          .headline5
          .copyWith(color: myOnBackgroundColor),
      content: Text(
        Strings.inventoryshareDialog,
        textAlign: TextAlign.left,
      ),
      contentTextStyle: Theme.of(context)
          .textTheme
          .headline2
          .copyWith(color: myOnBackgroundColor, fontSize: 15),
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

  dynamic showShareSnackBar() {
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 500),
      content: Text(
        Strings.dataCopyToClipBoard,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myOnPrimaryColor),
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}

class MyGenreNameTextField extends StatelessWidget {
  const MyGenreNameTextField(this.controller);

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: myAccentColor,
      textCapitalization: TextCapitalization.sentences,
      style:
          Theme.of(context).textTheme.headline5.copyWith(color: myPrimaryColor),
      decoration: InputDecoration(
        focusColor: myAccentColor,
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myAccentColor),
      ),
    );
  }
}
