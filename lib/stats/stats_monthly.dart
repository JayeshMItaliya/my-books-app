import 'package:byebye_flutter_app/bloc/book_bloc.dart';
import 'package:byebye_flutter_app/bloc/user_stats_monthly_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/constants.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/library/item_add_new.dart';
import 'package:byebye_flutter_app/library/item_details.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../my_constants/design_system.dart';

class MyStatsMonthly extends StatefulWidget {
  @override
  _MyStatsMonthlyState createState() => _MyStatsMonthlyState();
}

class _MyStatsMonthlyState extends State<MyStatsMonthly> {
  final _key = GlobalKey<ScaffoldState>();
  List<String> popUpOption;
  String selectedButtonOption;
  DateTime selectedDate;
  var monthFormat = intl.DateFormat('MMM-yyyy');
  dynamic selectedOption;
  String selectedTimeInterval;

  @override
  void initState() {
    userStatsMonthlyBloc.updateSelectedMonthlyTime(Strings.statsCurrentMonth);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    popUpOption = <String>[
      Strings.inventoryItemListEdit,
      Strings.inventoryItemListDelete,
    ];
    return Scaffold(
      key: _key,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 14),
          timePeriodDropdown(),
          SizedBox(height: 8),
          /*Divider(thickness: .5, color: myOnBackgroundColor, indent: 24, endIndent: 24),*/
          myList(),
        ],
      ),
    );
  }

  Widget timePeriodDropdown() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Container(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: <String>[
                Strings.statsCurrentMonth,
                Strings.statsLastMonth,
                Strings.statsCustom,
              ].map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                      textAlign: TextAlign.left),
                );
              }).toList(),
              hint: StreamBuilder<dynamic>(
                  initialData: '',
                  stream: userStatsMonthlyBloc.timePeriodMonthlyStream,
                  builder: (context, snapshot) {
                    selectedOption = snapshot.data ?? Strings.statsCurrentMonth;
                    return SizedBox(
                      width: 200.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            selectedOption == ''
                                ? Strings.statsCurrentMonth.toUpperCase()
                                : selectedOption.toString().toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.button,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    );
                  }),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              onChanged: (value) {
                selectedTimeInterval = value;
                if (value != Strings.statsCustom) {
                  userStatsMonthlyBloc.updateSelectedMonthlyTime(value);
                } else {
                  monthPicker();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  dynamic monthPicker() {
    final month = prefsObject.getString('selectedMonth');
    if (month != null) {
      final DateTime selectedMonth = DateTime.parse(month);
      return showMonthPicker(
              context: context,
              firstDate: DateTime(DateTime.now().year - 50),
              lastDate: DateTime(DateTime.now().year + 100),
              initialDate:
                  selectedMonth != null ? selectedMonth : DateTime.now())
          .then((date) {
        if (date != null) {
          setState(() {
            prefsObject.setString('selectedMonth', '$date');
            selectedDate = date;
          });
          userStatsMonthlyBloc.updateCustomRange(selectedDate);
        }
      });
    } else {
      return showMonthPicker(
              context: context,
              firstDate: DateTime(DateTime.now().year - 50),
              lastDate: DateTime(DateTime.now().year + 100),
              initialDate: DateTime.now())
          .then((date) {
        if (date != null) {
          setState(() {
            prefsObject.setString('selectedMonth', '$date');
            selectedDate = date;
          });
          userStatsMonthlyBloc.updateCustomRange(selectedDate);
        }
      });
    }
  }

  Widget myList() {
    return Expanded(
      child: StreamBuilder<dynamic>(
        stream: userStatsMonthlyBloc.selectedFilterDataStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
              ),
            );
          }
          return snapshot.data.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      Strings.noRecordFound,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: myOnSurfaceColor),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index) {
                    return myItemTile(snapshot.data, index);
                  },
                );
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
        ).then((onValue) {
          if (selectedOption == Strings.statsCurrentMonth ||
              selectedOption == Strings.statsLastMonth) {
            userStatsMonthlyBloc.getMonthlyStats(monthlyValue: selectedOption);
          } else {
            userStatsMonthlyBloc.getspecificBook(
                value: Strings.statsCustom, selectedMonth: selectedDate);
          }
        });
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
                              if (selectedOption == Strings.statsCurrentMonth ||
                                  selectedOption == Strings.statsLastMonth) {
                                userStatsMonthlyBloc.getMonthlyStats(
                                    monthlyValue: selectedOption);
                              } else {
                                userStatsMonthlyBloc.getspecificBook(
                                    value: Strings.statsCustom,
                                    selectedMonth: selectedDate);
                              }
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
                              if (selectedOption == Strings.statsCurrentMonth ||
                                  selectedOption == Strings.statsLastMonth) {
                                userStatsMonthlyBloc.getMonthlyStats(
                                    monthlyValue: selectedOption);
                              } else {
                                userStatsMonthlyBloc.getspecificBook(
                                    value: Strings.statsCustom,
                                    selectedMonth: selectedDate);
                              }
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
                      ).then((onValue) {
                        if (selectedOption == Strings.statsCurrentMonth ||
                            selectedOption == Strings.statsLastMonth) {
                          userStatsMonthlyBloc.getMonthlyStats(
                              monthlyValue: selectedOption);
                        } else {
                          userStatsMonthlyBloc.getspecificBook(
                              value: Strings.statsCustom,
                              selectedMonth: selectedDate);
                        }
                      });
                    } else {
                      deleteBook(
                              bookList[index].bookId, bookList[index].bookName)
                          .then((onValue) {
                        if (selectedOption == Strings.statsCurrentMonth ||
                            selectedOption == Strings.statsLastMonth) {
                          userStatsMonthlyBloc.getMonthlyStats(
                              monthlyValue: selectedOption);
                        } else {
                          userStatsMonthlyBloc.getspecificBook(
                              value: Strings.statsCustom,
                              selectedMonth: selectedDate);
                        }
                      });
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

  Future deleteBook(bookId, bookName) async {
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
