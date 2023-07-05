import 'package:flutter/material.dart';
import '../../Services/stats_services.dart';
import 'FirstTab.dart';
import 'FourthTab.dart';
import 'SecondTab.dart';
import 'ThirdTab.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List<dynamic> data = [];
  late List<PieData> pie_1_data;
  late StatServices statServices;

  @override
  void initState() {
    statServices = StatServices();
    data.add(statServices.pie1());
    data.add(statServices.histogram1());
    data.add(statServices.pie2());
    data.add(statServices.histogram2());
    data.add(statServices.lineChart1());
    data.add(statServices.doubleHistogram1());
    tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  late TooltipBehavior tooltip;
  final int i = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.today), text: "Today's data"),
              Tab(icon: Icon(Icons.pie_chart), text: "Frequency"),
              Tab(icon: Icon(Icons.timeline), text: "Time-based"),
              Tab(icon: Icon(Icons.map_outlined), text: "Location-based"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildFirstTab(context),
            buildSecondTab(tooltip, data),
            buildThirdTab(data),
            buildFourthTab(),
          ],
        ),
      ),
    );
  }
}

class PieData {
  late String x;
  late int y;
  late Color color;

  PieData(this.x, this.y, this.color);
}

class HistogramData {
  late Color color;
  late String range;
  late int value;

  HistogramData(
      this.range, this.value, this.color); // Include color in the constructor
}

class DoubleHistogramData {
  final String range;
  final double startValue;
  final double endValue;
  DoubleHistogramData(this.range, this.startValue, this.endValue);
}

class LieData {
  final String x;
  final double y;
  LieData(this.x, this.y);
}

class MapBubbleData {
  final double latitude;
  final double longitude;
  final double value;

  MapBubbleData(this.latitude, this.longitude, this.value);
}
