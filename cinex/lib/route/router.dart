
import 'package:cinex/model/checkout_data.dart';
import 'package:cinex/model/movie.dart';
import 'package:cinex/model/showtime.dart';
import 'package:cinex/model/summary_ticket.dart';
import 'package:cinex/model/ticket/ticket.dart';
import 'package:cinex/model/ticket/ticket_resp.dart';
import 'package:cinex/view/book_seats_view.dart';
import 'package:cinex/view/checkout_view.dart';
import 'package:cinex/view/history_view.dart';
import 'package:cinex/view/home_view.dart';
import 'package:cinex/view/login_view.dart';
import 'package:cinex/view/movie_detail_view.dart';
import 'package:cinex/view/sign_up_view.dart';
import 'package:cinex/view/ticket_detail_view.dart';
import 'package:cinex/view/ticket_view.dart';
import 'package:flutter/material.dart';
import 'package:cinex/route/route_path.dart' as routes;

Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name)
  {
    case routes.login:
      return MaterialPageRoute(builder: (context) => LoginView());
    case routes.home:
      return MaterialPageRoute(builder: (context) => HomePage());
    case routes.movie_detail:
      var movie =routeSettings.arguments as Movie;
      return MaterialPageRoute(builder: (context) => MovieDetailView(movie: movie,));
    case routes.sign_up:
      return MaterialPageRoute(builder: (context) => SignUpView());
    case routes.history:
      return MaterialPageRoute(builder: (context) => HistoryView());
    case routes.ticket_detail:
      var ticket =routeSettings.arguments as Ticket;
      return MaterialPageRoute(builder: (context) => TicketDetailView(ticket: ticket,));
    case routes.book_seats:
      var showtime =routeSettings.arguments as String;
      return MaterialPageRoute(builder: (context) => BookSeatView(showtimeId: showtime,));
    case routes.tickets:
      var summary =routeSettings.arguments as SummaryTickets;
      return MaterialPageRoute(builder: (context) => TicketView(tickets: summary.tickets,showtime: summary.showtime,));
    case routes.checkout:
      var data =routeSettings.arguments as CheckoutData;
      return MaterialPageRoute(builder: (context) => CheckOutView(ticketResponse: data.ticketResponse,showtime: data.showtime));
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }

}