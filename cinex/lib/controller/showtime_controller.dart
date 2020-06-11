import 'dart:convert';

import 'package:cinex/model/showtime.dart';
import 'package:cinex/utils/constant.dart';
import 'package:cinex/utils/func.dart';
import 'package:cinex/utils/store.dart';
import 'package:http/http.dart' as http;

class ShowtimeController {
  Store store = new Store();
  List<Showtime> showtimes ;
  static ShowtimeController _instance;

  static ShowtimeController get instance {
    if (_instance == null) _instance = new ShowtimeController();
    return _instance;
  }


  Future<List<Showtime>> getAllShowtimes() async {
    final response = await http.get('$url/showtimes');
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      showtimes =
          list.map((showtime) => Showtime.fromJson(showtime)).toList();
      return showtimes;
    }
    return null;
  }

  Future<List<Showtime>> getAllShowtimesByMovieId(String movieId) async {
    final response = await http.get('$url/showtimes/movie/'+movieId);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      showtimes =
          list.map((showtime) => Showtime.fromJson(showtime)).toList();
      print(showtimes.length);
      return showtimes;
    }
    return null;
  }

  List<Showtime> filterShowtimes(List<Showtime> list,DateTime date){
    List<Showtime> items = List.from(list);
    List<Showtime> results = new List();
    for (var showtime in items){
      DateTime dateTime = getDateTimeFromString(showtime.startAt);
      if(compareDate(dateTime, date))
        results.add(showtime);
    }
    return results;
  }

  Future<Showtime> getShowtimeById(String showtimeId) async {
    final response = await http.get('$url/showtimes/'+showtimeId);
    if (response.statusCode == 200) {
      Showtime showtime =Showtime.fromJson(json.decode(response.body));
      return showtime;
    }
    return null;
  }

}