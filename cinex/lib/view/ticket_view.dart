import 'dart:convert';
import 'package:cinex/controller/ticket_controller.dart';
import 'package:cinex/controller/user_controller.dart';
import 'package:cinex/model/checkout_data.dart';
import 'package:cinex/model/showtime.dart';
import 'package:cinex/model/ticket/ticket_req.dart';
import 'package:cinex/model/ticket/ticket_resp.dart';
import 'package:cinex/model/user.dart';
import 'package:cinex/route/route_path.dart';
import 'package:cinex/utils/func.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:cinex/dialog/dialog.dart' as dialog;

class TicketView extends StatefulWidget {
  final List<String> tickets;
  final Showtime showtime;
  final User user;
  TicketView({Key key,@required this.tickets,@required this.showtime,
    @required this.user}) : super(key:key);
  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  Future<User> user = UserController.instance.getUserDetail();

  bool isConfirm = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.tickets);
    print(widget.showtime.startAt);
  }

  _getPrice(List<String> list){
    return list.length* widget.showtime.price;
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

  _renderView() {
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
              margin: EdgeInsets.only(top:10,left: 30,right: 30),
              child: Divider(
                color: Color(0xff7b73e0),
                thickness: 3,
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top:20,left: 30,right: 30),
                child: _renderBookSeatsInfo(user),
              ),
            )
          ],
        )
      ],
    );
  }

  _renderBookSeatsInfo(Future<User> user){
    return FutureBuilder(
      future: user,
      builder: (context,snapshot){
        if (snapshot.hasData && snapshot.connectionState==ConnectionState.done){
          return ListView(
            padding: EdgeInsets.only(top: 10),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _renderInfo("Movie", widget.showtime.movie),
              _renderInfo("Room", widget.showtime.room.name),
              _renderInfo("Start on", formatDateFromString(widget.showtime.startAt)),
              _renderInfo("Start at", formatTimeFromString(widget.showtime.startAt)),
              _renderInfo("Seats", widget.tickets.join(", ")),
              _renderInfo("Wallet","\$"+snapshot.data.cPoint.toString()),
              _renderInfo("Total", "\$"+_getPrice(widget.tickets).toString()),
              _renderInfo("New wallet", "\$"+(snapshot.data.cPoint-_getPrice(widget.tickets)).toString()),
              _renderButton(),
            ],
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  _renderTitleScreen() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 50),
      child: Text(
        "Summary",
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
          child: Text("Check out",style: new TextStyle( fontFamily: 'Dosis',
              fontSize: 15, fontWeight: FontWeight.w500)),
          onPressed: () async {
             isConfirm = await _checkout();
             if(isConfirm){
               TicketRequest ticketRequest = new TicketRequest(tickets: widget.tickets,showtimeId: widget.showtime.id);
               Response response = await TicketController.instance.buyTickets(ticketRequest);
               if (response.statusCode==200){
                 TicketResponse ticketResponse = TicketResponse.fromJson(jsonDecode(response.body));
                 CheckoutData checkoutData = new CheckoutData(showtime: widget.showtime,ticketResponse: ticketResponse);
                 Navigator.of(context).pushNamed(checkout,arguments: checkoutData);
               }
               if (response.statusCode==400){
                 String message = jsonDecode(response.body)['message'];
                 dialog.showErrorMessage(this.context,"Error", message + '\nPlease try again!').show();
               }
             }
          },
        ),
      ),
    );
  }

  _checkout() async {
    bool value = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to book seats?', style:
              TextStyle(color: Color.fromARGB(255, 38, 54, 70), fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500)),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: new Text('Cancel', style:
                  TextStyle(color: Colors.redAccent, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
    return value == true;
  }
}
