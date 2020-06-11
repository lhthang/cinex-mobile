import 'package:cinex_scan/model/movie.dart';
import 'package:cinex_scan/model/room.dart';

class Showtime{
  String id;
  Movie movie;
  Room room;
  DateTime startAt;

  Showtime({this.id,this.movie,this.room,this.startAt});
  factory Showtime.fromJson(Map<String, dynamic> json) {
    Movie movie = new Movie();
    movie= Movie.fromJson(json['movie']);
    Room room= new Room();
    room=Room.fromJson(json['room']);
    return Showtime(
      id: json['id'],
      startAt:DateTime.parse(json['startAt']).toUtc() ,
      movie:movie,
      room: room,
    );
  }
}