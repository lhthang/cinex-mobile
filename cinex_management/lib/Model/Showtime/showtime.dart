import 'package:cinex_management/Model/Room/room.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';

class Showtime{
  String id;
  String movieId;
  String movie;
  ScreenType screenType;
  Room room;
  String startAt;
  String endAt;
  double price;
  List<String> seats;
  String status;
  String poster;

  Showtime({this.id,this.movie,this.movieId,this.screenType,
    this.room,this.startAt,this.endAt,this.price,this.seats,this.status,this.poster});

  factory Showtime.fromJson(Map<String,dynamic> json){
    Room room = Room.fromJson(json['room']);
    ScreenType screenType = ScreenType.fromJson(json['screenType']);
    List<String> seats = new List();
    if (json['seats']!=null)
      seats=List<String>.from(json['seats']);
    return Showtime(
      id:json['showtime']['id'],
      movieId:json['showtime']['movieId'],
      movie: json['movie'],
      poster: json['poster'],
      price: json['showtime']['price'],
      startAt: json['showtime']['startAt'],
      endAt: json['showtime']['endAt'],
      room: room,
      seats: seats,
      screenType: screenType,
      status: json['showtime']['status'],
    );
  }
}