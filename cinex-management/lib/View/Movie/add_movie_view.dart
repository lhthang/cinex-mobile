import 'package:cinex_management/Controller/MovieController/movie_controller.dart';
import 'package:cinex_management/Controller/ScreenTypeController/screentype_controller.dart';
import 'package:cinex_management/Model/Movie/movie_req.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../custom_selection_group.dart';

class AddMovieView extends StatefulWidget {
  @override
  _AddMovieViewState createState() => _AddMovieViewState();
}

class _AddMovieViewState extends State<AddMovieView> {
  final format = DateFormat("yyyy-MM-dd");
  MovieRequest movieRequest = new MovieRequest(screenTypeIds: [],wallpaper: '',imdbID: '',endAt: '');

  Future<List<ScreenType>> screenTypesList = ScreenTypeController.instance.getAllScreenTypes();


  List<ScreenType> selectedScreenTypes = new List();

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        movieRequest.endAt=selectedDate.toIso8601String();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Movie"),
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
                _createIMDB(),
                _createEndAtButton(),
                _createButtonSelectScreenType(snapshot.data),
                _createWallpaper(),
                _createWallpaperImage(),
                _createButton(),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  _createIMDB() {
    return TextField(
      style: TextStyle(
          color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(labelText: 'IMDB ID*:', labelStyle: TextStyle(
          color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          movieRequest.imdbID=text;
        });
      },
    );
  }

  _createWallpaper() {
    return TextField(
      style: TextStyle(
          color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(hintText:"http:/..",labelText: 'Wallpaper:', labelStyle: TextStyle(
          color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          movieRequest.wallpaper=text;
        });
      },
    );
  }

  _createWallpaperImage() {
    return Container(
      padding: EdgeInsets.only(top:15,left: 20,right: 20),
      child: Image.network(movieRequest.wallpaper,fit: BoxFit.cover,
        loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            padding: EdgeInsets.only(top: 10),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ?
                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  _createEndAtButton() {
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
                            Icons.calendar_today
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("End at",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500) ,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    _selectDate(context);
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
            child: _buildDate(selectedDate),
          )
        ],
      ),
    );
  }

  _createButtonSelectScreenType(List<ScreenType> list){
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
                    _showScreenTypesDialog(list);
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
              children:  _buildScreenTypesOfMovie(selectedScreenTypes),
            ),
          )
        ],
      ),
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

  _createButton(){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: double.infinity,
        child: new RaisedButton(
          color: Colors.greenAccent,
          child: new Text(
            'Create Movie',
            style: TextStyle(
                color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _createMovie();
          },
        ),
      ),
    );
  }

  _buildScreenTypesOfMovie(List<ScreenType> screenTypesList){
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

  _buildDate(DateTime dateTime){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border: Border.all(width:2,color: Colors.redAccent),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(formatDateFromString(selectedDate.toIso8601String())),
    );
  }

  _createMovie() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to create new movie ?', style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  for (var screenType in selectedScreenTypes)
                    movieRequest.screenTypeIds.add(screenType.id);
                  Navigator.of(context).pop();
                  if (movieRequest.imdbID != '' &&movieRequest.screenTypeIds.length>0
                      &&movieRequest.endAt!='') {
                    if (await MovieController.instance.insertMovie(movieRequest) ){
                      dialog.showSuccessMessage(
                          this.context, "Success", "Create new movie successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Create new movie failed.' + '\nPlease try again!').show();
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
