import 'package:cinex_management/Controller/RateController/rate_controller.dart';
import 'package:cinex_management/Model/Rate/rate.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:cinex_management/utils/theme.dart' as theme;

class AddRateView extends StatefulWidget {
  @override
  _AddRateViewState createState() => _AddRateViewState();
}

class _AddRateViewState extends State<AddRateView> {
  String newRateName= "";
  int minAge =100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Rate"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            createName(),
            createMinAge(),
            createButton(),
          ],
        ),
      ),
    );
  }

  createName(){
    return TextField(
      style: TextStyle(
          color: theme.fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(labelText: 'Name:', labelStyle: TextStyle(
          color: theme.accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          newRateName=text;
        });
      },
    );
  }

  createMinAge(){
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(
          color: theme.fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(labelText: 'Min age:', labelStyle: TextStyle(
          color: theme.accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          minAge=num.tryParse(text);
        });
      },
    );
  }

  createButton(){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: double.infinity,
        child: new RaisedButton(
          color: Colors.greenAccent,
          child: new Text(
            'Create Rate',
            style: TextStyle(
                color: theme.fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _createGenre();
          },
        ),
      ),
    );
  }

  _createGenre() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to create new rate ?', style: theme.contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  Navigator.of(context).pop();
                  if (newRateName != '') {
                    Rate newRate = new Rate(name: newRateName,minAge: minAge);
                    if (await RateController.instance.insertRate(newRate) ){
                      dialog.showSuccessMessage(
                          this.context, "Success", "Create new genre successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Create new genre failed.' + '\nPlease try again!').show();
                    return;
                  }
                  dialog.showErrorMessage(this.context,"Error", 'Invalid name.' + '\nPlease try again!').show();
                },
              ),
              new FlatButton(
                child: new Text('Cancel', style: theme.cancelButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
