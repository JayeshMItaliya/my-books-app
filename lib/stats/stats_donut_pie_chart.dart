import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/stats_genre_breakdown_helper.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyDonutPieChart extends StatelessWidget {
  const MyDonutPieChart({this.data, this.showData});

  final List<SubscriberSeries> data;
  final bool showData;

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<SubscriberSeries, String>> series = [
      charts.Series(
        id: 'Subscribers',
        data: data,
        domainFn: (SubscriberSeries series, _) => series.genreNameX,
        measureFn: (SubscriberSeries series, _) => series.subscribersY,
        colorFn: (SubscriberSeries series, _) => series.pieArchColor,
        labelAccessorFn: (SubscriberSeries row, _) =>
            '${row.genreNameX}: ${row.subscribersY}',
      )
    ];
    return Container(
      height: 250,
      child: charts.PieChart(
        series,
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: showData
                ? [
                    charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.outside,
                      leaderLineColor:
                          charts.ColorUtil.fromDartColor(myOnSurfaceColor),
                    ),
                  ]
                : null),
      ),
    );
  }
}
