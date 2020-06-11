
import 'package:cinex_scan/view/home_view.dart';
import 'package:cinex_scan/view/login_view.dart';
import 'package:cinex_scan/view/ticket_view.dart';
import 'package:flutter/material.dart';
import 'package:cinex_scan/route/route_path.dart' as routes;

Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name)
  {
    case routes.login:
      return MaterialPageRoute(builder: (context) => LoginView());
    case routes.home:
      return MaterialPageRoute(builder: (context) => HomePage());
    case routes.ticket:
      var ids = routeSettings.arguments as String;
      return MaterialPageRoute(builder: (context) => TicketView(ids: ids,));
    default:
      return MaterialPageRoute(builder: (context) => LoginView());
  }

}