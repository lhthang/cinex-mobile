import 'package:cinex_scan/constant/func.dart';
import 'package:cinex_scan/controller/scan_controller.dart';
import 'package:cinex_scan/model/ticket.dart';
import 'package:cinex_scan/model/ticket_detail.dart';
import 'package:flutter/material.dart';
class TicketView extends StatefulWidget {
  final String ids;
  TicketView({Key key, @required this.ids}) : super(key: key);
  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  Future<List<TicketDetail>> ticketList;
  @override
  void initState(){
    super.initState();
    ticketList= TicketController.instance.checkIn(widget.ids);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
          margin: EdgeInsets.only(left: 10,right: 10),
          child: Column(
            children: <Widget>[
              _renderTitleScreen(),
              Expanded(
                  child: Container(
                    child: _buildData(ticketList),
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
      margin: EdgeInsets.only(top: 20),
      child: Text(
        "Check in",
        style: new TextStyle( fontFamily: 'Dosis',
            fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  _buildData(Future<List<TicketDetail>> tickets){
    return FutureBuilder(
      future: tickets,
      builder: (BuildContext context,
          AsyncSnapshot<List<TicketDetail>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData){
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _renderTicket(snapshot.data[index]);
              },
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Dont have any valid tickets",textAlign: TextAlign.center,)
              ],
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }


  _renderTicket(TicketDetail ticket) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 28,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    child: Container(
                    ),
                  ),
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Material(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Color(0xff5837a6),
                                elevation: 1.5,
                                child: InkWell(
                                  child: Container(
                                    height: 165.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                      )),
                  Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          //color: Colors.greenAccent,
                          height: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                              Expanded(
                                  flex: 10,
                                  child:ClipRRect(
                                      child: Image.network(
                                        ticket.poster,
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10)))
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                flex: 18,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        ticket.room,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Seat: "+ ticket.ticket.name,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        formatDateFromString(ticket.ticket.startAt),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Time: "+formatTimeFromString(ticket.ticket.startAt),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ],
    );
  }
}
