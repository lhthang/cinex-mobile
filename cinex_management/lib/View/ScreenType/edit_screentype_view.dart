import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/Controller/ScreenTypeController/screentype_controller.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/utils/theme.dart' as theme;
import 'package:cinex_management/dialog/dialog.dart' as dialog;

class EditScreenTypeView extends StatefulWidget {
  final ScreenType screenType;
  EditScreenTypeView({Key key, @required this.screenType}) : super(key: key);

  @override
  _EditScreenTypeViewState createState() => _EditScreenTypeViewState();
}

class _EditScreenTypeViewState extends State<EditScreenTypeView> {
  TextEditingController _idController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    _idController.text= widget.screenType.id.toString();
    _nameController.text= widget.screenType.name.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Screen Type"),
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
      style: theme.itemStyle,
      decoration: new InputDecoration(labelText: 'ID:', labelStyle: theme.itemStyle2),
    );
  }

  _buildName(){
    return new TextField(
      controller: _nameController,
      style: theme.itemStyle,
      decoration: new InputDecoration(labelText: 'Name:', labelStyle: theme.itemStyle2),
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
            style: theme.itemStyle,
          ),
          onPressed: () {
            //print(_nameController.text);
            _updateScreenType();
          },
        ),
      ),
    );
  }

  _updateScreenType(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm', style: theme.titleStyle),
            content: new Text('Do you want to update this screen type ?', style: theme.contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: theme.okButtonStyle),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (_nameController.text.trim() != '') {
                    if (await ScreenTypeController.instance.updateScreenType(widget.screenType.id, _nameController.text)) {
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
                child: new Text('Cancel', style: theme.cancelButtonStyle),
                onPressed: ()  {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
