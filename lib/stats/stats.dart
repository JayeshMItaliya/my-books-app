import 'package:byebye_flutter_app/bloc/user_stats_bloc.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/stats/stats_breakdown.dart';
import 'package:byebye_flutter_app/stats/stats_monthly.dart';
import 'package:byebye_flutter_app/stats/stats_spending.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import '../my_constants/design_system.dart';

class MyState extends StatefulWidget {
  const MyState({Key key}) : super(key: key);

  @override
  _MyStateState createState() => _MyStateState();
}

class _MyStateState extends State<MyState> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    userStatsBloc = UserStatsBloc();
    tabController = TabController(length: 3, vsync: this);
    getInitStatsData();
    userStatsBloc.updateSelectedTime(Strings.statsCurrentYear);
  }

  dynamic getInitStatsData() async {
    await userStatsBloc.getSpecificGenre(prefsObject.getString('uid'),
        value: Strings.statsCurrentYear);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myStatsAppBar(context),
      body: Container(
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
                        onTap: (index) {
                          setState(() {});
                        },
                        controller: tabController,
                        indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 4,
                              color: myPrimaryColor,
                            ),
                            insets: EdgeInsets.only(
                                left: 0, top: 0, right: 0, bottom: 0)),
                        isScrollable: true,
                        labelPadding: EdgeInsets.only(
                            left: 16, top: 10, right: 12, bottom: 4),
                        tabs: [
                          Tab(
                            child: Text(Strings.statsItemTabSpending,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                          Tab(
                            child: Text(Strings.statsItemTabBreakdown,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                          Tab(
                            child: Text(Strings.statsItemTabMonthly,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: tabController.index == 0
                      ? MyStatsSpending()
                      : tabController.index == 1
                          ? MyStatsBreakDown()
                          : MyStatsMonthly(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myStatsAppBar(context) {
    const String _myStatsAppBarText = Strings.statsAppbarTitle;
    return AppBar(
      elevation: 0,
      centerTitle: false,
      // leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
      //     onPressed: () {
      //       Navigator.push<dynamic>(
      //         context,
      //         MaterialPageRoute<dynamic>(
      //           builder: (context) => BottomNavigationBarController(
      //             userUid: prefsObject.getString('uid'),
      //             routeType: NavigateFrom.stats,
      //           ),
      //         ),
      //       );
      //     }),
      titleSpacing: 20.0,
      title: Text(
        '$_myStatsAppBarText',
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
    );
  }
}
