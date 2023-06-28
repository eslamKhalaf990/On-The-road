import 'package:flutter/material.dart';
import 'package:on_the_road/Services/position_stream.dart';
import '../../constants/design_constants.dart';
import 'widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  final int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          MaterialButton(
            onPressed: () {
              Provider.of<PositionStream>(context, listen: false).analyzeAvg();
            },
            child: Column(
              children: [
                Container(
                  height: 150,
                  // margin: EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  decoration: DesignConstants.roundedBorder,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      LineSeries<ChartData, String>(
                          dataSource:
                              Provider.of<PositionStream>(context).chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y)
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AnalysisCard(
                        title: "Max Speed",
                        value: Provider.of<PositionStream>(context).navigation.maxSpeed,
                      ),
                    ),
                    Expanded(
                      child: AnalysisCard(
                        title: "Avg Speed",
                        value: Provider.of<PositionStream>(context).navigation.avgSpeed,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: AnalysisCard(
                        title: "Current Speed",
                        value: Provider.of<PositionStream>(context).navigation.currentSpeed,
                      ),
                    ),
                    Expanded(
                      child: AnalysisCard(
                        title: "Distance",
                        value: Provider.of<PositionStream>(context).navigation.distanceTraveled,
                      ),
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
}
