import 'package:barcode_scan/barcode_scan.dart';
import 'package:cinex_scan/constant/store.dart';
import 'package:flutter/material.dart';
import 'package:cinex_scan/route/route_path.dart' as routes;
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Container(margin: EdgeInsets.all(10),child: Text(message),), renderScanButton()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.exit_to_app),
        onPressed: () {
          Store store = new Store();
          store.clear();
          Navigator.of(context).pushNamed(routes.login);
        },
      ),
    ));
  }

  renderScanButton() {
    return Center(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          //Navigator.of(context).pushNamed(HomePage.tag);
          _scanQR();
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child:
            Text("SCAN", style: TextStyle(color: Colors.white, fontSize: 18.0)),
      ),
    );
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      Navigator.of(context).pushNamed(routes.ticket, arguments: qrResult);
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          message = "Camera permission was denied";
        });
      } else {
        setState(() {
          message = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        message = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        message = "Unknown Error $ex";
      });
    }
  }
}
