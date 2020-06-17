import 'package:cinex_management/Controller//MovieController/movie_controller.dart';
import 'package:cinex_management/Controller/ShowtimeController/showtime_controller.dart';
import 'package:cinex_management/Model/Movie/movie.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/Model/Showtime/showtime.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cinex_management/route/route_path.dart' as routes;
import 'package:cinex_management/dialog/dialog.dart' as dialog;

class ShowtimeView extends StatefulWidget {
  @override
  _ShowtimeViewState createState() => _ShowtimeViewState();
}

class _ShowtimeViewState extends State<ShowtimeView> {

  String searchKey="";
  Future<List<Movie>> nowOnMovies = MovieController.instance.getAllMoviesNowOn();
  Future<List<Movie>> comingMovies = MovieController.instance.getAllMoviesComing(7);
  Future<List<Showtime>> showtimes = ShowtimeController.instance.getAllShowtimes();

  filterShowtime(Movie movie){
    setState(() {
      selectedMovie=movie;
    });
    showtimes = ShowtimeController.instance.filterShowtimes(selectedMovie);
  }
  Movie selectedMovie;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildSearchBar(),
          //SizedBox(height: 10,),
          Expanded(
            child: Container(
              child:_renderDropdownMenu(nowOnMovies,comingMovies,showtimes),
            ),
          )
          //Expanded(child: _buildData(movieList)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
              color: Color.fromARGB(180, 38, 54, 70).withOpacity(0.2))),
      margin: EdgeInsets.only(top: 10.0, bottom: 2.0, left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: new TextField(
              onChanged: (text) {
                setState(() {
                  searchKey = text;
                  showtimes =
                      ShowtimeController.instance.searchShowtimes(showtimes,searchKey,selectedMovie);
                });
              },
              onSubmitted: null,
              decoration: InputDecoration.collapsed(
                  hintText: "Enter room for search..."),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          RaisedButton(
            color: Colors.greenAccent,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Icon(
                  Icons.add,
                  color: Color.fromARGB(180, 38, 54, 70),
                  size: 19.0,
                ),
                new Text(
                  'Add',
                  style: TextStyle(
                      color: Color.fromARGB(180, 38, 54, 70),
                      fontFamily: 'Dosis',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            onPressed: () async {
              await Navigator.of(context).pushNamed(routes.add_showtime);
              setState(() {
                selectedMovie=null;
                showtimes = ShowtimeController.instance.getAllShowtimes();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _renderDropdownMenu(Future<List<Movie>> movies,Future<List<Movie>> comingMovies, Future<List<Showtime>> showtimes){
    return FutureBuilder(
      future: Future.wait([movies,comingMovies,showtimes]),
      builder: (context,snapshot){
        if (snapshot.hasData &&snapshot.connectionState==ConnectionState.done){
          List<Movie> moviesList = snapshot.data[0];
          for(var movie in snapshot.data[1])
            moviesList.add(movie);
          List<Showtime> showtimesList = snapshot.data[2];
          return Column(
            children: <Widget>[
              Container(
                //margin: EdgeInsets.only(left: 7.0, right: 7.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child:SearchableDropdown.single(
                  items: getItems(moviesList),
                  value: selectedMovie,
                  hint: "All",
                  isCaseSensitiveSearch: false,
                  onChanged: (value) {
                    filterShowtime(value);
                  },
                  isExpanded: true,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Divider(color: Colors.black,height: 1,)),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: showtimesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _renderShowtime(showtimesList[index]);
                  },
                ),
              )
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  List<DropdownMenuItem> getItems(List<Movie> movies){
    List<DropdownMenuItem<Movie>> list = new List();
    for (var movie in movies){
      list.add(new DropdownMenuItem(
              child:Text(movie.title),
              value: movie,));
    }
    return list;
  }

  _renderShowtime( Showtime showtime){
    return Container(
      //padding: EdgeInsets.only(left: 5,right: 5),
      height: 150,
      child: Card(
        elevation: 1.25,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    showtime.poster,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              flex: 5,
              child: Container(
                //padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      //padding: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(showtime.room.name,style: mainTitle,),
                          _buildStatus(showtime.status),
                        ],
                      )
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(showtime.movie,style: subTitle,),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.play_arrow,
                              size: 15,
                            ),
                            Text(formatDateFromString(showtime.startAt),
                                style: TextStyle(fontFamily: 'Dosis', fontSize: 13.0, fontWeight: FontWeight.w500)),
                          ],
                        )
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              size: 15,
                            ),
                            Text(formatTimeFromString(showtime.startAt)+" ~ "+
                                formatTimeFromString(showtime.endAt),
                                style: TextStyle(color: Colors.greenAccent[400], fontFamily: 'Dosis', fontSize: 13.0, fontWeight: FontWeight.w500)),
                          ],
                        )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: _buildScreenType(showtime.screenType),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async{
                        await Navigator.pushNamed(context,routes.edit_showtime,arguments: showtime);
                        setState(() {
                          selectedMovie=null;
                          showtimes = ShowtimeController.instance.getAllShowtimes();
                        });
                      },
                      child: new Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                        size: 24.0,
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        _deleteShowtime(showtime);
                      },
                      child: new Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 24.0,
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildScreenType(ScreenType screenType){
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

  _buildStatus(String status){
    Color theme = Colors.greenAccent[400];
    if (status == "CLOSE")
      theme = Colors.redAccent[400];
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: theme),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(status),
    );
  }

  _deleteShowtime(Showtime showtime){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm', style: titleStyle),
            content: new Text('Do you want to delete this showtime ?',
                style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Ok', style: okButtonStyle),
                  onPressed: () async {
                    /* Pop screens */
                    Navigator.of(context).pop();
                    if (await ShowtimeController.instance.deleteShowtime(showtime.id)) {
                      setState(() {
                        selectedMovie=null;
                        showtimes = ShowtimeController.instance.getAllShowtimes();
                      });
                      dialog.showSuccessMessage(
                          this.context, "Success", "Deleted successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Deleted failed.' + '\nPlease try again!').show();
                  }),
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
