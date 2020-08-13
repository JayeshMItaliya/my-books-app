import 'package:byebye_flutter_app/bloc/user_breakdown_bloc.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/stats_genre_breakdown_helper.dart';
import 'package:byebye_flutter_app/stats/stats_donut_pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart' as intl;

import '../my_constants/design_system.dart';

class MyStatsBreakDown extends StatefulWidget {
  @override
  _MyStatsBreakDownState createState() => _MyStatsBreakDownState();
}

class _MyStatsBreakDownState extends State<MyStatsBreakDown> {
  final startMonthController = TextEditingController();
  final endMonthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedStartDate;
  DateTime selectedEndDate;
  var monthFormat = intl.DateFormat('MMM-yyyy');
  DateTime selectedDate;
  dynamic selectedOption;
  bool _isSpentBook = false;
  bool _isShowData = false;
  int totalGenreValue = 0;
  int totalBooks = 0;
  String avgPrice;
  String fractionalAvg;
  String selectedTimeInterval;

  @override
  void initState() {
    super.initState();
    getInitStatsData();
    userBreakdownBloc.updateSelectedTime(Strings.statsCurrentYear);
  }

  dynamic getInitStatsData() async {
    await userBreakdownBloc.getSpecificGenre(prefsObject.getString('uid'),
        value: Strings.statsCurrentYear);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          // start
// choose interval  start
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Container(
                    child: timePeriodDropdown(),
                  ),
                ),
              ],
            ),
          ),
// choose interval + choose genres - end
          StreamBuilder<List<dynamic>>(
              stream: userBreakdownBloc.libraryStatsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  totalGenreValue = snapshot.data[0].totalBookValue;
                  totalBooks = snapshot.data[0].totalBook;
                }
                if (snapshot.hasData) {
                  avgPrice = (snapshot.data[0].totalBookValue /
                          snapshot.data[0].totalBook)
                      .toString();
                  avgPrice.contains('.')
                      ? fractionalAvg = avgPrice.split('.')[1]
                      : fractionalAvg = '00';
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // column 1 (VALUE) - start

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
                                  child: Text(
                                    Strings.statsBooksValue,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                      !snapshot.hasData
                                          ? '0'
                                          : snapshot.data[0].totalBookValue == 0
                                              ? '0'
                                              : snapshot.data[0].totalBookValue
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
                        ],
                      ),
                    ),
                    // column 1 (VALUE) - end

                    SizedBox(width: 4),

                    // column 2 (BOOKS) - start
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
                                    Strings.statsBooksVolume,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                Row(
                                  children: [
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4),

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
                                    Strings.statsBooksAvgPrice,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      ? fractionalAvg.substring(
                                                          0, 2)
                                                      : '00',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
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
              }),

//          //CHART AREA - start

          SizedBox(height: 8),

          Container(
            child: StreamBuilder<List<SubscriberSeries>>(
              stream: _isSpentBook
                  ? userBreakdownBloc.bookGraphStream
                  : userBreakdownBloc.spentGraphStream,
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
                          margin: EdgeInsets.all(24),
                          height: 202,
                          color: mySurfaceColor,
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              Strings.statsNoPieChartAvailable,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: myPrimaryColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : MyDonutPieChart(
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
            padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
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
          //SWITCHERS AREA - end

          //LEGEND AREA - start

          StreamBuilder(
              stream: _isSpentBook
                  ? userBreakdownBloc.bookGraphStream
                  : userBreakdownBloc.spentGraphStream,
              builder: (context, snapshotColor) {
                if (snapshotColor.hasData) {
                  return ListView.builder(
                    itemCount: snapshotColor.data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      final breakdownPer = !_isSpentBook
                          ? (snapshotColor.data[index].subscribersY *
                                  100 /
                                  totalGenreValue)
                              .toString()
                              .split('.')[0]
                          : (snapshotColor.data[index].subscribersY *
                                  100 /
                                  totalBooks)
                              .toString()
                              .split('.')[0];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                        child: Container(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    snapshotColor.data[index].color,
                                radius: 10,
                              ),
                              SizedBox(width: 4),
                              SizedBox(width: 8),
                              Text(snapshotColor.data[index].genreNameX
                                      .toString()
                                      .toUpperCase() +
                                  ':'),
                              SizedBox(width: 8),
                              Text(snapshotColor.data[index].subscribersY
                                  .toString()),
                              SizedBox(width: 8),
                              Text('(' '$breakdownPer' '%)'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(myPrimaryColor),
                    ),
                  );
                }
              }),
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
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: myPrimaryColor)),
                );
              }).toList(),
              hint: StreamBuilder<dynamic>(
                  initialData: '',
                  stream: userBreakdownBloc.timePeriodStream,
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
                              style: Theme.of(context).textTheme.button),
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
                selectedTimeInterval = value;
                if (value != Strings.statsCustom) {
                  userBreakdownBloc.updateSelectedTime(value);
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
                        padding: const EdgeInsets.only(left: 24.0),
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
                            size: 24,
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
                  height: 40,
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
            userBreakdownBloc.updateCustomRange(selectedTimeInterval,
                startMonth: selectedStartDate, endMonth: selectedEndDate);
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
