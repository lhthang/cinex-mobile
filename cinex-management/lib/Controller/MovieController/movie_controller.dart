import 'dart:convert';

import 'package:cinex_management/Model/Movie/movie.dart';
import 'package:cinex_management/Model/Movie/movie_req.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

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

  Future<bool> insertMovie(MovieRequest newMovie) async {
    String token = await store.get("token");
    Map data = {
      'imdbID': newMovie.imdbID,
      'screenTypeIds': newMovie.screenTypeIds,
      'endAt': newMovie.endAt,
      'wallpaper': newMovie.wallpaper,
    };
    var body = json.encode(data);
    final response = await http.post('$url/movies',
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateMovie(String id,MovieRequest newMovie) async {
    String token = await store.get("token");
    Map data = {
      'screenTypeIds': newMovie.screenTypeIds,
      'endAt': newMovie.endAt,
      'wallpaper': newMovie.wallpaper,
      'poster': newMovie.poster,
      'rateId': newMovie.rateId,
      'title': newMovie.title,
      'genreIds':newMovie.genreIds,
    };
    var body = json.encode(data);
    final response = await http.put('$url/movies/'+id,
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<Movie>> searchMovie(String keyword) async {
    List<Movie> items = movies;
    if (keyword.trim() == '') return items;
    return items.where((item) => item.title.toUpperCase().indexOf(keyword.toUpperCase()) != -1
    ||item.country.toUpperCase().indexOf(keyword.toUpperCase()) != -1).toList();
  }

  Future<bool> deleteMovie(String id) async {
    String token = await store.get("token");
    final response = await http.delete('$url/movies/'+id,
        headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
