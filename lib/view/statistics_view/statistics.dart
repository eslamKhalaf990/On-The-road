import 'package:flutter/material.dart';
import 'package:on_the_road/Services/position_stream.dart';
import 'package:provider/provider.dart';
// import 'package:on_the_road/view/home_view/home.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/Navigation.dart';

// List<ChartData> chartData = <ChartData>[];

class Statistics extends StatefulWidget {
  
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  // Navigation navigation = Navigation();
  int i=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // chartData.add(ChartData(i.toString(), Provider.of<PositionStream>(context).navigation.avgSpeed),);
    // streamController.stream.listen((event) {
    //   i++;
    //   setState(() {
    //       navigation = event;

    //   });
    // });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<PositionStream>(context).chartData = <ChartData>[];
    Provider.of<PositionStream>(context).i=0;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          MaterialButton(
            // height: 200,
            onPressed: (){
              Provider.of<PositionStream>(context, listen: false).analyzeAvg();
            },
            child: Container(
              height: 200,
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    LineSeries<ChartData, String>(
                        dataSource: Provider.of<PositionStream>(context).chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y
                    )
                  ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
