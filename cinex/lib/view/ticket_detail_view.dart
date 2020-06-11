import 'package:cinex/controller/ticket_controller.dart';
import 'package:cinex/model/ticket/ticket.dart';
import 'package:cinex/model/ticket/ticket_detail.dart';
import 'package:cinex/utils/func.dart';
import 'package:flutter/material.dart';


class TicketDetailView extends StatefulWidget {
  final Ticket ticket;

  TicketDetailView({Key key, @required this.ticket}) : super(key:key);

  @override
  _TicketDetailViewState createState() => _TicketDetailViewState();
}

class _TicketDetailViewState extends State<TicketDetailView> {

  Future<TicketDetail> ticket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ticket=TicketController.instance.getTicketById(widget.ticket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          child: _renderView(),
        ),
      ),
      //backgroundColor: Colors.yellow,
    );
  }

  _renderView(){
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20,right: 20),
          child: Column(
            children: <Widget>[
              _renderTitleScreen(),
              Expanded(
                  child: Container(
                    child: _buildData(ticket),
                  )
              ),
            ],
          ),
        )
      ],
    );
  }

  _renderTitleScreen() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 30),
      child: Text(
        "Detail",
        style: new TextStyle( fontFamily: 'Dosis',
            fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  _buildData (Future<TicketDetail> ticket){
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
              padding: EdgeInsets.only(top: 5,left: 10,right: 10),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Center(
                    child: Text(ticketDetail.movie,style: TextStyle(color: Colors.lightBlue,
                        fontSize: 25,fontWeight: FontWeight.w900),)
                ),
                _createPoster(ticketDetail),
                _createScreenType(ticketDetail.screenType),
                _createField("ID:",ticketDetail.ticket.id),
                _createField("Room",ticketDetail.room),
                _createField("Start at",startAt),
                _createField("Buy at",buyAt),
                _createField("Price",ticketDetail.ticket.price.toString()),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  _createPoster(TicketDetail ticketDetail) {
    return Container(
        padding: EdgeInsets.only(top:15,left: 80,right: 80),
        child: Image.network(ticketDetail.poster,)
    );
  }

  _createField(String title,String value){
    return new TextFormField(
      initialValue: value,
      enabled: false,
      style: TextStyle(color: Colors.white,fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(labelText: title, labelStyle: TextStyle(
         color: Colors.lightBlue, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                child: Text(screenType,style: TextStyle(color: Colors.lightBlue,fontSize: 18,fontWeight: FontWeight.w900),)),
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
