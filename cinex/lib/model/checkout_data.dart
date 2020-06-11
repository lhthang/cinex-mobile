import 'package:cinex/model/showtime.dart';
import 'package:cinex/model/ticket/ticket_resp.dart';

class CheckoutData{
  Showtime showtime;
  TicketResponse ticketResponse;

  CheckoutData({this.showtime,this.ticketResponse});
}