import 'package:flutter/material.dart';
import 'package:on_the_road/view_model/navigation_on_road_v_m.dart';
import '../../constants/design_constants.dart';
import 'widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Widget buildFirstTab(BuildContext context) {
  return ListView(
    children: [
      MaterialButton(
        onPressed: () {
          Provider.of<NavigationOnRoad>(context, listen: false).analyzeAvg();
        },
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              height: 150,
              padding: const EdgeInsets.all(10),
              decoration: DesignConstants.roundedBorder,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  LineSeries<ChartData, String>(
                    dataSource:
                        Provider.of<NavigationOnRoad>(context).chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
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
            SizedBox(
              height: 10,
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
          ],
        ),
      ),
    ],
  );
}
