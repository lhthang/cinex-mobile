import 'dart:convert';

import 'package:cinex_management/Model/Movie/movie.dart';
import 'package:cinex_management/Model/Showtime/showtime.dart';
import 'package:cinex_management/Model/Showtime/showtime_req.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

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

  Future<bool> insertShowtime(ShowtimeRequest newShowtime) async {
    String token = await store.get("token");
    Map data = {
      'movieId': newShowtime.movieId,
      'screenTypeId': newShowtime.screenTypeId,
      'startAt': newShowtime.startAt,
      'price': newShowtime.price,
      'roomId': newShowtime.roomId,
    };
    var body = json.encode(data);
    final response = await http.post('$url/showtimes',
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateShowtime(String id,ShowtimeRequest newShowtime) async {
    String token = await store.get("token");
    Map data = {
      'movieId': newShowtime.movieId,
      'screenTypeId': newShowtime.screenTypeId,
      'startAt': newShowtime.startAt,
      'price': newShowtime.price,
      'roomId': newShowtime.roomId,
    };
    var body = json.encode(data);
    final response = await http.put('$url/showtimes/'+id,
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<Showtime>> filterShowtimes(Movie movie) async {
    List<Showtime> items = showtimes;
    if (movie ==null) return items;
    return items.where((item) => item.movieId==movie.id).toList();
  }

  Future<List<Showtime>> searchShowtimes(Future<List<Showtime>> list,String keyword,Movie movie) async {
    List<Showtime> items = await list;
    if (keyword.trim() == ''){
      if(items.length==0){
        return filterShowtimes(movie);
      }
      return items;
    }
    return items.where((item) => item.room.name.toUpperCase().indexOf(keyword.toUpperCase()) != -1).toList();
  }

  Future<bool> deleteShowtime(String id) async {
    String token = await store.get("token");
    final response = await http.delete('$url/showtimes/'+id,
        headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
