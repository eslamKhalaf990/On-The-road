import 'package:flutter/material.dart';
import 'package:on_the_road/view/home_view/home.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/Navigation.dart';

List<ChartData> chartData = <ChartData>[];

class Statistics extends StatefulWidget {
  
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Navigation navigation = Navigation();
  int i=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamController.stream.listen((event) {
      i++;
      setState(() {
          navigation = event;
          chartData.add(ChartData(i.toString(), navigation.avgSpeed),);
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chartData = <ChartData>[];
    i=0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                LineSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y
                )
              ],
          ),
        ],
      ),
    );
  }
}
class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
