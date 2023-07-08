import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/design_constants.dart';
import '../statistics.dart';

Widget buildDoubleHistogramChart(List<DoubleHistogramData> data) {
  return Container(
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
        ColumnSeries<DoubleHistogramData, String>(
          dataSource: data,
          xValueMapper: (DoubleHistogramData d, _) => d.range,
          yValueMapper: (DoubleHistogramData d, _) => d.startValue,
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        ),
        ColumnSeries<DoubleHistogramData, String>(
          dataSource: data,
          xValueMapper: (DoubleHistogramData d, _) => d.range,
          yValueMapper: (DoubleHistogramData d, _) => d.endValue,
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        ),
      ],
    ),
  );
}
