import 'package:cinex_management/Controller/RoomController/room_controller.dart';
import 'package:cinex_management/Controller/ScreenTypeController/screentype_controller.dart';
import 'package:cinex_management/View/custom_selection_group.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:cinex_management/Model/Room/room_req.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddRoomView extends StatefulWidget {
  @override
  _AddRoomViewState createState() => _AddRoomViewState();
}

class _AddRoomViewState extends State<AddRoomView> {

  Future<List<ScreenType>> screenTypesList = ScreenTypeController.instance.getAllScreenTypes();

  List<ScreenType> selectedScreenTypes = new List();

  RoomRequest newRoom = new RoomRequest(name: '',screenTypeIds: [] );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Room"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _buildView(screenTypesList),
      ),
    );
  }

  _buildView (Future<List<ScreenType>> list){
    return FutureBuilder(
      future: list,
      builder: (context,snapshot){
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              createName(),
              createSeats(),
              createButtonSelectScreenType(snapshot),
              createButton(),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }

  createName() {
    return TextField(
      style: TextStyle(
          color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(labelText: 'Name:', labelStyle: TextStyle(
          color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          newRoom.name=text;
        });
      },
    );
  }

  createSeats(){
    return Container(
      //margin: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: TextField(
            keyboardType: TextInputType.number,
              style: TextStyle(
                  color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
              decoration: new InputDecoration(labelText: 'Total rows:', labelStyle: TextStyle(
                  color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
              onChanged: (text){
                setState(() {
                  newRoom.totalRows=num.tryParse(text);
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 5,right: 5),
            ),
          ),
          Expanded(
            flex: 6,
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                  color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
              decoration: new InputDecoration(labelText: 'Seats per row:', labelStyle: TextStyle(
                  color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
              onChanged: (text){
                setState(() {
                  newRoom.totalSeatsPerRow=num.tryParse(text);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  createButtonSelectScreenType(AsyncSnapshot snapshot){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              height: 30,
              child: Material(
                elevation: 1.25,
                borderRadius:  BorderRadius.circular(3),
                color: Colors.greenAccent,
                child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Icon(
                            Icons.arrow_drop_down
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("Screen type",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500) ,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    _showScreenTypesDialog(snapshot.data);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: Wrap(
              direction: Axis.horizontal,
              children:  _buildScreenTypesOfRoom(selectedScreenTypes),
            ),
          )
        ],
      ),
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
            'Create Room',
            style: TextStyle(
                color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _createRoom();
          },
        ),
      ),
    );
  }

  _buildScreenTypesOfRoom(List<ScreenType> screenTypesList){
    List<Widget> list = new List();
    if (screenTypesList.length>3){
      for(int i=0;i<3;i++){
        list.add(_buildScreenType(screenTypesList[i]));
      }
      list.add(_buildScreenType(new ScreenType(name: "...")));
      return list;
    }
    for (var screenType in screenTypesList){
      list.add(_buildScreenType(screenType));
    }
    return list;
  }

  _buildScreenType(ScreenType screenType){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(screenType.name),
    );
  }

  _showScreenTypesDialog(List<ScreenType> list){
    List<CustomSelectionItem> options = list.map((item) {
      return CustomSelectionItem(value: item.id, label: item.name);
    }).toList();

    List<String> selectedScreenTypeIds = selectedScreenTypes.map((item) {
      return item.id;
    }).toList();

    List<ScreenType> _getSelectedScreenTypes() {
      return list.where((item) => selectedScreenTypeIds.contains(item.id)).toList();
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text("Select your screen type"),
            ),
            contentPadding: EdgeInsets.only(top: 12.0),
            content: CustomSelectionGroup(
              options: options,
              initialSelectedValues: selectedScreenTypeIds,
              onChanged: (newSelectedIds) {
                print(newSelectedIds);
                selectedScreenTypeIds = List.from(newSelectedIds);
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  setState(() {
                    //previousValues= new Map.from(values);
                    selectedScreenTypes=_getSelectedScreenTypes();
                  });
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  _createRoom() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to create new room ?', style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  for (var screenType in selectedScreenTypes)
                    newRoom.screenTypeIds.add(screenType.id);
                  Navigator.of(context).pop();
                  if (newRoom.name != '' &&newRoom.screenTypeIds.length>0 &&newRoom.totalRows!=null
                  &&newRoom.totalSeatsPerRow!=null) {
                    if (await RoomController.instance.insertRoom(newRoom) ){
                      dialog.showSuccessMessage(
                          this.context, "Success", "Create new room successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Create new room failed.' + '\nPlease try again!').show();
                    return;
                  }
                  dialog.showErrorMessage(this.context,"Error", 'Some fields are invalid.' + '\nPlease try again!').show();
                },
              ),
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
