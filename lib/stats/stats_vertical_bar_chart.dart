import 'package:byebye_flutter_app/network_helper/stats_genre_helper.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MyVerticalBarChart extends StatelessWidget {
  const MyVerticalBarChart({this.data, this.showData});

  final List<SubscriberSeries> data;
  final bool showData;

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<SubscriberSeries, String>> series = [
      charts.Series(
        id: 'Subscribers',
        data: data,
        domainFn: (SubscriberSeries series, _) => series.monthX,
        measureFn: (SubscriberSeries series, _) => series.subscribersY,
        colorFn: (SubscriberSeries series, _) => series.barColor,
      )
    ];
    return Container(
      height: 200,
      child: charts.BarChart(
        series,
        animate: true,
//        primaryMeasureAxis: charts.NumericAxisSpec(
//          showAxisLine: !showData ? false : true,
//          renderSpec: !showData ? charts.NoneRenderSpec() : null,
//        ),
        domainAxis: charts.OrdinalAxisSpec(
          showAxisLine: !showData ? false : true,
          renderSpec: !showData
              ? charts.NoneRenderSpec()
              : charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                      fontSize:
                          9, 
                      color: charts.MaterialPalette.black),
                ),
        ),
      ),
    );
  }
}
