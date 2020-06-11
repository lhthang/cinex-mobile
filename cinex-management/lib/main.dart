import 'package:cinex_management/route/router.dart' as router;
import 'package:cinex_management/View//login_view.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/route/route_path.dart' as routes;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // to hide both:
    return MaterialApp(
      onGenerateRoute: router.generateRoute,
      initialRoute: routes.login,
      title: "Cinex",
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
