import 'package:cinex/route/router.dart' as router;
import 'package:cinex/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:cinex/route/route_path.dart' as routes;
import 'package:flutter/services.dart';

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
      home: SafeArea(
        child: LoginView(),
      ),
    );
  }
}
