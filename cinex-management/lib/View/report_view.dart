import 'package:charts_flutter/flutter.dart';
import 'package:cinex_management/Controller/report_controller.dart';
import 'package:cinex_management/Model/report.dart';
import 'package:cinex_management/Model/system_report.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as style;


class ReportView extends StatefulWidget {
  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {

  Future<SystemReport> systemReport;
  double totalRevenue=0;

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          _createSelectStartOnButton(),
          _createButton(),
          Expanded(
            child: Container(
              child: _renderReport(systemReport),
            ),
          )
        ],
      ),
    );
  }

  _createSelectStartOnButton() {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.only(
          left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              height: 30,
              child: Material(
                borderRadius:  BorderRadius.circular(3),
                //color: Colors.blueGrey,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                          Icons.calendar_today
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text("Month",style: contentStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Icon(
                Icons.arrow_right
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: _buildDate(selectedDate),
          )
        ],
      ),
    );
  }

  _buildDate(DateTime dateTime){
    return Material(
      child: InkWell(
        child: Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            border: Border.all(width:2,color: Colors.greenAccent[400]),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(formatMonthFromString(dateTime.toIso8601String())),
        ),
        onTap: (){
          _selectDate(context);
        },
      ),
    );
  }

  _createButton(){
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex:1,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: new RaisedButton(
              color: Colors.greenAccent,
              child: new Text(
                'Get Report',
                style: style.TextStyle(
                    color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                //_createShowtime();
                setState(() {
                  systemReport=ReportController.instance.getReports(selectedDate.toIso8601String());
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          )
        ],
      )
    );
  }

  List<Series<Report,String>> _createData(List<Report> reports){
    final showtimesData = reports;

    final priceData = reports;

    return [
      new Series<Report, String>(
        id: 'Showtimes',
        domainFn: (Report sales, _) => sales.movie,
        measureFn: (Report sales, _) => sales.showtimes,
        data: showtimesData,
        fillColorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Report sales, _)=>sales.showtimes.toString(),
      ),
      new Series<Report, String>(
        id: 'Revenue',
        domainFn: (Report sales, _) => sales.movie,
        measureFn: (Report sales, _) => sales.totalPrice,
        data: priceData,
        fillColorFn: (_, __) => MaterialPalette.green.shadeDefault.lighter,
        labelAccessorFn: (Report sales, _)=>"\$"+sales.totalPrice.toString(),
      )..setAttribute(measureAxisIdKey, 'secondaryMeasureAxisId')
    ];
  }
  Widget _renderReport(Future<SystemReport> report){
    return FutureBuilder(
      future: report,
      builder: (context,snapshot){
        if(snapshot.hasData && snapshot.connectionState==ConnectionState.done){
          return Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Total revenue: "+_getTotalRevenue(snapshot.data.reports).toString(),style: contentStyle,),
                Expanded(
                  child: BarChart(
                    _createData(snapshot.data.reports),
                    animate: true,
                    barGroupingType: BarGroupingType.grouped,
                    // It is important when using both primary and secondary axes to choose
                    // the same number of ticks for both sides to get the gridlines to line
                    // up.
                    primaryMeasureAxis: new NumericAxisSpec(
                        tickProviderSpec:
                        new BasicNumericTickProviderSpec(desiredTickCount: 10)),
                    secondaryMeasureAxis: new NumericAxisSpec(
                        tickProviderSpec:
                        new BasicNumericTickProviderSpec(desiredTickCount: 10)),
                    barRendererDecorator: BarLabelDecorator(
                        labelAnchor: BarLabelAnchor.start,
                        labelPosition: BarLabelPosition.outside
                    ),
                  ),
                ),
              ],
            )
          );
        }
        if(report==null) return Center(
          child: Center(
            child: Image.asset('assets/cinex-logo.png'),
          ),
        );
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  double _getTotalRevenue(List<Report> reports){
    double total = 0;
    for(var report in reports){
      total+=report.totalPrice;
    }
    return total;
  }
}
