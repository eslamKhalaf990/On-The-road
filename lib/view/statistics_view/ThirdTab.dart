import 'package:flutter/cupertino.dart';
import 'package:on_the_road/view/statistics_view/statistics.dart';
import 'package:on_the_road/view/statistics_view/widgets/DoubleHistogram.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/design_constants.dart';

Widget buildThirdTab(List<dynamic> data) {
  // TODO: Implement the content for the third tab.
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(20),
          height: 350,
          width: 350,
          alignment: Alignment.center,
          decoration: DesignConstants.roundedBorder,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            series: <ChartSeries>[
              LineSeries<LieData, String>(
                dataSource: data[4],
                xValueMapper: (LieData d, _) => d.x,
                yValueMapper: (LieData d, _) => d.y,
              ),
            ],
          ),
        ),
        buildDoubleHistogramChart(data[5]),
      ],
    ),
  );
}
