import 'package:cinex/controller/showtime_controller.dart';
import 'package:cinex/model/movie.dart';
import 'package:cinex/model/showtime.dart';
import 'package:cinex/utils/constant.dart';
import 'package:cinex/utils/func.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cinex/route/route_path.dart' as routes;
import 'package:cinex/dialog/dialog.dart' as dialog;
class MovieDetailView extends StatefulWidget {
  final Movie movie;
  MovieDetailView({Key key, @required this.movie}) : super(key: key);
  @override
  _MovieDetailViewState createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {


  Future<List<Showtime>> showtimes ;

  List<Showtime> showtimesList;
  List<Showtime> allShowtimes;
  DateTime selectedDate=DateTime.now();

  Map<Showtime,bool> values = {};
  Map<Showtime,bool> previousValues = {};

  bool selected  = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(showtimes == null)
      showtimes= ShowtimeController.instance.getAllShowtimesByMovieId(widget.movie.id);
  }

  _getSelectedShowtime(){
    Showtime selectedShowtime;
    for (var showtime in values.keys){
      if(values[showtime]==true){
        selectedShowtime = showtime;
        break;
      }
    }
    return selectedShowtime;
  }

  _filterShowtime(List<Showtime> list){
    for (var showtime in list){
      values[showtime] = previousValues[showtime]==null?false:previousValues[showtime];
    }
    previousValues=new Map.from(values);

    allShowtimes = list;
    showtimesList = ShowtimeController.instance.filterShowtimes(allShowtimes,selectedDate);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
            children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(image: new AssetImage("assets/background.jpg"), fit: BoxFit.cover,),
                ),
              ),
              _createWallpaper(),
              _renderView(showtimes),
            ]
        ),
      ),
      //backgroundColor: Colors.yellow,
    );
  }

  _renderView(Future<List<Showtime>> showtimes) {
    return FutureBuilder(
      future: showtimes,
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.done && snapshot.hasData){
          _filterShowtime(snapshot.data);
          return _createView(showtimesList);
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  _createWallpaper(){
    String url = default_url;
    if(widget.movie.wallpaper!="")
      url = widget.movie.wallpaper;

   return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Image.network(url,fit: BoxFit.cover,filterQuality: FilterQuality.medium,
        loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            padding: EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topCenter,
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

  _createView(List<Showtime> showtimes){
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
          ),
        ),
        Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(top: 5,left: 7,right: 7),
              padding: EdgeInsets.only(left: 3,right: 3),
              child: Column(
                children: <Widget>[
                  _createTitle(),
                  Container(
                    child: Card(
                      color: Color(0xff5837a6),
                      child: _createDatePickerTimeline(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 5,left: 7,right: 7),
                        padding: EdgeInsets.only(left: 3,right: 3),
                      //color: Colors.redAccent,
                      decoration: BoxDecoration(
                        color: Color(0xff5837a6),
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(formatDateFromString(selectedDate.toIso8601String()))),
                            Container(
                              constraints: BoxConstraints(minWidth:double.infinity ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10,
                                    //crossAxisAlignment: WrapCrossAlignment.center,
                                    children: _renderShowtimes(showtimes)
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  ),
                  _renderBookNowButton(),
                ],
              ),
            )
        ),
      ],
    );
  }

  _createTitle(){
    return Center(
        child: Text(
          widget.movie.title,
          style: TextStyle(fontSize: 30, fontFamily: 'Montserrat',fontWeight: FontWeight.bold,color: Colors.grey),
          textAlign: TextAlign.center,
        )
    );
  }

  _createDatePickerTimeline(){
    return DatePickerTimeline(
      selectedDate,
      daysCount: 7,
      onDateChange: (date) {
        // New date selected
        setState(() {
          selectedDate=date;
          showtimesList = ShowtimeController.instance.filterShowtimes(allShowtimes, date);
        });
      },
      selectionColor: Colors.blue[400],
    );
  }

  _renderShowtimes(List<Showtime> showtimes){
    List<Widget> list = new List();
    for(int i=0;i<showtimes.length;i++){
      list.add(Material(
        borderRadius: BorderRadius.circular(5),
        color: values[showtimes[i]]==true? Color(0xff7b73e0): Color(0xff5837a6),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 2,color: Colors.lightBlue)
          ),
          child: new InkWell(
            child: _renderShowtime(showtimes[i]),
            onTap: (){
              for(var restShowtime in showtimes)
                values[restShowtime]= false;
              setState(() {
                values[showtimes[i]] = !values[showtimes[i]];
                previousValues = new Map.from(values);
              });
            },
          ),
        ),
      ));
    }
    return list;
  }

  _renderBookNowButton(){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.lightBlue[400],
        child: Text("Book now"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: () async {
          Showtime showtime = _getSelectedShowtime();
          if(showtime != null) {
            await Navigator.of(context).pushNamed(
                routes.book_seats, arguments: showtime.id);
            showtimes = ShowtimeController.instance.getAllShowtimesByMovieId(widget.movie.id);
            previousValues = {};
            _filterShowtime(allShowtimes);
          }
          else
            dialog.showErrorMessage(this.context,"Error", "You don't select any showtime" + '\nPlease try again!').show();
        },
      ),
    );
  }

  _renderShowtime(Showtime showtime){
    return SizedBox(
      width: 92,
      height: 92,
      child: Column(
        children: <Widget>[
          SizedBox(height: 5,),
          Expanded(
            flex: 1,
            child: Text(formatTimeFromString(showtime.startAt),style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: _renderAvailableSeats(showtime),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(showtime.unbookSeats.toString() + " Available",style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontFamily: 'Dosis',
                fontWeight: FontWeight.w500))),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.circular(1),
              ),
              child: Text(showtime.screenType.name,style: TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                  fontFamily: 'Dosis',
                  fontWeight: FontWeight.w500)),
            ),
          )
        ],
      ),
    );
  }

  _renderAvailableSeats(Showtime showtime){
    List<bool> isFull = new List(3);
    double percentage = (showtime.room.totalSeats)/showtime.unbookSeats;
    if (percentage>=30)
      isFull[0] = true;
    if (percentage>60)
      isFull[1]= true;
    if (percentage>90)
      isFull[2]= true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: isFull.map((bool val){
        return Container(
          decoration: BoxDecoration(
              color: val == true? Colors.lightBlue :Color(0xff5837a6) ,
              borderRadius: BorderRadius.circular(1),
              border: Border.all(color: Colors.lightBlue)
          ),
          margin: EdgeInsets.only(left: 2,right: 2),
          child: SizedBox(
            width: 5,
            height: 10,
          ),
        );
      }).toList(),
    );
  }
}
