import 'package:cinex_management/Model/Ticket/ticket.dart';

class TicketDetail{
  Ticket ticket;
  String room;
  String movie;
  String screenType;
  String poster;

  TicketDetail({this.ticket,this.room,this.movie,this.screenType,this.poster});

  factory TicketDetail.fromJson(Map<String,dynamic> json){
    Ticket ticket = Ticket.fromJson(json['ticket']);
    return TicketDetail(
      ticket: ticket,
      room: json['room'],
      screenType: json['screenType'],
      movie: json['movie'],
      poster: json['poster'],
    );
  }
}