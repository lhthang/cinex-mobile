import 'dart:convert';

import 'package:cinex_management/Model/Rate/rate.dart';
import 'package:cinex_management/Model/report.dart';
import 'package:cinex_management/Model/system_report.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

class ReportController {
  Store store = new Store();
  SystemReport reports ;
  static ReportController _instance;

  static ReportController get instance {
    if (_instance == null) _instance = new ReportController();
    return _instance;
  }


  Future<SystemReport> getReports(String date) async {
    print(date);
    Map data = {
      'time': date,
    };
    var body = json.encode(data);
    String token = await store.get("token");
    final response = await http.post('$url/reports',body: body,headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      print(response.body);
      reports = SystemReport.fromJson(json.decode(response.body));
      return reports;
    }
    return null;
  }
}
