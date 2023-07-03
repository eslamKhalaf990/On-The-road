import 'dart:async';
import 'dart:math';
import 'package:on_the_road/tree_accelaration/tree/tree.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:statistics/statistics.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class gyroscope {
  Timer? timer;
  List<List<double>>? _accelerometerValues = [];
  List<List<double>>? _gyroscopeValues = [];
  var params0;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  gyroscope() {
    start();
  }

  Future<void> start() async {
    params0 = await readJsonFile('assets/models/DT_os_22_6.json'); //make sure to wait
    DecisionTreeClassifier classifier = DecisionTreeClassifier.fromMap(params0);

    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _accelerometerValues?.add([event.x, event.y, event.z]);
        },
      ),
    );

    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          _gyroscopeValues?.add([event.x, event.y, event.z]);
        },
      ),
    );

    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      print(t.tick);
      var record = CalculateStats();
      var classification;
      classification = classifier.predict(record);
      if (classification == 1)
        print("Sudden Acceleration");
      else if (classification == 2)
        print("Sudden Right Turn");
      else if (classification == 3)
        print(" Sudden Left Turn ");
      else if (classification == 4) print("Sudden Break");
    });
  }

  void end() {
    timer?.cancel();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  List<double> CalculateStats() {
    List<List<double>>? accValues = _accelerometerValues;
    _accelerometerValues = [];
    List<double> accX = [];
    List<double> accY = [];
    List<double> accZ = [];

    accValues?.forEach((element) {
      accX.add(element[0]);
      accY.add(element[1]);
      accZ.add(element[2]);
    });

    List<List<double>>? gyroValues = _gyroscopeValues;
    _accelerometerValues = [];
    List<double> gyroX = [];
    List<double> gyroY = [];
    List<double> gyroZ = [];

    gyroValues?.forEach((element) {
      gyroX.add(element[0]);
      gyroY.add(element[1]);
      gyroZ.add(element[2]);
    });

    double AccMeanX = accX.mean;
    double AccMeanY = accY.mean;
    double AccMeanZ = accZ.mean;

    double AccStdX = accX.standardDeviation; //down
    double AccStdY = accY.standardDeviation;
    double AccStdZ = accZ.standardDeviation;

    double AccCovX = 0.02;
    double AccCovY = 0.05;
    double AccCovZ = 0.07;

    double AccSkewX = skew(accX, AccMeanX, AccStdX);
    double AccSkewY = skew(accY, AccMeanY, AccStdY);
    double AccSkewZ = skew(accZ, AccMeanZ, AccStdZ);

    double AccKurtX = Kurtosis(accX, AccMeanX, AccStdX);
    double AccKurtY = Kurtosis(accY, AccMeanY, AccStdY);
    double AccKurtZ = Kurtosis(accZ, AccMeanZ, AccStdZ);

    double AccSumX = accX.sum;
    double AccSumY = accY.sum;
    double AccSumZ = accZ.sum;

    double AccMinX = accX.statistics.min;
    double AccMinY = accY.statistics.min;
    double AccMinZ = accZ.statistics.min;

    double AccMaxX = accX.statistics.max;
    double AccMaxY = accY.statistics.max;
    double AccMaxZ = accZ.statistics.max;

    double AccVarX = pow(AccStdX, 2).toDouble();
    double AccVarY = pow(AccStdY, 2).toDouble();
    double AccVarZ = pow(AccStdZ, 2).toDouble();

    double AccMedianX = accX.statistics.median.toDouble();
    double AccMedianY = accY.statistics.median.toDouble();
    double AccMedianZ = accZ.statistics.median.toDouble();

    //std
    //gyro data
    double GyroMeanX = accX.mean;
    double GyroMeanY = accY.mean;
    double GyroMeanZ = accZ.mean;

    double GyroStdX = accX.standardDeviation; //down
    double GyroStdY = accY.standardDeviation;
    double GyroStdZ = accZ.standardDeviation;

    double GyroCovX = 5.0;
    double GyroCovY = 1.0;
    double GyroCovZ = 1.0;

    double GyroSkewX = skew(accX, GyroMeanX, GyroStdX);
    double GyroSkewY = skew(accY, GyroMeanY, GyroStdY);
    double GyroSkewZ = skew(accZ, GyroMeanZ, GyroStdZ);

    double GyroKurtX = Kurtosis(accX, GyroMeanX, GyroStdX);
    double GyroKurtY = Kurtosis(accY, GyroMeanY, GyroStdY);
    double GyroKurtZ = Kurtosis(accZ, GyroMeanZ, GyroStdZ);

    double GyroSumX = accX.sum;
    double GyroSumY = accY.sum;
    double GyroSumZ = accZ.sum;

    double GyroMinX = accX.statistics.min;
    double GyroMinY = accY.statistics.min;
    double GyroMinZ = accZ.statistics.min;

    double GyroMaxX = accX.statistics.max;
    double GyroMaxY = accY.statistics.max;
    double GyroMaxZ = accZ.statistics.max;

    double GyroVarX = pow(GyroStdX, 2).toDouble();
    double GyroVarY = pow(GyroStdY, 2).toDouble();
    double GyroVarZ = pow(GyroStdZ, 2).toDouble();

    double GyroMedianX = accX.statistics.median.toDouble();
    double GyroMedianY = accY.statistics.median.toDouble();
    double GyroMedianZ = accZ.statistics.median.toDouble();

    List<double> data = [
      AccMeanX,
      AccMeanY,
      AccMeanZ,
      AccCovX,
      AccCovY,
      AccCovZ,
      AccSkewX,
      AccSkewY,
      AccSkewZ,
      AccKurtX,
      AccKurtY,
      AccKurtZ,
      AccSumX,
      AccSumY,
      AccSumZ,
      AccMinX,
      AccMinY,
      AccMinZ,
      AccMaxX,
      AccMaxY,
      AccMaxZ,
      AccVarX,
      AccVarY,
      AccVarZ,
      AccMedianX,
      AccMedianY,
      AccMedianZ,
      AccStdX,
      AccStdY,
      AccStdZ,
      //gyro
      GyroMeanX,
      GyroMeanY,
      GyroMeanZ,
      GyroCovX,
      GyroCovY,
      GyroCovZ,
      GyroSkewX,
      GyroSkewY,
      GyroSkewZ,
      GyroSumX,
      GyroSumY,
      GyroSumZ,
      GyroKurtX,
      GyroKurtY,
      GyroKurtZ,
      GyroMinX,
      GyroMinY,
      GyroMinZ,
      GyroMaxX,
      GyroMaxY,
      GyroMaxZ,
      GyroVarX,
      GyroVarY,
      GyroVarZ,
      GyroMedianX,
      GyroMedianY,
      GyroMedianZ,
      GyroStdX,
      GyroStdY,
      GyroStdZ
    ];
    return data;
  }

  double skew(List<double> list, double mean, double std) {
    int n = list.length;
    double ans = 0.0;

    for (int i = 0; i < n; i++) {
      ans += pow((list.elementAt(i) - mean), 3);
    }
    ans /= ((n - 1) * pow(std, 3));
    return ans;
  }

  double Kurtosis(List<double> list, double mean, double std) {
    int n = list.length;
    double ans = 0.0;

    for (int i = 0; i < n; i++) {
      ans += pow((list.elementAt(i) - mean), 4);
    }
    ans /= ((n - 1) * pow(std, 4));
    return ans;
  }
}

Future<Map<String, dynamic>> readJsonFile(String path) async {
  String jsonString = await rootBundle.loadString(path);
  return json.decode(jsonString);
}
