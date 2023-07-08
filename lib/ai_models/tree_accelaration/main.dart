// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:statistics/statistics.dart';

import 'gyroscope.dart';

void main() {
  runApp(const MyApp1());
}
class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    gyroscope gyro = gyroscope();
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmptyPage(),
    );
  }
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empty Page'),
      ),
      body: Container(), // Empty container
    );
  }
}

//////////////////////////////////////////
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? timer;
  List<List<double>>? _accelerometerValues = [];
  List<List<double>>? _gyroscopeValues = [];

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  Widget build(BuildContext context) {
    final accelerometer = _accelerometerValues
        ?.map((List v) => "${v[0]}-${v[1]}-${v[2]}")
        .toList();
    final gyroscope =
        _gyroscopeValues?.map((List v) => "${v[0]}-${v[1]}-${v[2]}").toList();
    // final userAccelerometer = _userAccelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Accelerometer: $accelerometer'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Gyroscope: $gyroscope'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues?.add([event.x, event.y, event.z]);
          });
        },
      ),
    );

    timer = Timer.periodic(
        Duration(milliseconds: 500), (Timer t) => CalculateStats());

    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues?.add([event.x, event.y, event.z]);
          });
        },
      ),
    );
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
