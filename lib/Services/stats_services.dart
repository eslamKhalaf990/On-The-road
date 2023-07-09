import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../view/statistics_view/statistics.dart';

class StatServices {
  Future<List<PieData>> pie1(String token) async {
    https: //ontheroad.onrender.com/api/userStats/percentSpeedBumpDanger
    var response = await http.get(
      Uri.parse(
          'https://ontheroad.onrender.com/api/userStats/percentSpeedLimitExceeded'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var decoded = json.decode(response.body);
    double pres = decoded[0]["?column?"];
    return [
      PieData(
          "Risky", (pres * 100).toInt(), const Color.fromARGB(1, 199, 31, 45)),
      PieData(
          "Not Risky", ((1.0 - pres) * 100).toInt(), const Color(0xffFFBA00)),
    ];
  }

  Future<List<PieData>> pie2(String token) async {
    var response = await http.get(
      Uri.parse(
          'https://ontheroad.onrender.com/api/userStats/percentSpeedBumpDanger'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var decoded = json.decode(response.body);
    double pres = decoded[0]["coalesce"];
    return [
      PieData(
          "Risky", (pres * 100).toInt(), const Color.fromARGB(1, 199, 31, 45)),
      PieData(
          "Not Risky", ((1.0 - pres) * 100).toInt(), const Color(0xffFFBA00)),
    ];
  }

  Future<List<HistogramData>> histogram1(String token) async {
    var response = await http.get(
      Uri.parse(
          'https://ontheroad.onrender.com/api/userStats/speedRiskDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var decoded = json.decode(response.body);
    int len = decoded.length;
    List<HistogramData> list = [];
    Color color;
    for (int i = 0; i < len; i++) {
      if (decoded[i]["name"] == "low risk speed") {
        color = Colors.blue;
      } else if (decoded[i]["name"] == "Medium Risk") {
        color = const Color(0xffFFBA00);
      } else {
        color = Colors.red;
      }
      list.add(HistogramData(
          decoded[i]["name"], int.parse(decoded[i]["count"]), color));
    }
    return list;
  }

  Future<List<HistogramData>> histogram2(String token) async {
    var response = await http.get(
      Uri.parse(
          'https://ontheroad.onrender.com/api/userStats/speedBumpRiskDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var decoded = json.decode(response.body);
    int len = decoded.length;
    List<HistogramData> list = [];
    Color color;
    for (int i = 0; i < len; i++) {
      if (decoded[i]["name"] == "speed pumb low risk") {
        color = Colors.blue;
      } else if (decoded[i]["name"] == "speed pumb mid risk") {
        color = const Color(0xffFFBA00);
      } else {
        color = Colors.red;
      }
      list.add(HistogramData(
          decoded[i]["name"], int.parse(decoded[i]["count"]), color));
    }
    return list;
    return [
      HistogramData("Low Risk", 10, Colors.blue),
      HistogramData("Medium Risk", 20, Color(0xffFFBA00)),
      HistogramData("High Risk", 5, Colors.red),
    ];
  }

  Future<List<DoubleHistogramData>> doubleHistogram1(String token) async {
    var response = await http.get(
      Uri.parse(
          'https://ontheroad.onrender.com/api/userStats/maxAvgSpeedOverTime'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    var decoded = json.decode(response.body);
    int len = decoded.length;
    List<DoubleHistogramData> list = [];
    for (int i = 0; i < len; i++) {
      list.add(DoubleHistogramData(
          decoded[i]["day"].substring(0, 10),
          decoded[i]["avgSpeed"].toDouble(),
          decoded[i]["maxSpeed"].toDouble()));
    }
    return list;
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
    List<LieData> list = [];
    for (int i = 0; i < len; i++) {
      list.add(LieData(decoded[i]["date"], double.parse(decoded[i]["sum"])));
    }
    return list;
  }
}
