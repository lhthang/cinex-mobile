import 'dart:convert';
import 'package:cinex_scan/constant/constant.dart';
import 'package:cinex_scan/constant/store.dart';
import 'package:cinex_scan/model/ticket.dart';
import 'package:cinex_scan/model/ticket_detail.dart';
import 'package:http/http.dart' as http;

class TicketController {
  Store store = new Store();

  List<TicketDetail> tickets ;
  static TicketController _instance;

  static TicketController get instance {
    if (_instance == null) _instance = new TicketController();
    return _instance;
  }

  Future<List<TicketDetail>> checkIn(String ticketIds) async {
    String token = await store.get("token");
    Map data = {
      'ids': ticketIds,
    };
    //encode Map to JSON
    var body = json.encode(data);
    final response = await http.post('$url/tickets/check-in',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    if (response.statusCode == 200) {
      Iterable list= json.decode(response.body).toList();
      tickets=list.map((ticket)=>TicketDetail.fromJson(ticket)).toList();
      return tickets;
    }
    return null;
  }
}
