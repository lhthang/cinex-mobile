import 'package:cinex_management/Model/Genre/genre.dart';
import 'package:cinex_management/Model/Rate/rate.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';

class Movie {
  final String id;
  final String title;
  final int runtime;
  final List<String> actors;
  final List<String> directors;
  final List<Genre> genres;
  final List<ScreenType> screenTypes;
  final String country;
  final String wallpaper;
  final String poster;
  final String released;
  final String endAt;
  final Rate rate;

  Movie(
      {this.id,
        this.title,
        this.genres,
        this.poster,
        this.runtime,
        this.released,
        this.rate,
        this.wallpaper,
        this.screenTypes,
        this.actors,
        this.country,
        this.directors,
        this.endAt,
      });

  factory Movie.fromJson(Map<String, dynamic> json) {
    var list = json['genres'] as List;
    List<Genre> genres = list.map((genre) => Genre.fromJson(genre)).toList();
    list = json['screenTypes'] as List;
    List<ScreenType> screenTypesList = list.map((screenType) => ScreenType.fromJson(screenType)).toList();
    List<String> directors = new List<String>();
    if (json['movie']['directors']!=null)
      directors=List<String>.from(json['movie']['directors']);
    List<String> actors = new List<String>();
    if (json['movie']['actors']!=null)
      actors=List<String>.from(json['movie']['directors']);
    Rate movieRate = new Rate();
    if (json['rate'] != null) movieRate = Rate.fromJson(json['rate']);
    return Movie(
      id: json['movie']['id'],
      title: json['movie']['title'],
      genres: genres,
      poster: json['movie']['poster'],
      runtime: json['movie']['runtime'],
      released: json['movie']['released'],
      rate: movieRate,
      wallpaper: json['movie']['wallpaper'],
      directors: directors,
      screenTypes:screenTypesList ,
      country: json['movie']['country'],
      actors: actors,
      endAt: json['movie']['endAt'],
    );
  }

  @override
  String toString() {
    return title;
  }
}