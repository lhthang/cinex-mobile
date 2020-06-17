import 'package:cinex/controller/showtime_controller.dart';
import 'package:cinex/controller/user_controller.dart';
import 'package:cinex/model/showtime.dart';
import 'package:cinex/model/summary_ticket.dart';
import 'package:cinex/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cinex/dialog/dialog.dart' as dialog;
import 'package:cinex/route/route_path.dart' as routes;

class BookSeatView extends StatefulWidget {
  final String showtimeId;

  BookSeatView({Key key, @required this.showtimeId}) : super(key : key);
  @override
  _BookSeatViewState createState() => _BookSeatViewState();
}

class _BookSeatViewState extends State<BookSeatView> {

  Future<Showtime> showtime;
  Map<String,int> values = {};
  Map<String,int> previousValues = {};

  List<String> tickets = new List();

  Showtime detailShowtime;
  initTickets(){
    for (int i = 0;i<detailShowtime.room.totalRows;i++){
      for(int j =0;j<detailShowtime.room.totalSeatsPerRow;j++){
        String name = String.fromCharCode(i+65)+(j+1).toString();
        tickets.add(name);
        values[name] = previousValues[name]!=0?previousValues[name]:0;
      }
    }
    if(detailShowtime.seats.length>0){
      for(var seat in detailShowtime.seats){
        values[seat] = 2;
      }
    }
    previousValues=new Map.from(values);
  }

  List<String> _getSelectedTickets(){
    List<String> selectedTickets = new List();
    for (var key in values.keys){
      if(values[key]==1)
        selectedTickets.add(key);
    }
    return selectedTickets;
  }

  _getPrice(List<String> list){
    return list.length* detailShowtime.price;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showtime = ShowtimeController.instance.getShowtimeById(widget.showtimeId);
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
              child: _renderShowtime(showtime),
            )
          ],
        )
      ],
    );
  }

  _renderShowtime(Future<Showtime> showtime) {
    return FutureBuilder(
      future: showtime,
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.done && snapshot.hasData){
          detailShowtime = snapshot.data;
          initTickets();
          return Column(
            children: <Widget>[
              _renderScreenType(),
              _renderSeats(),
              _renderNote(),
              _renderTickets(),
              _renderButton(),
            ],
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  _renderScreenType(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue),
        borderRadius: BorderRadius.circular(3),
      ),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(4),
      child: Text(detailShowtime.screenType.name,style: new TextStyle( fontFamily: 'Dosis',
          fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xff7b73e0)),),
    );
  }

  _renderTitleScreen() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Select Seats",
                style: new TextStyle( fontFamily: 'Dosis',
                    fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
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
          child: Text("Confirm Seat",style: new TextStyle( fontFamily: 'Dosis',
              fontSize: 15, fontWeight: FontWeight.w500)),
          onPressed: () async {
            List<String> tickets = _getSelectedTickets();
            if (tickets.length<=0){
              dialog.showErrorMessage(
                          context, "Error", "You don't select any seats").show();
                    
            }else{
              SummaryTickets summaryTickets = new SummaryTickets(tickets: tickets,showtime: detailShowtime);
              await Navigator.of(context).pushNamed(routes.tickets,arguments: summaryTickets);
              showtime = ShowtimeController.instance.getShowtimeById(widget.showtimeId);
            }
            
          },
        ),
      ),
    );
  }

  _renderSeats(){
    return Expanded(
      child:Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 10,left: 5,right: 5),
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildHeaderRow(detailShowtime.room.totalRows+1),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildRows(detailShowtime.room.totalRows,detailShowtime.room.totalSeatsPerRow),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  _buildHeader(int count){
    return List.generate(
      count,
          (index) => Container(
        alignment: Alignment.center,
        width: 30.0,
        height: 25.0,
        //color: Colors.redAccent,
        margin: EdgeInsets.all(5.0),
        child: Text("${index + 1}", style: TextStyle(
            fontSize: 12,
            color: Colors.lightBlue,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold)),
      ),
    );
  }

  _buildHeaderRow(int count){
    return List.generate(
      count,
          (index) => Container(
        alignment: Alignment.center,
        width: 30.0,
        height: 25.0,
        //color: Colors.redAccent,
        margin: EdgeInsets.all(5.0),
        child:index==0?Container(): Text(String.fromCharCode(index+64), style: TextStyle(
            fontSize: 12,
            color: Colors.lightBlue,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<Widget> _buildCells(int row,int count) {
    List<Widget> list = new List();
    for (int i=0;i<count;i++){
      String name = String.fromCharCode(row+65)+(i+1).toString();
      list.add(Container(
        margin: EdgeInsets.all(5),
        child: Material(
          borderRadius: BorderRadius.circular(2),
          elevation: 2,
          color: values[name]==2? Colors.lightBlue: values[name]==1?Color(0xffffad6b):Color(0xff5837a6),
          child: new InkWell(
            child: SizedBox(width: 30,height: 25,),
            onTap: values[name]!=2?(){
              setState(() {
                values[name] = values[name]==0?1:0;
                previousValues = new Map.from(values);
              });

            }:null,
          ),
        ),
      ));
    }
    return list;
  }

  List<Widget> _buildRows(int row,int column) {
    List<Widget> list = new List();
    list.add(Row(
      children: _buildHeader(column),
    ));
    List<Widget> list2= List.generate(
      row,
          (index) => Row(
        children: _buildCells(index,column),
      ),
    );
    for(var item in list2)
      list.add(item);
    return list;
  }

  _renderNote(){
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10,bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _renderNoteItem("Selected",Color(0xffffad6b)),
          ),
          Expanded(
            flex: 1,
            child: _renderNoteItem("Available",Color(0xff5837a6)),
          ),
          Expanded(
            flex: 1,
            child: _renderNoteItem("Reserved",Colors.lightBlue),
          )
        ],
      )
    );
  }

  _renderNoteItem(String title, Color color){
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(5),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(2),
            color: color,
            child: new InkWell(
              child: SizedBox(width: 15,height: 15,),
            ),
          ),
        ),
        Text(title,style: TextStyle(
            fontSize: 12,
            color: Colors.lightBlue,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold))
      ],
    );
  }

  _renderTickets(){
    List<String> tickets = _getSelectedTickets();
    String text = tickets.join(", ");
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff5837a6),
        borderRadius: BorderRadius.circular(2),
      ),
      margin: EdgeInsets.only(left: 10,right: 10,bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(5),
              child: Text(text,style: new TextStyle( fontFamily: 'Dosis',
                  fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(5),
              child: Text("\$"+_getPrice(tickets).toString(),style: new TextStyle( fontFamily: 'Dosis',
                  fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
