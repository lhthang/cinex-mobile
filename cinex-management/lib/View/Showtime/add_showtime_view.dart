import 'package:cinex_management/Controller/MovieController/movie_controller.dart';
import 'package:cinex_management/Controller/RoomController/room_controller.dart';
import 'package:cinex_management/Controller/ScreenTypeController/screentype_controller.dart';
import 'package:cinex_management/Controller/ShowtimeController/showtime_controller.dart';
import 'package:cinex_management/Model/Movie/movie.dart';
import 'package:cinex_management/Model/Room/room.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/Model/Showtime/showtime_req.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;

class AddShowtimeView extends StatefulWidget {
  @override
  _AddShowtimeViewState createState() => _AddShowtimeViewState();
}

class _AddShowtimeViewState extends State<AddShowtimeView> {
  var future;
  Future<List<ScreenType>> screenTypesList = ScreenTypeController.instance.getAllScreenTypes();
  Future<List<Room>> roomsList = RoomController.instance.getAllRooms();

  Future<List<Movie>> nowOnMovies = MovieController.instance.getAllMoviesNowOn();
  Future<List<Movie>> comingMovies = MovieController.instance.getAllMoviesComing(7);

  bool isSupport = false;
  Movie selectedMovie;
  Room selectedRoom;
  ScreenType selectedScreenType;
  ShowtimeRequest showtimeReq = new ShowtimeRequest(movieId: '',roomId: '',price: 0,screenTypeId: '');
  DateTime selectedDate = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: timeOfDay,
    );
    if (picked != null && picked != timeOfDay)
      setState(() {
        timeOfDay = picked;
      });
  }
  
  TextEditingController _priceController = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _priceController.text = '0';
    future = Future.wait([screenTypesList,roomsList,nowOnMovies,comingMovies]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Showtime"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _buildView(),
      ),
    );
  }


  _buildView (){
    return FutureBuilder(
        future: future,
        builder: (context,snapshot){
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<ScreenType> screenTypes = snapshot.data[0];
            List<Room> rooms = snapshot.data[1];
            List<Movie> movies = snapshot.data[2];
            for(var movie in snapshot.data[3])
              movies.add(movie);
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                _createSelectMovie(movies),
                _createSelectRoom(rooms),
                _createSelectScreenType(screenTypes),
                _createSelectStartOnButton(),
                _createSelectTimeAtButton(),
                _createPrice(),
                _createViewCheckScreenType(),
                _createButton(),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  _createSelectRoom(List<Room> roomsList){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.only(left:3.0,right: 3.0,top: 5.0,bottom: 5.0),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              border: Border.all(color: Colors.greenAccent,width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(child: Text("Room",style: contentStyle,)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 8,
          child:SearchableDropdown.single(
            items: getItems(roomsList),
            value: selectedRoom,
            hint: "Select one",
            isCaseSensitiveSearch: false,
            onChanged: (value) {
              setState(() {
                selectedRoom=value;
              });
              _checkSupport();
            },
            isExpanded: true,
          ),
        )
      ],
    );
  }

  List<DropdownMenuItem> getItems(List<dynamic> list){
    List<DropdownMenuItem<dynamic>> returnList = new List();
    for (var item in list){
      returnList.add(new DropdownMenuItem(
        child:Text(item.name),
        value: item,));
    }
    return returnList;
  }

  _createSelectMovie(List<Movie> movieList){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.only(left:3.0,right: 3.0,top: 5.0,bottom: 5.0),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              border: Border.all(color: Colors.greenAccent,width: 1),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(child: Text("Movie",style: contentStyle,),),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 8,
          child:SearchableDropdown.single(
            items: getMovieItems(movieList),
            value: selectedMovie,
            hint: "Select one",
            isCaseSensitiveSearch: false,
            onChanged: (value) {
              setState(() {
                selectedMovie=value;
              });
              _checkSupport();
            },
            isExpanded: true,
          ),
        )
      ],
    );
  }

  List<DropdownMenuItem> getMovieItems(List<Movie> list){
    List<DropdownMenuItem<Movie>> returnList = new List();
    for (var item in list){
      returnList.add(new DropdownMenuItem(
        child:Text(item.title),
        value: item,));
    }
    return returnList;
  }

  _createSelectScreenType(List<ScreenType> screenTypesList){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.only(left:3.0,right: 3.0,top: 5.0,bottom: 5.0),
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              border: Border.all(color: Colors.greenAccent,width: 1),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(child: Text("Screen type",style: contentStyle,)),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 8,
          child:SearchableDropdown.single(
            items: getItems(screenTypesList),
            value: selectedScreenType,
            hint: "Select one",
            isCaseSensitiveSearch: false,
            onChanged: (value) {
              setState(() {
                selectedScreenType=value;
              });
              _checkSupport();
            },
            isExpanded: true,
          ),
        )
      ],
    );
  }

  _createSelectStartOnButton() {
    return Container(
      //margin: const EdgeInsets.only(top: 15.0),
      padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              height: 30,
              child: Material(
                elevation: 1.25,
                borderRadius:  BorderRadius.circular(3),
                color: Colors.greenAccent,
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
                      child: Text("Start on",style: contentStyle,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 8,
            child: _buildDate(selectedDate),
          )
        ],
      ),
    );
  }

  _createSelectTimeAtButton() {
    return Container(
      //margin: const EdgeInsets.only(top: 15.0),
      padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              height: 30,
              child: Material(
                elevation: 1.25,
                borderRadius:  BorderRadius.circular(3),
                color: Colors.greenAccent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Icon(
                          Icons.timer
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text("Start at",style: contentStyle,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 8,
            child: _buildTime(timeOfDay),
          )
        ],
      ),
    );
  }

  _buildDate(DateTime dateTime){
    return Material(
      child: InkWell(
        child: Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            border: Border.all(width:2,color: Colors.greenAccent[400]),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(formatDateFromString(dateTime.toIso8601String())),
        ),
        onTap: (){
          _selectDate(context);
        },
      ),
    );
  }

  _buildTime(TimeOfDay dateTime){
    String time = dateTime.hour.toString()+":"+dateTime.minute.toString();
    return Material(
      child: InkWell(
        child: Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            border: Border.all(width:2,color: Colors.greenAccent[400]),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(time),
        ),
        onTap: (){
          _selectTime(context);
        },
      ),
    );
  }

  _createViewCheckScreenType(){
    if(selectedMovie!=null&&selectedRoom!=null&&selectedScreenType!=null){
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent[400]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    selectedMovie.poster,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Icon(Icons.movie,size: 15,),
                        ),
                        Expanded(
                          flex: 3,
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: selectedMovie.screenTypes.map((screenType){
                              return _buildScreenType(screenType);
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                    Divider(color: Colors.black,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Icon(Icons.store,size: 15,),
                        ),
                        Expanded(
                          flex: 3,
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: selectedRoom.screenTypes.map((screenType){
                              return _buildScreenType(screenType);
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                    Divider(color: Colors.black,),
                    _checkScreenTypeIsSupport(),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildScreenType(ScreenType screenType){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(screenType.name),
    );
  }

  _checkSupport(){
    bool room = false;
    bool movie = false;
    if (selectedScreenType == null || selectedMovie == null || selectedRoom == null){
      setState(() {
        isSupport=false;
      });
      return;
    }
    for(var screenType in selectedRoom.screenTypes){
      if(screenType.id==selectedScreenType.id) {
        room = true;
        break;
      }
    }
    for(var screenType in selectedMovie.screenTypes){
      if(screenType.id==selectedScreenType.id) {
        movie = true;
        break;
      }
    }
    if (movie == true&& room==true){
      setState(() {
        isSupport=true;
      });
      return;
    } else {
      setState(() {
        isSupport=false;
      });
    }
    return;
  }

  _checkScreenTypeIsSupport(){
    Color check =Colors.red;
    Icon iconCheck = Icon(Icons.close,size: 30);
    if (isSupport==true){
      check=Colors.green;
      iconCheck=Icon(Icons.check,size: 30,);
    }
    return Center(
      child: Container(
        //padding: EdgeInsets.all(10),
        width: 40,
        height: 40,
        child: iconCheck,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: check),
      ),
    );
  }

  _createPrice(){
    return Container(
      padding: EdgeInsets.only(top: 5,bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.only(left:3.0,right: 3.0,top: 5.0,bottom: 5.0),
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                border: Border.all(color: Colors.greenAccent,width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(child: Text("Price",style: contentStyle,)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 8,
            child:Container(
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
                decoration: new InputDecoration(
                    labelStyle: TextStyle(
                    color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
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
            'Create Showtime',
            style: TextStyle(
                color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _createShowtime();
          },
        ),
      ),
    );
  }

  _createShowtime() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to create new showtime ?', style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  DateTime startAt = new DateTime(selectedDate.year,selectedDate.month,selectedDate.day,timeOfDay.hour,timeOfDay.minute);
                  /* Pop screens */
                  double price = double.tryParse(_priceController.text);
                  Navigator.of(context).pop();
                  if(isSupport==false)
                    dialog.showErrorMessage(this.context,"Error", 'Screen type of showtime is not suitable for movie and room.' + '\nPlease try again!').show();
                  if (selectedMovie !=null &&selectedScreenType!=null
                      &&startAt!=null&& selectedRoom!=null&& (price>0)) {
                    showtimeReq = new ShowtimeRequest(movieId: selectedMovie.id,screenTypeId: selectedScreenType.id,
                        startAt: startAt.toIso8601String(),roomId: selectedRoom.id,price:price );
                    if (await ShowtimeController.instance.insertShowtime(showtimeReq) ){
                      dialog.showSuccessMessage(
                          this.context, "Success", "Create new showtime successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Create new showtime failed.' + '\nPlease try again!').show();
                    return;
                  } else {
                    dialog.showErrorMessage(this.context, "Error",
                        'Some fields are invalid.' + '\nPlease try again!')
                        .show();
                  }
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
