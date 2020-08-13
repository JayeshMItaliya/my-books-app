import 'package:byebye_flutter_app/bloc/book_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/constants.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/library/item_add_new.dart';
import 'package:byebye_flutter_app/library/item_details.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';

import '../my_constants/design_system.dart';

class MyItemList extends StatefulWidget {
  const MyItemList({this.genreDetails});

  final dynamic genreDetails;

  @override
  _MyItemListState createState() => _MyItemListState();
}

class _MyItemListState extends State<MyItemList> with TickerProviderStateMixin {
  final _key = GlobalKey<ScaffoldState>();
  final searchController = TextEditingController();
  TabController tabController;
  bool activeSearch = false;
  List<String> popUpOption;
  String selectedButtonOption;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bookBloc.bookList(widget.genreDetails.genreName, tabController.index);
    bookBloc.aboutBook(widget.genreDetails.genreName);
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        bookBloc.bookList(widget.genreDetails.genreName, tabController.index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    popUpOption = <String>[
      Strings.inventoryItemListEdit,
      Strings.inventoryItemListDelete,
    ];
    //theme:
    MyFirstTheme().theme;
    return Scaffold(
      key: _key,
      appBar: myItemsListAppBar(),
      body: Container(
        child: DefaultTabController(
          length: 3,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: mySurfaceColor,
                    /*border: Border(
                      bottom: BorderSide(width: 0.5, color: myPrimaryColor),
                    ),*/
                  ),
                  child: StreamBuilder<dynamic>(
                      stream: bookBloc.aboutBooksStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.aboutBooks.isEmpty) {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              MyHorizontalReportTile(
                                  Strings.inventoryStripeItems, 0),
                              MyHorizontalReportTile(
                                  Strings.inventoryItemStripeValue, 0),
                              MyHorizontalReportTile(
                                  Strings.inventoryItemStripeFavourite, 0),
                              MyHorizontalReportTile(
                                  Strings.inventoryStripeRegrets, 0),
//                              MyHorizontalReportTile('OTHER PARAM.', 000),
                            ],
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              MyHorizontalReportTile(
                                  Strings.inventoryStripeItems,
                                  snapshot.data.aboutBooks[0].toString()),
                              MyHorizontalReportTile(
                                  Strings.inventoryItemStripeValue,
                                  snapshot.data.aboutBooks[1].toString()),
                              MyHorizontalReportTile(
                                  Strings.inventoryItemStripeFavourite,
                                  snapshot.data.aboutBooks[2].toString()),
                              MyHorizontalReportTile(
                                  Strings.inventoryStripeRegrets,
                                  snapshot.data.aboutBooks[3].toString()),
//                              MyHorizontalReportTile('OTHER PARAM.', 000),
                            ],
                          );
                        }
                      }),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: mySurfaceColor),
                    ),
                  ),
                  height: 56,
                  child: Row(
                    children: [
                      TabBar(
                        controller: tabController,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 4,
                            color: myPrimaryColor,
                          ),
                          insets: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                        ),
                        isScrollable: true,
                        labelPadding: EdgeInsets.only(
                            left: 24, right: 12, top: 10, bottom: 4),
                        tabs: [
                          Tab(
                            child: Text(Strings.inventoryItemTabAtoZ,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                          Tab(
                            child: Text(Strings.inventoryItemTabFavourites,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                          Tab(
                            child: Text(Strings.inventoryItemListRegrets,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: myList(),
//                  child: tabController.index == 0
//                      ? myList()
//                      : tabController.index == 1 ? myList() : myList(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:
          myFloatingActionButtonAddProduct(widget.genreDetails.genreName),
    );
  }

  ///When user didn't have any items show this UI.
  Widget emptyItemListUi() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          Text(
            Strings.inventoryNowAddItems,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: myOnBackgroundColor, fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Strings.inventoryHintData1,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: myOnBackgroundColor, fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Strings.inventoryHintData2,
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
            Strings.inventoryHintData3,
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: myOnBackgroundColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget myItemsListAppBar() {
    final String _myAppBarText = widget.genreDetails.genreName.toUpperCase();

    return AppBar(
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () => {Navigator.pop(context)},
      ),
      titleSpacing: 0.0,
      title: !activeSearch
          ? Text(
              '$_myAppBarText',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: myOnPrimaryColor),
            )
          : TextField(
              autofocus: true,
              onChanged: (value) {
                bookBloc.searchBook(value);
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
//              IconButton(
//                icon: Icon(Icons.share, color: myOnPrimaryColor),
//                onPressed: () {},
//              ),
              IconButton(
                icon: Icon(Icons.search, color: myOnPrimaryColor),
                onPressed: () {
                  activeSearch = !activeSearch;
                  setState(() {});
                },
              ),
            ]
          : [
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: myOnPrimaryColor,
                ),
                onPressed: () {
                  searchController.clear();
                  bookBloc.searchBook('');
                  activeSearch = !activeSearch;
                  setState(() {});
                },
              )
            ],
    );
  }

  Widget myList() {
    return Container(
      child: StreamBuilder<dynamic>(
        stream: bookBloc.booksStream,
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
                    child: tabController.index == 0
                        ? emptyItemListUi()
                        : bookBloc.testListTwo.length > 0
                            ? Text(
                                Strings.noDataFound,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(
                                        color: myAccentColor,
                                        height: 1.6,
                                        fontWeight: FontWeight.w700),
                              )
                            : emptyItemListUi()
//                  child:
//                  tabController.index == 0
//                      ? emptyItemListUi()
//                      :
//                  Text(
//                          Strings.noDataFound,
//                          style: Theme.of(context).textTheme.button.copyWith(
//                              color: myOnBackgroundColor, fontSize: 22),
//                        ),
                    // Text(
                    //   tabController.index == 0
                    //       ? Strings.searchBarMessageNoFound
                    //       : tabController.index == 1
                    //           ? Strings.searchBarMessageNoFound
                    //           : Strings.searchBarMessageNoFound,
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .subtitle2
                    //       .copyWith(color: Colors.red),
                    // ),
                    //original version by Parth of the child:Text below
                    /*child: Text(
                    tabController.index == 0
                        ? 'You don\'t have any book in ${widget.genreDetails.genreName} Genre OR No match found.'
                        : tabController.index == 1
                            ? 'You don\'t have any favourite book from ${widget.genreDetails.genreName} Genre in your favourites list OR No match found.'
                            : 'You don\'t have any regret book from ${widget.genreDetails.genreName} Genre in your regret list OR No match found.',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: myOnPrimaryColor),
                  ),*/
                    ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return myItemTile(snapshot.data, index);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget myItemTile(dynamic bookList, index) {
    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (context) => MyItem(
              bookDetails: bookList[index],
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
            bottom: BorderSide(width: 1, color: mySurfaceColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width - 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible:
                          bookList[index].bookVolumes == '1' ? false : true,
                      child: CircleAvatar(
                        backgroundColor: myOnBackgroundColor,
                        radius: 11,
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
                  child: GestureDetector(
                    onTap: () {
                      if (bookList[index].regretOfBook != '') {
                        PlatformAlertDialog(
                          title: Strings.addToFavourite,
                          content: Strings.addToFavouriteError,
                          defaultActionText: Strings.cancel,
                        ).show(context);
                      } else {
                        if (bookList[index].isFavourite) {
                          bookBloc
                              .addAndRemoveToFav(bookList[index].bookId, false)
                              .then((result) {
                            if (result[0]) {
                              bookBloc.bookList(widget.genreDetails.genreName,
                                  tabController.index);
                              bookBloc.aboutBook(widget.genreDetails.genreName);
                              _key.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: myAccentColor,
                                  content: Text(
                                    Strings.removedFromFavourite,
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
                          bookBloc
                              .addAndRemoveToFav(bookList[index].bookId, true)
                              .then((result) {
                            if (result[0]) {
                              bookBloc.bookList(widget.genreDetails.genreName,
                                  tabController.index);
                              bookBloc.aboutBook(widget.genreDetails.genreName);
                              _key.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: myAccentColor,
                                  content: Text(
                                    Strings.addedToFavourite,
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
                    },
                    child: Container(
                      color: myBackgroundColor,
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.favorite,
                          color: bookList[index].isFavourite
                              ? myAccentColor
                              : mySurfaceColor,
                          size: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: Icon(Icons.photo,
                      color: bookList[index].bookPhoto == ''
                          ? mySurfaceColor
                          : myAccentColor,
                      size: 16),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 16,
                    color: myOnBackgroundColor,
                  ),
                  onSelected: (result) {
                    if (result == Strings.inventoryItemListEdit) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MyNewItem(
                            itemType: BookCreateType.editBook,
                            editType: BookEditType.fromBookList,
                            bookDetails: bookList[index],
                          ),
                        ),
                      );
                    } else {
                      deleteBook(
                          bookList[index].bookId, bookList[index].bookName);
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myFloatingActionButtonAddProduct(genreName) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (context) => MyNewItem(
              genreName: genreName,
            ),
          ),
        );
      },
      backgroundColor: myAccentColor,
      foregroundColor: myOnPrimaryColor,
      elevation: 0,
      mini: false,
      child: Icon(
        Icons.add,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(36.0),
        ),
      ),
    );
  }

  dynamic deleteBook(bookId, bookName) async {
    selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
        context,
        Strings.bookDelete,
        Strings.bookDeleteWarning,
        [Strings.ok, Strings.cancel]);
    if (selectedButtonOption == Strings.ok) {
      Loader().showLoader(context);
      await bookBloc.deleteBook(bookId, bookName).then((result) {
        if (result[0]) {
          Loader().hideLoader(context);
          bookBloc.aboutBook(widget.genreDetails.genreName);
          bookBloc.bookList(widget.genreDetails.genreName, tabController.index);
          _key.currentState.showSnackBar(
            SnackBar(
              backgroundColor: myAccentColor,
              content: Text(
                Strings.itemDeleted,
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
}

class MyItemTile extends StatelessWidget {
  const MyItemTile(this._myItemName);

  final String _myItemName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
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
            child: Text(
              '$_myItemName',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: myOnBackgroundColor),
            ),
            onTap: () {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(builder: (context) => MyItem()),
              );
            },
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.favorite, color: mySurfaceColor, size: 16),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child:
                    Icon(Icons.shopping_cart, color: mySurfaceColor, size: 16),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.photo, color: mySurfaceColor, size: 16),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, size: 16),
                color: myOnBackgroundColor,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
