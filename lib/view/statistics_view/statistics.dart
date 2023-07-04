import 'package:flutter/material.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import '../../constants/design_constants.dart';
import 'widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late List<PieData> data;
  List<PieData> getData() {
    return [
      PieData("High Risk", 15, const Color.fromARGB(1, 199, 31, 45)),
      PieData("Low Risk", 45, const Color(0xffFFBA00)),
      PieData("Medium Risk", 40, const Color(0xff0A0390)),
    ];
  }

  @override
  void initState() {
    data = getData();
    tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  late TooltipBehavior tooltip;
  final int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          MaterialButton(
            onPressed: () {
              Provider.of<NavigationOnRoad>(context, listen: false)
                  .analyzeAvg();
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
                              Provider.of<NavigationOnRoad>(context).chartData,
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
                        value: Provider.of<NavigationOnRoad>(context)
                            .navigation
                            .maxSpeed,
                      ),
                    ),
                    Expanded(
                      child: AnalysisCard(
                        title: "Avg Speed",
                        value: Provider.of<NavigationOnRoad>(context)
                            .navigation
                            .avgSpeed,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: AnalysisCard(
                        title: "Current Speed",
                        value: Provider.of<NavigationOnRoad>(context)
                            .navigation
                            .currentSpeed,
                      ),
                    ),
                    Expanded(
                      child: AnalysisCard(
                        title: "Distance",
                        value: Provider.of<NavigationOnRoad>(context)
                            .navigation
                            .distanceTraveled,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(20),
                  height: 350,
                  width: 350,
                  alignment: Alignment.center,
                  decoration: DesignConstants.roundedBorder,
                  child: SfCircularChart(
                    tooltipBehavior: tooltip,
                    series: <CircularSeries>[
                      PieSeries<PieData, String>(
                        dataSource: data,
                        xValueMapper: (PieData d, _) => d.x,
                        yValueMapper: (PieData d, _) => d.y,
                        pointColorMapper: (PieData color, _) => color.color,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        enableTooltip: true,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
