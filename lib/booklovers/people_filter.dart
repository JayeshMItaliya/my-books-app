import 'package:byebye_flutter_app/bloc/book_lovers_bloc.dart';
import 'package:byebye_flutter_app/bloc/people_filter_bloc.dart';
import 'package:flutter/material.dart';
import '../bloc/people_filter_bloc.dart';
import '../constants/strings.dart';
import '../my_constants/design_system.dart';

class PeopleFiltering extends StatefulWidget {
  @override
  _PeopleFilteringState createState() => _PeopleFilteringState();
}

class _PeopleFilteringState extends State<PeopleFiltering> {
  final _key = GlobalKey<ScaffoldState>();

  String selectedGender;
  String selectedAge;
  String selectedInventory;
  String selectedActivity;
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyFirstTheme().theme;

    return Scaffold(
      key: _key,
      appBar: myPeopleListFilteringAppBar(context),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  buildFilterByGenderTile(),
                  buildFilterByAgeTile(),
                  buildFilterByInventoryTile(),
                  buildFilterByActivityTile(),
                ],
              ),
              applyFilterButton(context),
              restoreToDefaultButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget myPeopleListFilteringAppBar(context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      titleSpacing: 0.0,
      title: Text(
        Strings.peopleFilteringAppBar,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.info, size: 20, color: myOnPrimaryColor),
            onPressed: () {
              showLockInfo(context);
            }),
      ],
    );
  }

  Widget buildFilterByGenderTile() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: <String>[
              Strings.peopleFilterByAllGender,
              Strings.peopleFilterByMale,
              Strings.peopleFilterByFemale,
              Strings.peopleFilterByOther,
            ].map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value.toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                    textAlign: TextAlign.left),
              );
            }).toList(),
            hint: StreamBuilder<String>(
                initialData: prefsObject.getString('filterGenderVal') ?? '',
                stream: peopleFilterBloc.genderDropvalueStream,
                builder: (context, snapshot) {
                  selectedGender = snapshot.data != null ? snapshot.data : '';
                  return SizedBox(
                    width: 300.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          selectedGender == ''
                              ? Strings.peopleFilterByGender.toUpperCase()
                              : selectedGender.toString().toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: selectedGender != ''
                              ? Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myAccentColor)
                              : Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myPrimaryColor),
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
              prefsObject.setString('filterGenderVal', value);
              peopleFilterBloc.updateSelectedGender(value);
            },
          ),
        ),
      ),
    );
  }

  Widget buildFilterByAgeTile() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: <String>[
              Strings.peopleFilterByAllAge,
              Strings.peopleFilterByUnderTwenty,
              Strings.peopleFilterByTwentyToThirty,
              Strings.peopleFilterByThirtyToFourty,
              Strings.peopleFilterByFourtyPlus,
            ].map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value.toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                    textAlign: TextAlign.left),
              );
            }).toList(),
            hint: StreamBuilder<String>(
                initialData: prefsObject.getString('filterAgeVal') ?? '',
                stream: peopleFilterBloc.ageDropvalueStream,
                builder: (context, snapshot) {
                  selectedAge = snapshot.data != null ? snapshot.data : '';
                  return SizedBox(
                    width: 300.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          selectedAge == ''
                              ? Strings.peopleFilterByAge.toUpperCase()
                              : selectedAge.toString().toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: selectedAge != ''
                              ? Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myAccentColor)
                              : Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myPrimaryColor),
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
              prefsObject.setString('filterAgeVal', value);
              peopleFilterBloc.updateSelectedAge(value);
            },
          ),
        ),
      ),
    );
  }

  Widget buildFilterByInventoryTile() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: <String>[
              Strings.peopleFilterByAllInventory,
              Strings.peopleFilterByMoreThanTwentyFive,
              Strings.peopleFilterByMoreThanFifty,
              Strings.peopleFilterByMoreThanHundred,
              Strings.peopleFilterByMoreThanTwoHundred,
            ].map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value.toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                    textAlign: TextAlign.left),
              );
            }).toList(),
            hint: StreamBuilder<String>(
                initialData: prefsObject.getString('filterInventoryVal') ?? '',
                stream: peopleFilterBloc.inventoryDropvalueStream,
                builder: (context, snapshot) {
                  selectedInventory =
                      snapshot.data != null ? snapshot.data : '';
                  return SizedBox(
                    width: 300.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          selectedInventory == ''
                              ? Strings.peopleFilterByInventory.toUpperCase()
                              : selectedInventory.toString().toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: selectedInventory != ''
                              ? Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myAccentColor)
                              : Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myPrimaryColor),
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
              prefsObject.setString('filterInventoryVal', value);
              peopleFilterBloc.updateSelectedInventory(value);
            },
          ),
        ),
      ),
    );
  }

  Widget buildFilterByActivityTile() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: <String>[
              Strings.peopleFilterByAllActivity,
              Strings.peopleFilterByActiveNow,
              Strings.peopleFilterByCurrentDay,
            ].map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value.toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                    textAlign: TextAlign.left),
              );
            }).toList(),
            hint: StreamBuilder<String>(
                initialData: prefsObject.getString('filterActivityVal') ?? '',
                stream: peopleFilterBloc.activityDropvalueStream,
                builder: (context, snapshot) {
                  selectedActivity = snapshot.data != null ? snapshot.data : '';
                  return SizedBox(
                    width: 300.0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          selectedActivity == ''
                              ? Strings.peopleFilterByActivity.toUpperCase()
                              : selectedActivity.toString().toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: selectedActivity != ''
                              ? Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myAccentColor)
                              : Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: myPrimaryColor),
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
              prefsObject.setString('filterActivityVal', value);
              peopleFilterBloc.updateSelectedActivity(value);
            },
          ),
        ),
      ),
    );
  }

  Widget applyFilterButton(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: MaterialButton(
        child: Text(
          Strings.peopleApplyFilter,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: myOnPrimaryColor),
        ),
        color: myPrimaryColor,
        height: 60,
        minWidth: 350,
        onPressed: () {
          _filterPeopleList(context);
          // showCountPeopleBloc.showCountPeoples(true);
        },
      ),
    );
  }

  Future<void> _filterPeopleList(BuildContext context) async {
    prefsObject.setBool('activeFilter', true);
    if (!isLoading) {
      Loader().showLoader(context);
    }
    await peopleFilterBloc.getSpecificPeople(
      genderValue: prefsObject.getString('filterGenderVal'),
      ageValue: prefsObject.getString('filterAgeVal'),
      inventoryVal: prefsObject.getString('filterInventoryVal'),
      activityVal: prefsObject.getString('filterActivityVal'),
    );
    setState(() {
      isLoading = true;
      Loader().hideLoader(context);
    });
    Navigator.pop(context);
  }

  Widget restoreToDefaultButton(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: MaterialButton(
          elevation: 0,
          color: mySurfaceColor,
          child: Text(
            Strings.peopleFilterRestoreToDefault,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: myPrimaryColor),
          ),
          height: 60,
          minWidth: 350,
          onPressed: () => {
                _restorePeopleList(context),
                // showCountPeopleBloc.showCountPeoples(false)
              }),
    );
  }

  Future<void> _restorePeopleList(BuildContext context) async {
    prefsObject.setBool('activeFilter', false);
    if (!isLoading) {
      Loader().showLoader(context);
    }
    prefsObject.setString('filterGenderVal', null);
    prefsObject.setString('filterAgeVal', null);
    prefsObject.setString('filterInventoryVal', null);
    prefsObject.setString('filterActivityVal', null);
    await peopleFilterBloc.updateSelectedGender(null);
    await peopleFilterBloc.updateSelectedAge(null);
    await peopleFilterBloc.updateSelectedInventory(null);
    await peopleFilterBloc.updateSelectedActivity(null);

    await bookLoversBloc.bookLoversList(0);
    peopleFilterBloc.updateSelectedFilterData(null);
    setState(() {
      isLoading = true;
      Loader().hideLoader(context);
    });
    Navigator.pop(context);
  }
}

dynamic showLockInfo(BuildContext context) {
  final Widget okButton = FlatButton(
    child: Text(
      Strings.lockInfoButton,
      style: Theme.of(context)
          .textTheme
          .button
          .copyWith(color: myAccentColor, fontWeight: FontWeight.w800),
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
