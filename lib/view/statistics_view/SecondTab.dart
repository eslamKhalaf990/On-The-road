import 'package:flutter/cupertino.dart';
import 'package:on_the_road/view/statistics_view/statistics.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/design_constants.dart';

Widget buildSecondTab(TooltipBehavior tooltip, List<dynamic> data) {
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
          child: SfCircularChart(
            tooltipBehavior: tooltip,
            series: <CircularSeries>[
              DoughnutSeries<PieData, String>(
                dataSource: data[0],
                xValueMapper: (PieData d, _) => d.x,
                yValueMapper: (PieData d, _) => d.y,
                pointColorMapper: (PieData color, _) => color.color,
                dataLabelMapper: (PieData data, _) => data.x,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
                enableTooltip: true,
              ),
            ],
          ),
        ),
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
              ColumnSeries<HistogramData, String>(
                dataSource: data[1],
                xValueMapper: (HistogramData d, _) => d.range,
                yValueMapper: (HistogramData d, _) => d.value,
                pointColorMapper: (HistogramData d, _) => d.color,
              ),
            ],
          ),
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
                dataSource: data[2],
                xValueMapper: (PieData d, _) => d.x,
                yValueMapper: (PieData d, _) => d.y,
                pointColorMapper: (PieData color, _) => color.color,
                dataLabelMapper: (PieData data, _) => data.x,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                enableTooltip: true,
              ),
            ],
          ),
        ),
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
              ColumnSeries<HistogramData, String>(
                dataSource: data[3],
                xValueMapper: (HistogramData d, _) => d.range,
                yValueMapper: (HistogramData d, _) => d.value,
                pointColorMapper: (HistogramData d, _) => d.color,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
