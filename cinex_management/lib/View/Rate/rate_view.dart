import 'package:cinex_management/Controller/RateController/rate_controller.dart';
import 'package:cinex_management/Model/Rate/rate.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/route/route_path.dart' as routes;
import 'package:cinex_management/dialog/dialog.dart' as dialog;


class RateView extends StatefulWidget {
  @override
  _RateViewState createState() => _RateViewState();
}

class _RateViewState extends State<RateView> {

  String searchKey = "";
  Future<List<Rate>> ratesList = RateController.instance.getAllRates();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildSearchBar(),
          SizedBox(
            height: 10,
          ),
          Expanded(child: _buildData(ratesList)),
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
                  ratesList =
                      RateController.instance.searchRate(searchKey);
                });
              },
              onSubmitted: null,
              decoration: InputDecoration.collapsed(
                  hintText: "Enter name for search..."),
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
                  Icons.add,
                  color: Color.fromARGB(180, 38, 54, 70),
                  size: 19.0,
                ),
                new Text(
                  'Add',
                  style: TextStyle(
                      color: Color.fromARGB(180, 38, 54, 70),
                      fontFamily: 'Dosis',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            onPressed: () async {
              await Navigator.of(context).pushNamed(routes.add_rate);
              setState(() {
                ratesList= RateController.instance.getAllRates();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildData(Future<List<Rate>> rateList) {
    return FutureBuilder(
      future: rateList,
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
              return _renderRate(snapshot.data[index]);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _renderRate(Rate rate){
    return Container(
      //padding: EdgeInsets.only(left: 5,right: 5),
      height: 100,
      child: Card(
        elevation: 1.25,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                //padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.sentiment_satisfied,
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
                      child: Text(rate.name,
                          style: mainTitle),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text("Min age: "+rate.minAge.toString(),
                            style: subTitle),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(rate.id,style: TextStyle(fontSize: 12,color: Colors.black54)),
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
                        await Navigator.pushNamed(context,routes.edit_rate,arguments: rate);
                        setState(() {
                          ratesList=RateController.instance.getAllRates();
                        });
                      },
                      child: new Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                        size: 24.0,
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        _deleteRate(rate);
                      },
                      child: new Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 24.0,
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
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

  _deleteRate(Rate rate){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm', style: titleStyle),
            content: new Text('Do you want to delete this rate: ' + rate.name + '?',
                style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Ok', style: okButtonStyle),
                  onPressed: () async {
                    /* Pop screens */
                    Navigator.of(context).pop();
                    if (await RateController.instance.deleteRate(rate.id)) {
                      setState(() {
                        ratesList = RateController.instance.getAllRates();
                      });
                      dialog.showSuccessMessage(
                          this.context, "Success", "Deleted "+ rate.name+ " successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Deleted failed.' + '\nPlease try again!').show();
                  }),
              new FlatButton(
                child: new Text('Cancel', style: cancelButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
