import 'package:cinex_management/Controller/GenreController/genre_controller.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:flutter/material.dart';
import 'package:cinex_management/utils/theme.dart' as theme;

class AddGenreView extends StatefulWidget {
  @override
  _AddGenreViewState createState() => _AddGenreViewState();
}

class _AddGenreViewState extends State<AddGenreView> {
  String newGenreName= "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Genre"),
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
          newGenreName=text;
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
            'Create Genre',
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
            content: new Text('Do you want to create new genre ?', style: theme.contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  Navigator.of(context).pop();
                  if (newGenreName != '') {
                    if (await GenreController.instance.insertGenre(newGenreName) ){
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
