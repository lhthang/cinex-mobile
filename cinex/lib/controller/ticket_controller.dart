import 'dart:convert';

import 'package:cinex/model/showtime.dart';
import 'package:cinex/model/ticket/ticket.dart';
import 'package:cinex/model/ticket/ticket_detail.dart';
import 'package:cinex/model/ticket/ticket_req.dart';
import 'package:cinex/model/ticket/ticket_resp.dart';
import 'package:cinex/utils/constant.dart';
import 'package:cinex/utils/func.dart';
import 'package:cinex/utils/store.dart';
import 'package:http/http.dart' as http;

class TicketController {
  Store store = new Store();
  TicketResponse ticketResponse ;
  List<Ticket> tickets;
  static TicketController _instance;

  static TicketController get instance {
    if (_instance == null) _instance = new TicketController();
    return _instance;
  }

  Future<http.Response> buyTickets(TicketRequest ticketRequest) async {
    String token = await store.get("token");
    List<Map> tickets = new List();
    for (var name in ticketRequest.tickets){
      Map data = {
        'name': name,
        'discountName': "",
      };
      tickets.add(data);
    }

    Map request = {
      'tickets': tickets,
      'showtimeId': ticketRequest.showtimeId,
    };
    var body = json.encode(request);
    final response =
        await http.post('$url/tickets/buy-tickets', body: body, headers: createHeaderWithAuth(token));
    return response;
  }

  Future<List<Ticket>> getAllTickets() async {
    String token = await store.get("token");
    final response = await http.get('$url/tickets/history',headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      tickets =
          list.map((ticket) => Ticket.fromJson(ticket)).toList();
      return tickets;
    }
    return null;
  }

  Future<List<Ticket>> searchTickets(String keyword) async {
    List<Ticket> items = tickets;
    if (keyword.trim() == ''){
      return items;
    }
    return items.where((item) => item.id.indexOf(keyword.toUpperCase()) != -1
        ||item.showtimeId.toUpperCase().indexOf(keyword.toUpperCase())!=-1).toList();
  }

  Future<TicketDetail> getTicketById(Ticket ticket) async {
    String token = await store.get("token");
    final response = await http.get('$url/tickets/username/'+ticket.username+"/"+ticket.id,headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      TicketDetail ticket= TicketDetail.fromJson(json.decode(response.body));
      return ticket;
    }
    return null;
  }
}