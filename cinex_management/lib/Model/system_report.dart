import 'package:cinex_management/Model/report.dart';

class SystemReport{
  List<Report> reports;

  SystemReport({this.reports});

  factory SystemReport.fromJson(Map<String,dynamic> json){
    var list = json['reports'] as List;
    List<Report> reports = list.map((rep) => Report.fromJson(rep)).toList();
    return SystemReport(
      reports: reports,
    );
  }
}