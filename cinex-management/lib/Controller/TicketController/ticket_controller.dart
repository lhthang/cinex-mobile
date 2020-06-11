import 'dart:convert';
import 'package:cinex_management/Model/Ticket/detail_ticket.dart';
import 'package:cinex_management/Model/Ticket/ticket.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

class TicketController {
  Store store = new Store();
  List<Ticket> tickets ;
  static TicketController _instance;

  static TicketController get instance {
    if (_instance == null) _instance = new TicketController();
    return _instance;
  }


  Future<List<Ticket>> getAllTickets() async {
    String token = await store.get("token");
    final response = await http.get('$url/tickets',headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      tickets =
          list.map((ticket) => Ticket.fromJson(ticket)).toList();
      return tickets;
    }
    return null;
  }

  Future<List<Ticket>> filterTickets(String status) async {
    String key = "";
    List<Ticket> items = tickets;
    if (status ==null) return items;
    if (status.contains("Checked in") ) key ="CHECK_IN";
    if (status.contains("Checked out")) key = "CHECK_OUT";
    return items.where((item) => item.status.toUpperCase().contains(key.toUpperCase())).toList();
  }

  Future<List<Ticket>> searchTickets(Future<List<Ticket>> list,String keyword,String status) async {
    List<Ticket> items = await list;
    if (keyword.trim() == ''){
      if(items.length==0){
        return filterTickets(status);
      }
      return items;
    }
    return items.where((item) => item.username.toUpperCase().indexOf(keyword.toUpperCase()) != -1
    ||item.showtimeId.toUpperCase().indexOf(keyword.toUpperCase())!=-1).toList();
  }

  Future<TicketDetail> getTicketById(String id) async {
    String token = await store.get("token");
    final response = await http.get('$url/tickets/'+id,headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      TicketDetail ticket= TicketDetail.fromJson(json.decode(response.body));
      return ticket;
    }
    return null;
  }
}
