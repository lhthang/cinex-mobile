import 'dart:convert';

import 'package:cinex/model/showtime.dart';
import 'package:cinex/model/ticket/ticket_resp.dart';
import 'package:cinex/route/route_path.dart';
import 'package:cinex/utils/constant.dart';
import 'package:cinex/utils/func.dart';
import 'package:flutter/material.dart';


class CheckOutView extends StatefulWidget {
  final TicketResponse ticketResponse;
  final Showtime showtime;
  CheckOutView({Key key,@required this.ticketResponse,@required this.showtime}) : super(key : key);
  @override
  _CheckOutViewState createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    List<String> ticketsName =new List();
    for(var ticket in widget.ticketResponse.tickets){
      ticketsName.add(ticket.name);
    }
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
        Column(
          children: <Widget>[
            _renderTitleScreen(),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top:10,left: 30,right: 30),
              child: Text("Please capture this QR CODE",style: new TextStyle( fontFamily: 'Dosis',
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.lightBlue),),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top:10,left: 30,right: 30),
              child: Text("This QR CODE is also sent to your email",style: new TextStyle( fontFamily: 'Dosis',
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.lightBlue),),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top:20,left: 30,right: 30),
                child: Column(
                  children: <Widget>[
                    Image.memory(base64Decode(widget.ticketResponse.qrCode),width: 200,height: 200,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: ListView(
                          padding: EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          children: <Widget>[
                            _renderInfo("Movie", widget.showtime.movie),
                            _renderInfo("Room", widget.showtime.room.name),
                            _renderInfo("Start on", formatDateFromString(widget.ticketResponse.tickets[0].startAt)),
                            _renderInfo("Start at", formatTimeFromString(widget.ticketResponse.tickets[0].startAt)),
                            _renderInfo("Seats", ticketsName.join(", ")),
                          ],
                        ),
                      ),
                    ),
                    _renderButton(),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  _renderTitleScreen() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 30),
      child: Text(
        "Tickets",
        style: new TextStyle( fontFamily: 'Dosis',
            fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  _renderInfo(String title, String info){
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(5),
                  child: Text(title,style: new TextStyle( fontFamily: 'Dosis',
                      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.lightBlue)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(5),
                  child: Text(info,style: new TextStyle( fontFamily: 'Dosis',
                      fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                ),
              )
            ],
          ),
          Divider(
            color:Colors.lightBlue ,
            thickness: 1,
          )
        ],
      ),
    );
  }
  _renderButton(){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,bottom: 5),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          color: Color(0xff44c7cb),
          child: Text("Back",style: new TextStyle( fontFamily: 'Dosis',
              fontSize: 15, fontWeight: FontWeight.w500)),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(home,ModalRoute.withName(home));
          },
        ),
      ),
    );
  }
}

