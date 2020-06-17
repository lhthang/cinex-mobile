import 'package:cinex_management/Controller/RateController/rate_controller.dart';
import 'package:cinex_management/Model/Rate/rate.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;

class EditRateView extends StatefulWidget {
  final Rate rate;

  EditRateView({Key key, @required this.rate}) : super(key: key);

  @override
  _EditRateViewState createState() => _EditRateViewState();
}

class _EditRateViewState extends State<EditRateView> {

  TextEditingController _idController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _minAgeController = new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    _idController.text= widget.rate.id.toString();
    _nameController.text= widget.rate.name.toString();
    _minAgeController.text=widget.rate.minAge.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Genre"),
        centerTitle: true,
      ),
      body: Container(
        child: new Container(
            padding: const EdgeInsets.all(10.0),
            child: new ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                _buildID(),
                _buildName(),
                _buildMinAge(),
                _buildButton(),
              ],
            )),
      ),
    );
  }

  _buildID(){
    return new TextField(
      controller: _idController,
      enabled: false,
      style: itemStyle,
      decoration: new InputDecoration(labelText: 'ID:', labelStyle: itemStyle2),
    );
  }

  _buildName(){
    return new TextField(
      controller: _nameController,
      style: itemStyle,
      decoration: new InputDecoration(labelText: 'Name:', labelStyle: itemStyle2),
    );
  }

  _buildMinAge(){
    return new TextField(
      keyboardType: TextInputType.number,
      controller: _minAgeController,
      style: itemStyle,
      decoration: new InputDecoration(labelText: 'Min age:', labelStyle: itemStyle2),
    );
  }

  _buildButton(){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: double.infinity,
        child: new RaisedButton(
          color: Colors.greenAccent,
          child: new Text(
            'Save Change',
            style: itemStyle,
          ),
          onPressed: () {
            //print(_nameController.text);
            _updateRate();
          },
        ),
      ),
    );
  }

  _updateRate(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm', style: titleStyle),
            content: new Text('Do you want to update this genre ?', style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: okButtonStyle),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (_nameController.text.trim() != '' &&_minAgeController.text.trim()!='') {
                    Rate updateRate = new Rate(minAge: num.tryParse(_minAgeController.text),name: _nameController.text);
                    if (await RateController.instance.updateRate(widget.rate.id, updateRate)) {
                      dialog.showSuccessMessage(
                          this.context, "Success", "Updated successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Updated failed.' + '\nPlease try again!').show();
                    return;
                  }
                  dialog.showErrorMessage(this.context,"Error", 'Invalid name.' + '\nPlease try again!').show();
                },
              ),
              new FlatButton(
                child: new Text('Cancel', style: cancelButtonStyle),
                onPressed: ()  {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
