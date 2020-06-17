import 'package:cinex_management/Controller/RoomController/room_controller.dart';
import 'package:cinex_management/Controller/ScreenTypeController/screentype_controller.dart';
import 'package:cinex_management/View/custom_selection_group.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:cinex_management/Model/Room/room.dart';
import 'package:cinex_management/Model/Room/room_req.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditRoomView extends StatefulWidget {
  final Room room;

  EditRoomView({Key key,@required this.room}) : super (key: key);
  @override
  _EditRoomViewState createState() => _EditRoomViewState();
}

class _EditRoomViewState extends State<EditRoomView> {

  TextEditingController _idController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _totalRows = new TextEditingController();
  TextEditingController _totalSeatsPerRow = new TextEditingController();


  Future<List<ScreenType>> screenTypesList = ScreenTypeController.instance.getAllScreenTypes();


  List<ScreenType> selectedScreenTypes = new List();

  RoomRequest updateRoomRequest = new RoomRequest(name: '',screenTypeIds: [] );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idController.text=widget.room.id;
    _nameController.text=widget.room.name;
    _totalSeatsPerRow.text=widget.room.totalSeatsPerRow.toString();
    _totalRows.text=widget.room.totalRows.toString();
    selectedScreenTypes=widget.room.screenTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Room"),
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
                _buildID(),
                _buildName(),
                _buildSeat(),
                _createButtonSelectScreenType(snapshot),
                _createButton(),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
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

  _buildName() {
    return new TextField(
      controller: _nameController,
      style: itemStyle,
      decoration: new InputDecoration(labelText: 'Name:', labelStyle: itemStyle2),
    );
  }

  _buildSeat(){
    return Container(
      //margin: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _totalRows,
              style: itemStyle,
              decoration: new InputDecoration(labelText: 'Total rows:', labelStyle: itemStyle2),
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
              controller: _totalSeatsPerRow,
              style: itemStyle,
              decoration: new InputDecoration(labelText: 'Total seats per row:', labelStyle: itemStyle2),
            ),
          )
        ],
      ),
    );
  }

  _createButtonSelectScreenType(AsyncSnapshot snapshot){
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
//                    for (var screenType in snapshot.data){
//                      values[screenType] = previousValues[screenType] ==null? false:previousValues[screenType];
//                      for(var roomScreenType in widget.room.screenTypes){
//                        if (roomScreenType.id == screenType.id.toString() )
//                          values[screenType] = true;
//                        else
//                          continue;
//                      }
//                    }
//                    previousValues=new Map.from(values);
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

  _createButton(){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: double.infinity,
        child: new RaisedButton(
          color: Colors.greenAccent,
          child: new Text(
            'Save Change',
            style: TextStyle(
                color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _updateRoom();
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
//                    previousValues= new Map.from(values);
                    selectedScreenTypes=_getSelectedScreenTypes();
                  });
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  _updateRoom() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to update this room ?', style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  Navigator.of(context).pop();
                  updateRoomRequest=new RoomRequest(name: _nameController.text,screenTypeIds: [],
                      totalRows: num.tryParse(_totalRows.text),totalSeatsPerRow: num.tryParse(_totalSeatsPerRow.text));
                  for (var screenType in selectedScreenTypes)
                    updateRoomRequest.screenTypeIds.add(screenType.id);
                  if (updateRoomRequest.name != '' &&updateRoomRequest.screenTypeIds.length>0 &&updateRoomRequest.totalRows!=null
                      &&updateRoomRequest.totalSeatsPerRow!=null) {
                    if (await RoomController.instance.updateRoom(widget.room.id,updateRoomRequest) ){
                      dialog.showSuccessMessage(
                          this.context, "Success", "Updated successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Updated failed.' + '\nPlease try again!').show();
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
