import 'dart:convert';

import 'package:cinex/utils/constant.dart';
import 'package:cinex/model/movie.dart';
import 'package:cinex/utils/store.dart';
import 'package:http/http.dart' as http;

class MovieController {
  Store store = new Store();
  List<Movie> movies ;
  static MovieController _instance;

  static MovieController get instance {
    if (_instance == null) _instance = new MovieController();
    return _instance;
  }


  Future<List<Movie>> getAllMovies() async {
    final response = await http.get('$url/movies');
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      movies =
          list.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    }
    return null;
  }

  Future<List<Movie>> getAllMoviesNowOn() async {
    final response = await http.get('$url/movies/now-on');
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      movies =
          list.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    }
    return null;
  }

  Future<List<Movie>> getAllMoviesComing(int day) async {
    final response = await http.get('$url/movies/coming?in='+day.toString());
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      movies =
          list.map((movie) => Movie.fromJson(movie)).toList();
      return movies;
    }
    return null;
  }
}