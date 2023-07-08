import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../view/statistics_view/statistics.dart';

class StatServices {
  List<PieData> pie1() {
    return [
      PieData("Risky", 15, const Color.fromARGB(1, 199, 31, 45)),
      PieData("Not Risky", 85, const Color(0xffFFBA00)),
    ];
  }

  List<PieData> pie2() {
    return [
      PieData("Risky", 15, const Color.fromARGB(1, 199, 31, 45)),
      PieData("Not Risky", 85, const Color(0xffFFBA00)),
    ];
  }

  List<HistogramData> histogram1() {
    return [
      HistogramData("Low Risk", 10, Colors.blue),
      HistogramData("Medium Risk", 20, Color(0xffFFBA00)),
      HistogramData("High Risk", 5, Colors.red),
    ];
  }

  List<HistogramData> histogram2() {
    return [
      HistogramData("Low Risk", 10, Colors.blue),
      HistogramData("Medium Risk", 20, Color(0xffFFBA00)),
      HistogramData("High Risk", 5, Colors.red),
    ];
  }

  List<DoubleHistogramData> doubleHistogram1() {
    return [
      DoubleHistogramData("Range 1", 10, 5),
      DoubleHistogramData("Range 2", 20, 6),
      DoubleHistogramData("Range 3", 15, 1),
      DoubleHistogramData("Range 4", 30, 9),
      DoubleHistogramData("Range 5", 25, 13),
      DoubleHistogramData("Range 6", 10, 5),
      DoubleHistogramData("Range 7", 20, 6),
      DoubleHistogramData("Range 8", 15, 1),
      DoubleHistogramData("Range 9", 30, 9),
      DoubleHistogramData("Range 10", 25, 13),
      DoubleHistogramData("Range 11", 10, 5),
      DoubleHistogramData("Range 12", 20, 6),
      DoubleHistogramData("Range 13", 15, 1),
      DoubleHistogramData("Range 14", 30, 9),
      DoubleHistogramData("Range 15", 25, 13),
      DoubleHistogramData("Range 16", 10, 5),
      DoubleHistogramData("Range 17", 20, 6),
      DoubleHistogramData("Range 18", 15, 1),
      DoubleHistogramData("Range 19", 30, 9),
      DoubleHistogramData("Range 20", 25, 13),
    ];
  }

  Future<List<LieData>> lineChart1(String token) async {
    var response = await http.get(
      Uri.parse(
          'https://ontheroad.onrender.com/api/userStats/riskPointsOverTime'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var decoded = json.decode(response.body);
    int len = decoded.length;
    print("&&&&&&&&&&&&&&&&&&&&&&&&" + len.toString());
    List<LieData> list = [];
    for (int i = 0; i < len; i++) {
      list.add(LieData(decoded[i]["date"], double.parse(decoded[i]["sum"])));
    }
    return list;
  }

  // List<LieData> lineChart1() {
  //   return [
  //     LieData("5-1", 10),
  //     LieData("5-2", 20),
  //     LieData("5-3", 15),
  //     LieData("5-4", 25),
  //     LieData("5-5", 30),
  //     LieData("5-6", 20),
  //     LieData("5-7", 28),
  //     LieData("5-8", 8),
  //     LieData("5-9", 10),
  //     LieData("5-10", 8),
  //     LieData("5-11", 18),
  //     LieData("5-12", 8),
  //     LieData("5-13", 15),
  //     LieData("5-14", 18),
  //     LieData("5-15", 10),
  //   ];
  // }
}
