import 'package:cinex_management/Controller/TicketController/ticket_controller.dart';
import 'package:cinex_management/Model/Ticket/detail_ticket.dart';
import 'package:cinex_management/Model/Ticket/ticket.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';

class DetailTicketView extends StatefulWidget {
  final String ticketId;

  DetailTicketView({Key key, @required this.ticketId}) : super(key:key);
  @override
  _DetailTicketViewState createState() => _DetailTicketViewState();
}

class _DetailTicketViewState extends State<DetailTicketView> {


  Future<TicketDetail> ticket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ticket=TicketController.instance.getTicketById(widget.ticketId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Showtime"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _buildView(ticket),
      ),
    );
  }

  _buildView (Future<TicketDetail> ticket){
    return FutureBuilder(
        future: ticket,
        builder: (context,snapshot){
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            TicketDetail ticketDetail = snapshot.data;
            String startAt =formatDateFromString(ticketDetail.ticket.startAt)+ " - "+
                formatTimeFromString(ticketDetail.ticket.startAt);
            String buyAt =formatDateFromString(ticketDetail.ticket.buyAt)+ " - "+
                formatTimeFromString(ticketDetail.ticket.buyAt);
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Center(
                    child: Text(ticketDetail.movie,style: mainTitle,)),
                _createPoster(ticketDetail),
                _createScreenType(ticketDetail.screenType),
                _createField("ID:",ticketDetail.ticket.id),
                _createField("Price",ticketDetail.ticket.price.toString()),
                _createField("Room",ticketDetail.room),
                _createField("Start at",startAt),
                _createField("Buy at",buyAt),
                _createField("Buyer",ticketDetail.ticket.username),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  _createPoster(TicketDetail ticketDetail) {
    return Container(
      padding: EdgeInsets.only(top:15,left: 100,right: 100),
      child: Image.network(ticketDetail.poster,scale: 0.5,)
    );
  }

  _createField(String title,String value){
    return new TextFormField(
      initialValue: value,
      enabled: false,
      style: itemStyle,
      decoration: new InputDecoration(labelText: title, labelStyle: itemStyle2),
    );
  }

  _createScreenType(String screenType){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent,width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Align(
                alignment: Alignment.center,
                child: Text(screenType,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        )
      ],
    );
  }
}
