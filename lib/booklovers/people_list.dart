import 'package:byebye_flutter_app/bloc/book_lovers_bloc.dart';
import 'package:byebye_flutter_app/bloc/people_filter_bloc.dart';
import 'package:byebye_flutter_app/booklovers/people_file.dart';
import 'package:byebye_flutter_app/booklovers/people_filter.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import '../bloc/people_filter_bloc.dart';
import '../constants/strings.dart';
import '../my_constants/design_system.dart';

class MyPeopleList extends StatefulWidget {
  const MyPeopleList({Key key}) : super(key: key);

  @override
  _MyPeopleListState createState() => _MyPeopleListState();
}

class _MyPeopleListState extends State<MyPeopleList>
    with TickerProviderStateMixin {
  final _key = GlobalKey<ScaffoldState>();
  TabController tabController;
  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  bool activeSearch = false;
  bool peopleStatus = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    prefsObject.getBool('activeFilter');
    if (!peopleStatus) {
      bookLoversBloc.bookLoversList(tabController.index);
    } else {
      bookLoversBloc.activeBookLoversList(tabController.index);
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    //Initital value with more than 25 inventory value
    if (prefsObject.getBool('activeFilter') == null) {
      prefsObject.setBool('activeFilter', true);
      peopleFilterBloc.getSpecificPeople(
        genderValue: prefsObject.getString('filterGenderVal'),
        ageValue: prefsObject.getString('filterAgeVal'),
        inventoryVal: Strings.peopleFilterByMoreThanTwentyFive,
        activityVal: prefsObject.getString('filterActivityVal'),
      );
      prefsObject.setString(
          'filterInventoryVal', Strings.peopleFilterByMoreThanTwentyFive);
    }
    // prefsObject.getBool('activeFilter') == null
    //     ? prefsObject.setBool('activeFilter', false)
    //     : prefsObject.getBool('activeFilter');
    tabController = TabController(length: 3, vsync: this);
    if (prefsObject.getBool('activeFilter')) {
      peopleFilterBloc.getSpecificPeople(
        genderValue: prefsObject.getString('filterGenderVal'),
        ageValue: prefsObject.getString('filterAgeVal'),
        inventoryVal: prefsObject.getString('filterInventoryVal'),
        activityVal: prefsObject.getString('filterActivityVal'),
      );
    }
    tabController.addListener(() {
      activeSearch = false;
      setState(() {});
      FocusScope.of(context).requestFocus(FocusNode());
      if (!peopleStatus) {
        bookLoversBloc.bookLoversList(tabController.index);
      } else {
        bookLoversBloc.activeBookLoversList(tabController.index);
      }
      if (tabController.index == 2) {
        bookLoversBloc.highLightUser();
      }
      if (tabController.index == 1) {
        bookLoversBloc.allbookLoversList(tabController.index);
      }
    });
  }

  Future<void> _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      if (!peopleStatus) {
        await bookLoversBloc.nextBookLoversList(tabController.index);
      } else {
        await bookLoversBloc.nextActiveBookLoversList(tabController.index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MyFirstTheme().theme;
    return Scaffold(
      key: _key,
      appBar: myPeopleListAppBar(context),
      body: Align(
        alignment: Alignment.topLeft,
        child: Container(
          child: DefaultTabController(
            length: 3,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: mySurfaceColor,
                    ),
                    height: 56,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        TabBar(
                          controller: tabController,
                          indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 4,
                                color: myPrimaryColor,
                              ),
                              insets: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 0)),
                          isScrollable: true,
                          labelPadding: EdgeInsets.only(
                              left: 16, right: 12, top: 10, bottom: 4),
                          tabs: [
                            Tab(
                              child: Text(Strings.peopleFileBrowseTab,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                            Tab(
                              child: Text(Strings.peopleFileBookmarkedTab,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                            Tab(
                              child: Text(Strings.peopleFileHighlightsTab,
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: tabController.index == 0
                        ? browseList()
                        : tabController.index == 1
                            ? followingList()
                            : myHighLightPeople(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget myPeopleListAppBar(context) {
    const String _myPeopleListAppBarText = Strings.peopleFileAppBar;
    return AppBar(
      centerTitle: false,
      elevation: 0,
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => BottomNavigationBarController(
      //           userUid: prefsObject.getString('uid'),
      //           routeType: NavigateFrom.bookLover,
      //         ),
      //       ),
      //     );
      //   },
      // ),
      titleSpacing: 20.0,
      title: !activeSearch
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$_myPeopleListAppBarText',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: myOnPrimaryColor),
                ),
                StreamBuilder<dynamic>(
                    stream: peopleFilterBloc.selectedFilterDataStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Visibility(
                        visible: tabController.index == 0 &&
                            prefsObject.getBool('activeFilter'),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 5),
                              child: Text(
                                '•',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: Colors.red, fontSize: 30),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 2, left: 2),
                              child: Text(
                                snapshot.data.length.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: Colors.red, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            )
          : TextField(
              autofocus: true,
              onChanged: (value) async {
                await bookLoversBloc.allbookLoversList(tabController.index);
                await bookLoversBloc.searchUser(value, tabController.index,
                    value: peopleStatus);
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
              Visibility(
                visible: tabController.index == 0 &&
                        !prefsObject.getBool('activeFilter')
                    ? true
                    : false,
                child: Row(
                  children: [
                    Switch(
                      activeColor: myAccentColor,
                      inactiveThumbColor: mySurfaceColor,
                      activeTrackColor: mySurfaceColor,
                      inactiveTrackColor: myOnBackgroundColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (val) async {
                        setState(() {
                          return peopleStatus = val;
                        });
                        if (val) {
                          bookLoversBloc
                              .activeBookLoversList(tabController.index);
                        } else {
                          bookLoversBloc.bookLoversList(tabController.index);
                        }
                      },
                      value: peopleStatus,
                    ),
                    Text(
                      Strings.SwitchActiveUsers,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnPrimaryColor),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: tabController.index == 0 &&
                        prefsObject.getBool('activeFilter')
                    ? true
                    : false,
                child: Row(
                  children: [
                    Text(
                      Strings.peopleFileChangeFilterCriteria,
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnPrimaryColor),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: tabController.index == 0 ? true : false,
                child: IconButton(
                  icon: Icon(Icons.tune,
                      color: prefsObject.getBool('activeFilter')
                          ? myAccentColor
                          : myOnPrimaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PeopleFiltering(),
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: tabController.index == 0 &&
                        !prefsObject.getBool('activeFilter')
                    ? true
                    : false,
                child: Row(
                  children: [
                    Visibility(
                      visible: tabController.index == 2 ? false : true,
                      child: IconButton(
                        icon: Icon(Icons.search, color: myOnPrimaryColor),
                        onPressed: () {
                          activeSearch = !activeSearch;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /*Visibility(
                visible: tabController.index == 2 ? false : true,
                child: IconButton(
                  icon: Icon(Icons.search, color: myOnPrimaryColor),
                  onPressed: () {
                    activeSearch = !activeSearch;
                    setState(() {});
                  },
                ),
              ),*/
            ]
          : [
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: myOnPrimaryColor,
                ),
                onPressed: () async {
                  searchController.clear();
                  await bookLoversBloc.allbookLoversList(null);
                  await bookLoversBloc.searchUser('', tabController.index,
                      value: peopleStatus);
                  activeSearch = !activeSearch;
                  setState(() {});
                },
              )
            ],
    );
  }

  Widget browseList() {
    return StreamBuilder(
      stream: prefsObject.getBool('activeFilter')
          ? peopleFilterBloc.selectedFilterDataStream
          : peopleStatus && !prefsObject.getBool('activeFilter')
              ? bookLoversBloc.activeBookLoverStream
              : bookLoversBloc.allBookLoversStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
            ),
          );
        } else {
          if (snapshot.data.isEmpty) {
            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  tabController.index == 0
                      ? Strings.noRecordFound
                      : tabController.index == 1
                          ? Strings.searchBarMessageNoFound
                          : Strings.searchBarMessageNoFound,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(
                      color: myAccentColor,
                      height: 1.6,
                      fontWeight: FontWeight.w700),
                ),
              ),
            );
          } else {
            return ListView.builder(
              controller: scrollController,
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                return myPeopleUser(snapshot.data, index);
              },
            );
          }
        }
      },
    );
  }

  Widget followingList() {
    return Container(
      child: StreamBuilder(
        stream: bookLoversBloc.followBookLoverStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
              ),
            );
          } else {
            if (snapshot.data.isEmpty) {
              return Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    tabController.index == 0
                        ? Strings.searchBarMessageNoFound
                        : tabController.index == 1
                            ? Strings.searchBarMessageNoFound
                            : Strings.searchBarMessageNoFound,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: myOnPrimaryColor),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return myPeopleUser(snapshot.data, index);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget myPeopleUser(dynamic bookLoverList, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (context) =>
                MyPeopleFile(userProfile: bookLoverList[index]),
          ),
        );
      },
      child: Container(
        height: 112,
        margin: EdgeInsets.only(left: 24, top: 0, right: 24, bottom: 0),
        padding: EdgeInsets.only(left: 0, top: 4, right: 0, bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: mySurfaceColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: bookLoverList[index].userPhoto == ''
                            ? AssetImage('assets/user.png')
                            : NetworkImage(bookLoverList[index].userPhoto),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                              bookLoverList[index].userName == ''
                                  ? 'Anonymous'
                                  : bookLoverList[index].userName,
                              style: Theme.of(context).textTheme.headline4),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 7, 0, 2),
                          child: Text(
                            bookLoverList[index].booksCount == ''
                                ? Strings.peopleTileInventoryZero
                                : Strings.peopleTileInventoryText +
                                    ' ${bookLoverList[index].booksCount}',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: myOnBackgroundColor),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: Text(
                            Strings.peopleTileFansText +
                                ' ${bookLoverList[index].fansCount}',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: myOnBackgroundColor),
                          ),
                        ),
                        bookLoverList[index].badgeColor != 0 &&
                                bookLoverList[index].badgeColor != null
                            ? Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 4.5, 3, 0),
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: bookLoverList[index].badgeColor ==
                                              1
                                          ? myAccentColor
                                          : bookLoverList[index].badgeColor == 2
                                              ? myAccentShadeColor
                                              : bookLoverList[index]
                                                          .badgeColor ==
                                                      4
                                                  ? myPrimaryColor
                                                  : Colors.black45,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                                    child: Text(
                                      bookLoverList[index].status,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myOnBackgroundColor),
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: IconButton(
                    iconSize: 16,
                    icon: bookLoverList[index].libraryStatus
                        ? Icon(Icons.lock, color: myOnBackgroundColor)
                        : Icon(Icons.lock_open, color: myOnBackgroundColor),
                    /*color: myAccentColor,*/
                    onPressed: () {},
                  ),
                ),
                Visibility(
                  visible: tabController.index == 2 ? false : true,
                  child: IconButton(
                    icon: Icon(Icons.bookmark),
                    color: bookLoverList[index].fansList.isEmpty
                        ? mySurfaceColor
                        : bookLoverList[index]
                                .fansList
                                .contains(prefsObject.getString('uid'))
                            ? myAccentColor
                            : mySurfaceColor,
                    onPressed: () {
                      addAndRemoveToBookmarked(bookLoverList[index]);
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

  Widget myHighLightPeople() {
    return Container(
      child: StreamBuilder(
        stream: bookLoversBloc.highLightBookLoversStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
              ),
            );
          } else {
            if (snapshot.data.isEmpty) {
              return Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    Strings.peopleHighlightsEmpty,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: myOnPrimaryColor),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return myPeopleUser(snapshot.data, index);
                },
              );
            }
          }
        },
      ),
    );
  }

  dynamic addAndRemoveToBookmarked(bookLover) async {
    if (bookLover.fansList.isEmpty) {
      await bookLoversBloc
          .addAndRemoveToBookmarked(bookLover.userUid, true)
          .then((result) {
        if (result[0]) {
          if (tabController.index == 1) {
            bookLoversBloc.allbookLoversList(tabController.index);
          } else {
            setState(() {
              bookLover.fansList.add(prefsObject.getString('uid'));
            });
          }
          _key.currentState.showSnackBar(
            SnackBar(
              backgroundColor: myAccentColor,
              content: Text(
                Strings.peopleBookmarkedText,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myOnAccentColor),
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
    } else if (bookLover.fansList.contains(prefsObject.getString('uid'))) {
      await bookLoversBloc
          .addAndRemoveToBookmarked(bookLover.userUid, false)
          .then((result) {
        if (result[0]) {
          if (tabController.index == 1) {
            bookLoversBloc.allbookLoversList(tabController.index);
          } else {
            setState(() {
              bookLover.fansList.remove(prefsObject.getString('uid'));
            });
          }

          _key.currentState.showSnackBar(
            SnackBar(
              backgroundColor: myAccentColor,
              content: Text(
                Strings.peopleUnBookmarkedText,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myOnAccentColor),
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
      await bookLoversBloc
          .addAndRemoveToBookmarked(bookLover.userUid, true)
          .then((result) {
        if (result[0]) {
          if (!peopleStatus) {
            bookLoversBloc.bookLoversList(tabController.index);
          } else {
            bookLoversBloc.activeBookLoversList(tabController.index);
          }
          _key.currentState.showSnackBar(
            SnackBar(
              backgroundColor: myAccentColor,
              content: Text(
                Strings.peopleBookmarkedText,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myOnAccentColor),
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
    }
  }
}

class MyPeopleUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      margin: EdgeInsets.only(left: 24, top: 0, right: 24, bottom: 0),
      padding: EdgeInsets.only(left: 0, top: 4, right: 0, bottom: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: mySurfaceColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) => MyPeopleFile(),
                ),
              );
            },
            child: Container(
              child: Row(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/user.png'),
                        )
                        // color: myErrorColor,
                        ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            'Charlotte Xing',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: myOnBackgroundColor,
                                    fontWeight: FontWeight.w900),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 2),
                          child: Text(
                            'Library 159',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: myOnBackgroundColor),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                          child: Text(
                            'Fans 23',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: myOnBackgroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.lock),
                color: myPrimaryColor,
//              padding: EdgeInsets.only(left: 100, top: 0, right: 0, bottom: 0),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.bookmark),
                color: myPrimaryColor,
//              padding: EdgeInsets.only(left: 16, top: 0, right: 0, bottom: 0),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//Marius's Info icon

dynamic showLockInfo(BuildContext context) {
  // set up the button
  final Widget okButton = FlatButton(
    child: Text(
      Strings.lockInfoButton,
      style: TextStyle(color: myAccentColor),
    ),
    onPressed: () => Navigator.pop(context),
  );

  final AlertDialog alert = AlertDialog(
    backgroundColor: myBackgroundColor,
    title: Text(Strings.lockInfoTitle),
    titleTextStyle: Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: myOnBackgroundColor),
    content: Text(Strings.lockInfoText),
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
