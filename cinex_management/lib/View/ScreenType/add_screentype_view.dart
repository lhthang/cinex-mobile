import 'package:cinex_management/Controller/ScreenTypeController/screentype_controller.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:flutter/material.dart';
import 'package:cinex_management/utils/theme.dart' as theme;


class AddScreenTypeView extends StatefulWidget {
  @override
  _AddScreenTypeViewState createState() => _AddScreenTypeViewState();
}

class _AddScreenTypeViewState extends State<AddScreenTypeView> {

  String newScreenTypeName= "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Screen Type"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            createName(),
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
          newScreenTypeName=text;
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
            'Create ScreenType',
            style: TextStyle(
                color: theme.fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _createScreenType();
          },
        ),
      ),
    );
  }


  _createScreenType() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to create new screen type ?', style: theme.contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  Navigator.of(context).pop();
                  if (newScreenTypeName != '') {
                    if (await ScreenTypeController.instance.insertScreenType(newScreenTypeName) ){
                      dialog.showSuccessMessage(
                          this.context, "Success", "Create new screen type successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Create new screen type failed.' + '\nPlease try again!').show();
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
