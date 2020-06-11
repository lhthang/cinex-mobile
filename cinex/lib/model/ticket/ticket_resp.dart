import 'package:cinex/model/ticket/ticket.dart';

class TicketResponse{
  List<Ticket> tickets;
  String qrCode;
  double totalPrice;

  TicketResponse({this.tickets,this.qrCode,this.totalPrice});

  factory TicketResponse.fromJson(Map<String,dynamic> json){
    List list = json['tickets'] as List;
    List<Ticket> ticketsList = list.map((ticket) =>
        Ticket.fromJson(ticket)).toList();
    return TicketResponse(
      qrCode: json['qrCode'],
      tickets: ticketsList,
      totalPrice: json['totalPrice'],
    );
  }
}