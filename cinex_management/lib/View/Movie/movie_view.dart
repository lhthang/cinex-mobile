import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cinex_management/Controller/MovieController/movie_controller.dart';
import 'package:cinex_management/Model/Movie/movie.dart';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/route/route_path.dart' as routes;
import 'package:cinex_management/dialog/dialog.dart' as dialog;


class MovieView extends StatefulWidget {
  @override
  _MovieViewState createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> with SingleTickerProviderStateMixin {

  String searchKey = "";
  Future<List<Movie>> movieList = MovieController.instance.getAllMovies();

  TabController _tabController;

  int currentIndex=0;

  setTab(int index){
    setState(() {
      currentIndex=index;
      switch(index){
        case 0:
          movieList=MovieController.instance.getAllMovies();
          break;
        case 1:
          movieList=MovieController.instance.getAllMoviesNowOn();
          break;
        case 2:
          movieList=MovieController.instance.getAllMoviesComing(70);
          break;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildSearchBar(),
          //SizedBox(height: 10,),
          _renderTabBar(),
          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child: Divider(color: Colors.black,height: 1,)),
          Expanded(child: _buildData(movieList)),
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
                  movieList =
                      MovieController.instance.searchMovie(searchKey);
                });
              },
              onSubmitted: null,
              decoration: InputDecoration.collapsed(
                  hintText: "Enter name for search..."),
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
              await Navigator.of(context).pushNamed(routes.add_movie);
              setTab(currentIndex);
            },
          ),
        ],
      ),
    );
  }

  Widget _renderTabBar() {
    return Container(
      //padding: EdgeInsets.only(left: 5, right: 5),
      margin:EdgeInsets.only(left: 7, right: 7) ,
      child: TabBar(
        labelColor: Colors.black,
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: new BubbleTabIndicator(
          indicatorHeight: 25.0,
          indicatorColor: Colors.lightBlueAccent[400],
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        onTap: (index) {
          setTab(index);
        },
        tabs: [
          Tab(
            text: "Get all",
          ),
          Tab(
            text: "Now on",
          ),
          Tab(
            text: "Coming",
          ),
        ],
      ),
    );
  }

  Widget _buildData(Future<List<Movie>> moviesList) {
    return FutureBuilder(
      future: moviesList,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            padding: EdgeInsets.only(left: 5, right: 5),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _renderMovie(snapshot.data[index]);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _renderMovie( Movie movie){
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
                    movie.poster,
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
                      child: Text(movie.title,style: mainTitle,),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.play_arrow,
                              size: 15,
                            ),
                            Text(formatDateFromString(movie.released),
                                style: TextStyle(color: Colors.greenAccent[400], fontFamily: 'Dosis', fontSize: 13.0, fontWeight: FontWeight.w500)),
                          ],
                        )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.stop,
                            size: 15,
                          ),
                          Text(formatDateFromString(movie.endAt),
                              style: TextStyle(color: Colors.redAccent[400], fontFamily: 'Dosis', fontSize: 13.0, fontWeight: FontWeight.w500)),
                        ],
                      )
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: _buildScreenTypesOfMovie(movie),
                      ),
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
                        await Navigator.pushNamed(context,routes.edit_movie,arguments: movie);
                        setTab(currentIndex);
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
                        _deleteMovie(movie);
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

  _buildScreenTypesOfMovie(Movie movie){
    List<Widget> list = new List();
    if (movie.screenTypes.length>3){
      for(int i=0;i<3;i++){
        list.add(_buildScreenType(movie.screenTypes[i]));
      }
      list.add(_buildScreenType(new ScreenType(name: "...")));
      return list;
    }
    for (var screenType in movie.screenTypes){
      list.add(_buildScreenType(screenType));
    }
    return list;
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

  _deleteMovie(Movie movie){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm', style: titleStyle),
            content: new Text('Do you want to delete this movie: ' + movie.title + '?',
                style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Ok', style: okButtonStyle),
                  onPressed: () async {
                    /* Pop screens */
                    Navigator.of(context).pop();
                    if (await MovieController.instance.deleteMovie(movie.id)) {
                      setTab(currentIndex);
                      dialog.showSuccessMessage(
                          this.context, "Success", "Deleted "+ movie.title+ " successfully!").show();
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
