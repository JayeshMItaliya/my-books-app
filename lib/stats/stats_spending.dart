import 'package:byebye_flutter_app/bloc/user_stats_bloc.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/stats_genre_helper.dart';
import 'package:byebye_flutter_app/stats/stats_vertical_bar_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:month_picker_dialog/month_picker_dialog.dart';

class MyStatsSpending extends StatefulWidget {
  @override
  _MyStatsSpendingState createState() => _MyStatsSpendingState();
}

class _MyStatsSpendingState extends State<MyStatsSpending> {
  final startMonthController = TextEditingController();
  final endMonthController = TextEditingController();
  DateTime selectedDate;
  var monthFormat = intl.DateFormat('MMM-yyyy');
  DateTime selectedStartDate;
  DateTime selectedEndDate;
  dynamic selectedOption;
  String selectedGenre;
  List<String> specificGenreList;
  final _formKey = GlobalKey<FormState>();
  bool _isSpentBook = false;
  bool _isShowData = true;
  String avgPrice;
  String fractionalAvg;
  String selectedTimeInterval;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          // choose interval  start
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Container(
                    child: timePeriodDropdown(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Container(
                    child: genreDropdown(),
                  ),
                ),
              ],
            ),
          ),
// choose interval + choose genres - end
          StreamBuilder<List<dynamic>>(
            stream: userStatsBloc.libraryStatsStream,
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isNotEmpty) {
                  avgPrice = (snapshot.data[0].totalBookValue /
                          snapshot.data[0].totalBook)
                      .toString();
                  avgPrice.contains('.')
                      ? fractionalAvg = avgPrice.split('.')[1]
                      : fractionalAvg = '00';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // column 1 (VALUE/BOOKS/AVG) - start
                      Container(
                        padding: EdgeInsets.fromLTRB(24, 0, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(Strings.statsBooksValue,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ),
                                  Container(
                                    child: Text(
                                        !snapshot.hasData
                                            ? '0'
                                            : snapshot.data[0].totalBookValue ==
                                                    0
                                                ? '0'
                                                : snapshot
                                                    .data[0].totalBookValue
                                                    .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: myPrimaryColor, width: 3.0),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      Strings.statsBooksVolume,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                        !snapshot.hasData
                                            ? '0'
                                            : snapshot.data[0].totalBook == 0
                                                ? '0'
                                                : snapshot.data[0].totalBook
                                                    .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: myPrimaryColor, width: 3.0),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      Strings.statsBooksAvgPrice,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                            !snapshot.hasData
                                                ? '0'
                                                : snapshot.data[0]
                                                            .totalBookValue ==
                                                        0
                                                    ? '0'
                                                    : (snapshot.data[0]
                                                                .totalBookValue /
                                                            snapshot.data[0]
                                                                .totalBook)
                                                        .toString()
                                                        .split('.')[0],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                      ),
                                      Container(
                                        child: Text(
                                            !snapshot.hasData
                                                ? '0'
                                                : snapshot.data[0]
                                                            .totalBookValue ==
                                                        0
                                                    ? '00'
                                                    : fractionalAvg.length >= 2
                                                        ? fractionalAvg
                                                            .substring(0, 2)
                                                        : '00',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: myPrimaryColor, width: 3.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // column 1 (VALUE/BOOKS/AVG) - end

                      SizedBox(width: 4),

                      // column 2 (REGRET) - start
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      Strings.statsBooksRegretValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myAccentColor),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          !snapshot.hasData
                                              ? '0'
                                              : snapshot.data[0]
                                                          .totalRegretBookValue ==
                                                      0
                                                  ? '0'
                                                  : snapshot.data[0]
                                                      .totalRegretBookValue
                                                      .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      Strings.statsBooksRegretValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myAccentColor),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          !snapshot.hasData
                                              ? '0'
                                              : snapshot.data[0]
                                                          .totalRegretBook ==
                                                      0
                                                  ? '0'
                                                  : snapshot
                                                      .data[0].totalRegretBook
                                                      .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 4),
                      // column 2 (REGRET) - end

                      // column 3 (%) - start
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myAccentColor),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          !snapshot.hasData
                                              ? '0'
                                              : snapshot.data[0]
                                                          .totalRegretBookValue ==
                                                      0
                                                  ? '0'
                                                  : ((snapshot.data[0]
                                                                  .totalRegretBookValue *
                                                              100) /
                                                          snapshot.data[0]
                                                              .totalBookValue)
                                                      .toString()
                                                      .split('.')[0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myAccentColor),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          !snapshot.hasData
                                              ? '0'
                                              : snapshot.data[0]
                                                          .totalRegretBookValue ==
                                                      0
                                                  ? '0'
                                                  : ((snapshot.data[0]
                                                                  .totalRegretBook *
                                                              100) /
                                                          snapshot.data[0]
                                                              .totalBook)
                                                      .toString()
                                                      .split('.')[0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // column 3 (%) - end
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // column 1 (VALUE/BOOKS/AVG) - start
                      Container(
                        padding: EdgeInsets.fromLTRB(24, 0, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(Strings.statsBooksValue,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ),
                                  Container(
                                    child: Text('0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: myPrimaryColor, width: 3.0),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      Strings.statsBooksVolume,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Container(
                                    child: Text('0',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: myPrimaryColor, width: 3.0),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      Strings.statsBooksAvgPrice,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text('00',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5),
                                      ),
                                      Container(
                                        child: Text('00',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    width: 70,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: myPrimaryColor, width: 3.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // column 1 (VALUE/BOOKS/AVG) - end

                      SizedBox(width: 4),

                      // column 2 (REGRET) - start
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      Strings.statsBooksRegretValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myAccentColor),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          '0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      Strings.statsBooksRegretValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myAccentColor),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Text(
                                          '0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 4),
                      // column 2 (REGRET) - end

                      // column 3 (%) - start
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myAccentColor),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          '0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: myAccentColor),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          '0',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(color: myAccentColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // column 3 (%) - end
                    ],
                  );
                }
              } else {
                return Container();
              }
            },
          ),
          SizedBox(height: 8),
          //CHART AREA - start

          Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: StreamBuilder<List<SubscriberSeries>>(
              stream: _isSpentBook
                  ? userStatsBloc.bookGraphStream
                  : userStatsBloc.spentGraphStream,
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
                          height: 150,
                          color: mySurfaceColor,
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              Strings.statsNoBarChartAvailable,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: myPrimaryColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : MyVerticalBarChart(
                          data: snapshot.data,
                          showData: _isShowData,
                        );
                }
              },
            ),
          ),

          //CHART AREA - end

          //SWITCHERS AREA - start

          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      Strings.statsYAxisValueSpent,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnBackgroundColor),
                    ),
                    spentBooksSwitch(),
                    Text(
                      Strings.statsYAxisValueBooks,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnBackgroundColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnBackgroundColor),
                    ),
                    showDataSwitch(),
                    Text(
                      Strings.statsShowValuesOfChart,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnBackgroundColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                Strings.statsAllTime,
                Strings.statsCurrentYear,
                Strings.statsLastYear,
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
                  stream: userStatsBloc.timePeriodStream,
                  builder: (context, snapshot) {
                    selectedOption = snapshot.data;
                    return SizedBox(
                      width: 200.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            selectedOption == ''
                                ? Strings.statsCurrentYear.toUpperCase()
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
                userStatsBloc.genreValue.sink.add(Strings.statsWholeInventory);
                if (value != Strings.statsCustom) {
                  userStatsBloc.updateSelectedTime(value);
                } else {
                  customMonthDialog();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> customMonthDialog() {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            height: 260,
            padding:
                const EdgeInsets.only(top: 0, bottom: 10, left: 0, right: 0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    /*color: myPrimaryColor,*/
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Text(
                          Strings.statsSelectCustomMonths.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: myOnBackgroundColor),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: myAccentColor,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: monthRangeInput(),
                  ),
                ),
                Container(
                  height: 50,
                  child: rangeSelectButton(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget monthRangeInput() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Container(
          height: 150.0,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: startMonthController,
                textAlign: TextAlign.center,
                readOnly: true,
                textCapitalization: TextCapitalization.sentences,
                onTap: () {
                  monthPicker(1);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return Strings.statsSelectStartMonth;
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: myPrimaryColor),
                decoration: InputDecoration(
                  hintText: Strings.statsStartMonth,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: myPrimaryColor),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: endMonthController,
                textAlign: TextAlign.center,
                readOnly: true,
                textCapitalization: TextCapitalization.sentences,
                onTap: () {
                  monthPicker(2);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return Strings.statsSelectEndMonth;
                  }
                  return null;
                },
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: myPrimaryColor),
                decoration: InputDecoration(
                  hintText: Strings.statsEndMonth,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: myPrimaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rangeSelectButton() {
    return MaterialButton(
        color: myAccentColor,
        child: Text(
          Strings.ok,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: myOnPrimaryColor),
        ),
        height: 50,
        minWidth: 286,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            userStatsBloc.updateCustomRange(
                selectedTimeInterval, selectedStartDate, selectedEndDate);
            Navigator.of(context).pop();
            startMonthController.clear();
            endMonthController.clear();
          }
        });
  }

  dynamic monthPicker(type) {
    return showMonthPicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 50),
            lastDate: DateTime(DateTime.now().year + 100),
            initialDate: DateTime.now())
        .then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          if (type == 1) {
            startMonthController.text = monthFormat.format(selectedDate);
            selectedStartDate = selectedDate;
          } else {
            endMonthController.text = monthFormat.format(selectedDate);
            selectedEndDate = selectedDate;
          }
        });
      }
    });
  }

  Widget genreDropdown() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Container(
          child: DropdownButtonHideUnderline(
            child: StreamBuilder<List<String>>(
                initialData: const [],
                stream: userStatsBloc.specificGenreStream,
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  specificGenreList = snapshot.data;
                  return DropdownButton<String>(
                    items: specificGenreList.map((String value) {
                      return DropdownMenuItem(
                        value: value ?? '',
                        child: SizedBox(
                          width: 200.0,
                          child: Text(value.toUpperCase(),
                              style: Theme.of(context).textTheme.button,
                              textAlign: TextAlign.left),
                        ),
                      );
                    }).toList(),
                    hint: StreamBuilder<String>(
                        stream: userStatsBloc.genreStream,
                        builder: (context, snapshot) {
                          selectedGenre = snapshot.data;
                          return SizedBox(
                            width: 200.0,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                    specificGenreList.isEmpty
                                        ? ''
                                        : selectedGenre != null
                                            ? selectedGenre.toUpperCase()
                                            : Strings.statsWholeInventory
                                                .toUpperCase(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.button,
                                    textAlign: TextAlign.left),
                              ),
                            ),
                          );
                        }),
                    style: Theme.of(context).textTheme.button,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    onChanged: (value) {
                      if (selectedTimeInterval == Strings.statsCustom) {
                        userStatsBloc.updateGenreValue(value,
                            timePeriod: selectedTimeInterval,
                            startDate: selectedStartDate,
                            endDate: selectedEndDate);
                      } else {
                        userStatsBloc.updateGenreValue(value,
                            timePeriod: selectedOption);
                      }
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget spentBooksSwitch() {
    return Switch(
      activeColor: myAccentColor,
      inactiveThumbColor: myAccentColor,
      activeTrackColor: mySurfaceColor,
      inactiveTrackColor: mySurfaceColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: (val) {
        setState(() {
          return _isSpentBook = val;
        });
      },
      value: _isSpentBook,
    );
  }

  Widget showDataSwitch() {
    return Switch(
      activeColor: myAccentColor,
      inactiveThumbColor: myAccentColor,
      activeTrackColor: mySurfaceColor,
      inactiveTrackColor: mySurfaceColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: (val) {
        setState(() {
          return _isShowData = val;
        });
      },
      value: _isShowData,
    );
  }
}
