import 'package:byebye_flutter_app/bloc/book_lovers_bloc.dart';
import 'package:byebye_flutter_app/bloc/genre_bloc.dart';
import 'package:byebye_flutter_app/bloc/user_book_bloc.dart';
import 'package:byebye_flutter_app/bloc/user_connection_bloc.dart';
import 'package:byebye_flutter_app/bloc/user_genre_bloc.dart';
import 'package:byebye_flutter_app/chat/chat_screen.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/constants.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/library/item_details.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../my_constants/design_system.dart';

class MyPeopleFile extends StatefulWidget {
  const MyPeopleFile({this.userProfile, this.chatUserProfile});

  final dynamic userProfile;
  final dynamic chatUserProfile;

  @override
  _MyPeopleFileState createState() => _MyPeopleFileState();
}

class _MyPeopleFileState extends State<MyPeopleFile>
    with TickerProviderStateMixin {
  TabController tabController;
  final _key = GlobalKey<ScaffoldState>();
  final dateFormat = DateFormat('MM/yyyy');
  String userSince = '';
  dynamic selectedGenreTile;
  dynamic selectedConnection;
  dynamic viewType;
  List<String> popUpOption;
  String selectedBlockOption;
  UserConnectionBloc userConnectionBlocNew = UserConnectionBloc();
  UserGenreBloc userGenreBlocNew = UserGenreBloc();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userGenreBlocNew.userGenreList(widget.userProfile.userUid);
  }

  @override
  void initState() {
    super.initState();
    genreBloc = GenreBloc();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      if (tabController.index == 0) {
        if (viewType == UserViewType.connection) {
          userGenreBlocNew.userGenreList(selectedConnection.userUid);
        } else {
          userGenreBlocNew.userGenreList(widget.userProfile.userUid);
        }
      } else if (tabController.index == 1) {
        if (viewType == UserViewType.connection) {
          userBookBloc.userBookList(
              selectedGenreTile.genreName, selectedConnection.userUid);
        } else {
          if (selectedGenreTile != null) {
            userBookBloc.userBookList(
                selectedGenreTile.genreName, widget.userProfile.userUid);
          } else {
            userBookBloc.userBookList(
                Strings.inventoryCategoryAll, widget.userProfile.userUid);
          }
        }
      } else if (tabController.index == 3) {
        userConnectionBlocNew.userConnectionList(widget.userProfile.userUid);
      }
    });
    viewProfile();
  }

  @override
  void dispose() {
    userConnectionBlocNew.dispose();
    userGenreBlocNew.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    popUpOption = <String>[
      Strings.blockUser,
      Strings.reportUser,
    ];
    if (viewType == UserViewType.connection) {
      if (selectedConnection.userSince == '') {
        userSince = '';
      } else {
        final parsedDate = DateTime.parse(selectedConnection.userSince);
        userSince = dateFormat.format(parsedDate);
      }
    } else {
      if (widget.userProfile.userSince == '') {
        userSince = '';
      } else {
        final parsedDate = DateTime.parse(widget.userProfile.userSince);
        userSince = dateFormat.format(parsedDate);
      }
    }

    //theme:
    MyFirstTheme().theme;
    return Scaffold(
      key: _key,
      appBar: myPeopleFileAppBar(),
      body: Container(
        child: DefaultTabController(
          length: 4,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //THE BIG HEADER STARTS //

                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 80,
                          color: myPrimaryColor,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: mySurfaceColor,
                            /*border: Border(
                              bottom:
                                  BorderSide(width: 0.5, color: myPrimaryColor),
                            ),*/
                          ),
                          height: 60,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(24, 16, 0, 0),
                      child: viewType == UserViewType.connection
                          ? Text(
                              selectedConnection.userName == ''
                                  ? 'Anonymous'
                                  : selectedConnection.userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                      color: myOnPrimaryColor,
                                      letterSpacing: 0),
                            )
                          : Text(
                              widget.userProfile.userName == ''
                                  ? 'Anonymous'
                                  : widget.userProfile.userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(color: myOnPrimaryColor),
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(24, 44, 0, 0),
                      child: Text(
                        Strings.drawerUserSince + ' ' + '$userSince',
                        style: Theme.of(context).textTheme.caption.copyWith(
                              color: myOnPrimaryColor,
                            ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(24, 92, 0, 0),
                      child: viewType == UserViewType.connection
                          ? Text(
                              '${selectedConnection.location.toUpperCase()} • ${selectedConnection.gender.toUpperCase()} • ${selectedConnection.age.toUpperCase()} • ${selectedConnection.workingIn.toUpperCase()}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: myOnSurfaceColor,
                                  ),
                            )
                          : Text(
                              '${widget.userProfile.location.toUpperCase()} • ${widget.userProfile.gender.toUpperCase()} • ${widget.userProfile.age.toUpperCase()} • ${widget.userProfile.workingIn.toUpperCase()}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: myOnSurfaceColor,
                                  ),
                            ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(24, 114, 0, 0),
                      child: viewType == UserViewType.connection
                          ? Text(
                              Strings.drawerFans +
                                  ' ${selectedConnection.fansCount}' +
                                  ' • ' +
                                  Strings.drawerViews +
                                  ' ${selectedConnection.views}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                      color: myOnSurfaceColor,
                                      fontWeight: FontWeight.w700),
                            )
                          : Text(
                              Strings.drawerFans +
                                  ' ${widget.userProfile.fansCount}' +
                                  ' • ' +
                                  Strings.drawerViews +
                                  ' ${widget.userProfile.views}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                      color: myOnSurfaceColor,
                                      fontWeight: FontWeight.w700),
                            ),
                    ),

                    // AVATAR START
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 22, 24, 0),
                          height: 96,
                          width: 96,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: viewType == UserViewType.connection
                                    ? selectedConnection.userPhoto == ''
                                        ? AssetImage('assets/user.png')
                                        : NetworkImage(
                                            selectedConnection.userPhoto)
                                    : widget.userProfile.userPhoto == ''
                                        ? AssetImage('assets/user.png')
                                        : NetworkImage(
                                            widget.userProfile.userPhoto),
                              )
                              // color: myErrorColor,
                              ),
                        ),
                      ],
                    ),
                    // AVATAR END
                  ],
                ),

                //THE BIG HEADER ENDS //

                // NAVIGATION HEADER STARTS //
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: mySurfaceColor),
                    ),
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
                            insets:
                                EdgeInsets.only(left: 0, right: 0, bottom: 0)),
                        isScrollable: true,
                        labelPadding: EdgeInsets.only(
                            left: 16, right: 12, top: 10, bottom: 4),
                        tabs: [
                          Tab(
                            child: Text(Strings.peopleFileCategoriesTab,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                          Tab(
                            child: Text(Strings.peopleFileItemsTab,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                          Tab(
                            child: Text(Strings.peopleFileAboutTab,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                          Tab(
                            child: Text(Strings.peopleFileConnectionsTab,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // NAVIGATION HEADER ENDS //

                // TABS CONTENT

                Expanded(
                  child: Container(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        //tab1
                        myPeopleGenreList(),
                        //tab2
                        myPeopleBookList(),
                        //tab3
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: viewType == UserViewType.connection
                              ? Text(
                                  selectedConnection.userStory == ''
                                      ? Strings.peopleFileNoStory
                                      : selectedConnection.userStory,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                          color: myOnBackgroundColor,
                                          height: 1.6),
                                )
                              : SelectableText(
                                  widget.userProfile.userStory == ''
                                      ? Strings.peopleFileNoStory
                                      : widget.userProfile.userStory,
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(
                                color: myAccentColor,
                                height: 1.6,
                                fontWeight: FontWeight.w700),
                                ),
                        ),
                    ),
                        //tab4
                        myPeopleConnectionList(),
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

  Widget myPeopleFileAppBar() {
    return AppBar(
      centerTitle: false,
      backgroundColor: myPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () => {Navigator.pop(context)},
      ),
      titleSpacing: 0.0,
      title: Text(
        '',
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
      actions: [
//        IconButton(icon: Icon(Icons.search, size: 20), onPressed: () {}),
//        IconButton(icon: Icon(Icons.share, size: 20), onPressed: () {}),

        IconButton(
            icon: Icon(Icons.chat, size: 20, color: myOnPrimaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      viewType == UserViewType.connection
                          ? Chat(
                              peerID: selectedConnection.userUid,
                              peerName: selectedConnection.userName,
                              peerUrl: selectedConnection.userPhoto,
                              peerEmail: selectedConnection.userEmail,
                            )
                          : Chat(
                              peerID: widget.userProfile.userUid,
                              peerName: widget.userProfile.userName,
                              peerUrl: widget.userProfile.userPhoto,
                              peerEmail: widget.userProfile.userEmail,
                            ),
                ),
              );
            }),
        Visibility(
          visible: viewType == UserViewType.connection ? false : true,
          child: Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: IconButton(
              icon: Icon(
                  widget.userProfile.fansList.isEmpty
                      ? Icons.bookmark_border
                      : widget.userProfile.fansList
                              .contains(prefsObject.getString('uid'))
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                  size: 24,
                  color: myOnPrimaryColor),
              onPressed: () {
                addAndRemoveToBookmarked(widget.userProfile);
              },
            ),
          ),
        ),
        Visibility(
          visible: viewType == UserViewType.connection ? false : true,
          child: PopupMenuButton<String>(
            icon: Icon(Icons.report, size: 24, color: myOnPrimaryColor),
            onSelected: (result) async {
              if (result == Strings.blockUser) {
                selectedBlockOption = await AlertBoxDialog()
                    .showCustomAlertDialog(context, Strings.blockUserHeader,
                        Strings.blockUserWarning, [Strings.ok, Strings.cancel]);
                if (selectedBlockOption == Strings.ok) {
                  await userGenreBlocNew
                      .blockUser(widget.userProfile.userUid)
                      .then((result) {
                    if (result[0]) {
                      bookLoversBloc.bookLoversList(0);
                      _key.currentState.showSnackBar(
                        SnackBar(
                          content: Text(
                            'User Blocked',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: myOnPrimaryColor),
                          ),
                          duration: Duration(milliseconds: 800),
                        ),
                      );
                      Future.delayed(Duration(milliseconds: 1200)).then((_) {
                        Navigator.of(context).pop();
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
                } else {}
              } else {
                _sendReportEmail();
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
    );
  }

  Widget myPeopleGenreList() {
    return Container(
      child: StreamBuilder(
        stream: userGenreBlocNew.userGenreStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
              ),
            );
          } else {
            return snapshot.data.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        Strings.peopleFileNoCategories,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: myOnPrimaryColor),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return myPeopleCategoryTile(snapshot.data, index);
                    },
                  );
          }
        },
      ),
    );
  }

  Widget myPeopleCategoryTile(dynamic userGenreList, int index) {
    return GestureDetector(
      onTap: () {
        selectedGenreTile = userGenreList[index];
        tabController.animateTo((tabController.index + 1) % 2);
      },
      child: Container(
        height: 72,
        margin: EdgeInsets.only(left: 24, top: 0, right: 24, bottom: 0),
        padding: EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: mySurfaceColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                userGenreList[index].genreName.toString().toUpperCase(),
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
                  padding: EdgeInsets.fromLTRB(0, 12, 12, 12),
                  child: Text(
                    userGenreList[index].booksCount,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: myOnBackgroundColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myPeopleBookList() {
    return Container(
      child: StreamBuilder(
        stream: userBookBloc.userGenreStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  Strings.peopleFileNoItems,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: myOnPrimaryColor),
                ),
              ),
            );
//              Center(
//              child: CircularProgressIndicator(
//                valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
//              ),
//            );
          } else {
            return snapshot.data.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        Strings.peopleFileNoItemInCategory,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: myOnPrimaryColor),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return Column(
                        children: [
                          genreTile(snapshot.data, index),
                          StreamBuilder(
                            stream: userBookBloc.userBookStream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data[index].length,
                                  itemBuilder: (context, int j) {
                                    return bookTile(snapshot.data[index], j);
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
          }
        },
      ),
    );
  }

  Widget myPeopleConnectionList() {
    return Container(
      child: StreamBuilder(
        stream: userConnectionBlocNew.userConnectionStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
              ),
            );
          } else {
            return snapshot.data.length == 0
                ? Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        Strings.peopleFileNoConnections,
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(
                            color: myAccentColor,
                            height: 1.6,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return myPeopleConnection(snapshot.data, index);
                    },
                  );
          }
        },
      ),
    );
  }

  Widget myPeopleConnection(dynamic userConnection, int index) {
    return GestureDetector(
      onTap: () {
        if (userConnection[index].userUid != prefsObject.getString('uid')) {
          viewType = UserViewType.connection;
          selectedConnection = userConnection[index];
          tabController.animateTo((tabController.index - 3) % 2);
          setState(() {});
        } else {
          PlatformAlertDialog(
            title: Strings.userConnection,
            content: Strings.userConnectionWarning,
            defaultActionText: Strings.ok,
          ).show(context);
        }
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
                          image: userConnection[index].userPhoto == ''
                              ? AssetImage('assets/user.png')
                              : NetworkImage(userConnection[index].userPhoto),
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
                            userConnection[index].userName == ''
                                ? 'Anonymous'
                                : userConnection[index].userName,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: myPrimaryColor),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 2),
                          child: Text(
                            userConnection[index].booksCount == ''
                                ? Strings.peopleTileInventoryZero
                                : Strings.peopleTileInventoryText +
                                    ' ${userConnection[index].booksCount}',
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
                                ' ${userConnection[index].fansCount}',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: myOnBackgroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: userConnection[index].libraryStatus
                      ? Icon(Icons.lock, color: myOnBackgroundColor, size: 16)
                      : Icon(Icons.lock_open,
                          color: myOnBackgroundColor, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget genreTile(dynamic genre, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 56,
        /*margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),*/
        padding: EdgeInsets.only(left: 24, top: 8, right: 24, bottom: 8),
        decoration: BoxDecoration(
          color: mySurfaceColor,
          border: Border(
            bottom: BorderSide(width: 0.5, color: myOnBackgroundColor),
            top: BorderSide(width: 0.5, color: myOnBackgroundColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                genre[index].toUpperCase().split('*')[0],
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
                  padding: EdgeInsets.fromLTRB(0, 12, 12, 12),
                  child: Text(
                    genre[index].split('*')[1],
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: myOnBackgroundColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bookTile(dynamic bookList, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyItem(
              bookDetails: bookList[index],
              viewType: BookViewType.bookLover,
              bookLoverName: widget.userProfile.userName,
            ),
          ),
        );
      },
      child: Container(
        height: 72,
        margin: EdgeInsets.only(left: 24, top: 0, right: 24, bottom: 0),
        padding: EdgeInsets.only(left: 0, top: 4, right: 0, bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: mySurfaceColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Visibility(
                      visible:
                          bookList[index].bookVolumes == '1' ? false : true,
                      child: CircleAvatar(
                        backgroundColor: myOnBackgroundColor,
                        radius: 10,
                        child: Text(
                          bookList[index].bookVolumes,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: myBackgroundColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          bookList[index].bookName,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: myOnBackgroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.favorite,
                      color: bookList[index].isFavourite
                          ? myAccentColor
                          : mySurfaceColor,
                      size: 20),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                  child: Icon(Icons.photo,
                      color: bookList[index].bookPhoto == ''
                          ? mySurfaceColor
                          : myAccentColor,
                      size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  dynamic addAndRemoveToBookmarked(userData) async {
    if (userData.fansList.isEmpty) {
      await bookLoversBloc
          .addAndRemoveToBookmarked(userData.userUid, true)
          .then((result) {
        if (result[0]) {
          widget.userProfile.fansCount = widget.userProfile.fansCount + 1;
          widget.userProfile.fansList.add(prefsObject.getString('uid'));
          setState(() {});
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
    } else if (userData.fansList.contains(prefsObject.getString('uid'))) {
      await bookLoversBloc
          .addAndRemoveToBookmarked(userData.userUid, false)
          .then((result) {
        if (result[0]) {
          widget.userProfile.fansCount = widget.userProfile.fansCount - 1;
          widget.userProfile.fansList.remove(prefsObject.getString('uid'));
          setState(() {});
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
          .addAndRemoveToBookmarked(userData.userUid, true)
          .then((result) {
        if (result[0]) {
          widget.userProfile.fansCount = widget.userProfile.fansCount + 1;
          widget.userProfile.fansList.add(prefsObject.getString('uid'));
          setState(() {});
          _key.currentState.showSnackBar(
            SnackBar(
              content: Text(
                Strings.peopleBookmarkedTextSnack,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
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

  dynamic viewProfile() async {
    await bookLoversBloc
        .addUserViewCount(widget.userProfile.userUid, widget.userProfile.views)
        .then((result) {
      if (result[0]) {
        widget.userProfile.views = widget.userProfile.views + 1;
        setState(() {});
      } else {
        if (result[1] != null) {
          PlatformAlertDialog(
            title: Strings.addView,
            content: Strings.addViewError,
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

  dynamic _sendReportEmail() async {
    final String url = 'mailto:byebyedotio@gmail.com?'
        'subject=User report&body=This%20is%20in%20regard%20with%20the%20activity%20of%20the%20Byebye%20app%20user,%20identified%20with%20User%20ID:%20"${widget.userProfile.userUid}".%20Please%20find%20below%20the%20reason%20of%20reporting:';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
