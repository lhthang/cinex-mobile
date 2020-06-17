
import 'package:cinex_management/Model/Movie/movie.dart';
import 'package:cinex_management/Model/Rate/rate.dart';
import 'package:cinex_management/Model/Room/room.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/Model/Genre/genre.dart';
import 'package:cinex_management/Model/Showtime/showtime.dart';
import 'package:cinex_management/Model/User/user.dart';
import 'package:cinex_management/View/Genre/add_genre_view.dart';
import 'package:cinex_management/View/Genre/edit_genre_view.dart';
import 'package:cinex_management/View/Movie/add_movie_view.dart';
import 'package:cinex_management/View/Movie/edit_movie_view.dart';
import 'package:cinex_management/View/Rate/add_rate_view.dart';
import 'package:cinex_management/View/Rate/edit_rate_view.dart';
import 'package:cinex_management/View/Room/add_room_view.dart';
import 'package:cinex_management/View/Room/edit_room_view.dart';
import 'package:cinex_management/View/ScreenType/add_screentype_view.dart';
import 'package:cinex_management/View/ScreenType/edit_screentype_view.dart';
import 'package:cinex_management/View/Showtime/add_showtime_view.dart';
import 'package:cinex_management/View/Showtime/edit_showtime_view.dart';
import 'package:cinex_management/View/Ticket/detail_ticket_view.dart';
import 'package:cinex_management/View/User/add_user_view.dart';
import 'package:cinex_management/View/User/edit_user_view.dart';
import 'package:cinex_management/View/home_view.dart';
import 'package:cinex_management/View/login_view.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/route/route_path.dart' as routes;

Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name)
  {
    case routes.login:
      return MaterialPageRoute(builder: (context) => LoginView());
    case routes.home:
      return MaterialPageRoute(builder: (context) => HomePage());
    case routes.add_screentype:
      return MaterialPageRoute(builder: (context) => AddScreenTypeView());
    case routes.edit_screentype:
      var screenType = routeSettings.arguments as ScreenType;
      return MaterialPageRoute(builder: (context) => EditScreenTypeView(screenType: screenType,));
    case routes.add_genre:
      return MaterialPageRoute(builder: (context) => AddGenreView());
    case routes.edit_genre:
      var genre = routeSettings.arguments as Genre;
      return MaterialPageRoute(builder: (context) => EditGenreView(genre: genre,));
    case routes.add_rate:
      return MaterialPageRoute(builder: (context) => AddRateView());
    case routes.edit_rate:
      var rate = routeSettings.arguments as Rate;
      return MaterialPageRoute(builder: (context) => EditRateView(rate: rate,));
    case routes.add_room:
      return MaterialPageRoute(builder: (context) => AddRoomView());
    case routes.edit_room:
      var room = routeSettings.arguments as Room;
      return MaterialPageRoute(builder: (context) => EditRoomView(room: room,));
    case routes.add_user:
      return MaterialPageRoute(builder: (context) => AddUserView());
    case routes.edit_user:
      var user = routeSettings.arguments as User;
      return MaterialPageRoute(builder: (context) => EditUserView(user: user,));
    case routes.add_movie:
      return MaterialPageRoute(builder: (context) => AddMovieView());
    case routes.edit_movie:
      var movie = routeSettings.arguments as Movie;
      return MaterialPageRoute(builder: (context) => EditMovieView(movie: movie,));
    case routes.add_showtime:
      return MaterialPageRoute(builder: (context) => AddShowtimeView());
    case routes.edit_showtime:
      var showtime = routeSettings.arguments as Showtime;
      return MaterialPageRoute(builder: (context) => EditShowtimeView(showtime: showtime,));
    case routes.ticket_detail:
      var id = routeSettings.arguments as String;
      return MaterialPageRoute(builder: (context) => DetailTicketView(ticketId: id,));
    default:
      return MaterialPageRoute(builder: (context) => LoginView());
  }

}