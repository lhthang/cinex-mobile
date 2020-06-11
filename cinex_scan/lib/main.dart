import 'package:cinex_scan/route/router.dart' as router;
import 'package:cinex_scan/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:cinex_scan/route/route_path.dart' as routes;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: router.generateRoute,
      initialRoute: routes.login,
      title: "Cinex",
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: LoginView(),
      ),
    );
  }
}

