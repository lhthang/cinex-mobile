import 'package:cinex_management/Controller/TicketController/ticket_controller.dart';
import 'package:cinex_management/Model/Ticket/ticket.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cinex_management/route/route_path.dart' as routes;


class TicketView extends StatefulWidget {
  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  String searchKey="";

  Future<List<Ticket>> tickets= TicketController.instance.getAllTickets();

  List<String> status = new List();
  String selectedStatus;

  filterTicket(String status){
    setState(() {
      selectedStatus=status;
    });
    tickets = TicketController.instance.filterTickets(selectedStatus);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    status.add("Checked out");
    status.add("Checked in");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildSearchBar(),
          //SizedBox(height: 10,),
          _renderDropdownMenu(status),
          Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Divider(color: Colors.black,height: 1,)),
          Expanded(
            child: _buildData(tickets),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Color.fromARGB(180, 38, 54, 70).withOpacity(0.2))),
      margin: EdgeInsets.only(top: 10.0, bottom: 2.0, left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: new TextField(
              onChanged: (text) {
                setState(() {
                  searchKey = text;
                  tickets = TicketController.instance.searchTickets(tickets,searchKey,selectedStatus);
                });
              },
              onSubmitted: null,
              decoration: InputDecoration.collapsed(
                  hintText: "Enter username, showtime id..."),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          RaisedButton(
            color: Colors.greenAccent,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Icon(
                  Icons.search,
                  color: Color.fromARGB(180, 38, 54, 70),
                  size: 19.0,
                ),
                new Text(
                  'Search',
                  style: TextStyle(
                      color: Color.fromARGB(180, 38, 54, 70),
                      fontFamily: 'Dosis',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _renderDropdownMenu(List<String> list){
    return Container(
      //margin: EdgeInsets.only(left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child:SearchableDropdown.single(
        items: getItems(list),
        value: selectedStatus,
        hint: "All",
        isCaseSensitiveSearch: false,
        onChanged: (value) {
          filterTicket(value);
        },
        isExpanded: true,
      ),
    );
  }

  List<DropdownMenuItem> getItems(List<String> statusList){
    List<DropdownMenuItem<String>> list = new List();
    for (var movie in statusList){
      list.add(new DropdownMenuItem(
        child:Text(movie),
        value: movie,));
    }
    return list;
  }

  Widget _buildData(Future<List<Ticket>> ticketsList) {
    return FutureBuilder(
      future: ticketsList,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            padding: EdgeInsets.only(left: 5, right: 5),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _renderTicket(snapshot.data[index]);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _renderTicket(Ticket ticket){
    return Container(
      //padding: EdgeInsets.only(left: 5,right: 5),
      height: 150,
      child: Card(
        elevation: 1.25,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                //padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.tab,
                  size: 40,
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 5,
              child: Container(
                //padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      //padding: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(ticket.name,
                              style: mainTitle),
                          _renderStatus(ticket.status),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Text("Buyer: "+ticket.username.toString(),
                          style: subTitle),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: _renderDateTicket(ticket),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("\$"+ticket.price.toString(),style: TextStyle(fontSize: 13,color: Colors.black54))
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(ticket.id,style: TextStyle(fontSize: 12,color: Colors.black54)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async{
                        await Navigator.pushNamed(context,routes.ticket_detail,arguments: ticket.id);
                        setState(() {
                          selectedStatus=null;
                          tickets=TicketController.instance.getAllTickets();
                        });
                      },
                      child: new Icon(
                        Icons.details,
                        color: Colors.blueAccent,
                        size: 24.0,
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    SizedBox(width: 10,),
                    Container(),
                    //SizedBox(width: 5,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _renderStatus(String status){
    Color theme = Colors.greenAccent[400];
    if (status == "CHECK_IN")
      theme = Colors.redAccent[400];
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: theme),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(status),
    );
  }

  Widget _renderDateTicket(Ticket ticket){
    Color theme = Colors.redAccent[400];
    if (ticket.status=="CHECK_OUT")
      theme=Colors.greenAccent[400];
    return Text(formatDateFromString(ticket.startAt)+ " - "+
        formatTimeFromString(ticket.startAt),style: TextStyle(fontSize: 13,color: theme));
  }
}
