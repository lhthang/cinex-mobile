import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cinex/controller/movie_controller.dart';
import 'package:cinex/controller/user_controller.dart';
import 'package:cinex/model/movie.dart';
import 'package:cinex/model/user.dart';
import 'package:cinex/view/movie_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:cinex/route/route_path.dart' as routes;

class MovieView extends StatefulWidget {
  @override
  _MovieViewState createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Future<List<Movie>> movieList = MovieController.instance.getAllMoviesNowOn();
  int currentIndex = 0;
  Future<User> user = UserController.instance.getUserDetail();

  @override
  void initState() {
    super.initState();
    this._tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  setMovieList(int index) {
    if (index == 0) {
      setState(() {
        movieList = MovieController.instance.getAllMoviesNowOn();
      });
    } else {
      setState(() {
        movieList = MovieController.instance.getAllMoviesComing(10);
      });
    }
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _renderView(),
    );
  }

  _renderView(){
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:40,right: 10),
              child: _renderUser(),
            ),
            Container(
              //padding: EdgeInsets.only(top:10,right: 10),
              child: _renderTitleScreen(),
            ),
            Container(
              padding: EdgeInsets.only(top:10,right: 10),
              child: _renderTabBar(),
            ),
            Expanded(
              flex: 5,
              child: _renderMovieList(movieList),
            ),
          ],
        ),
      ],
    );
  }

  _renderMovieList(Future<List<Movie>> movieList){
    return FutureBuilder(
      future: movieList,
      builder: (BuildContext context,
          AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.only(top: 5),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _renderMovie(snapshot.data[index]);
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  _renderTitleScreen() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Movie List",
              style: new TextStyle( fontFamily: 'Dosis',
                  fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        )
      ],
    );
  }

  _renderTabBar() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: new BubbleTabIndicator(
          indicatorHeight: 25.0,
          indicatorColor: Color(0xff5837a6),
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
        ),
        onTap: (index) {
          setMovieList(index);
        },
        tabs: [
          Tab(
            text: "Now on",
          ),
          Tab(
            text: "Coming soon",
          ),
        ],
      ),
    );
  }

  _renderMovie(Movie movie) {
    String genres = "";
    for (int i = 0; i < movie.genres.length; i++) {
      if (i == movie.genres.length - 1)
        genres = genres + movie.genres[i].name;
      else
        genres = genres + movie.genres[i].name + " / ";
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 28,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 200,
                    child: Container(
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Material(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff5837a6),
                          elevation: 1.5,
                          child: InkWell(
                            child: Container(
                              height: 165.0,
                            ),
                            onTap: () async {
                              if (currentIndex == 0) {
                                await Navigator.of(context).pushNamed(routes.movie_detail,
                                    arguments: movie);
                                setMovieList(currentIndex);
                              } else
                                print("No");
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  )),
                  Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          //color: Colors.greenAccent,
                          height: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                              Expanded(
                                flex: 10,
                                child:ClipRRect(
                                    child: Image.network(
                                      movie.poster,
                                      fit: BoxFit.fill,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)))
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                flex: 18,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        movie.title,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        genres,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        movie.runtime.toString() + " min",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.lightBlue),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        padding: EdgeInsets.all(2),
                                        child: Text(
                                          movie.rate.name ,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ],
    );
  }

  _renderUser() {
    return FutureBuilder(
      future: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(children: <Widget>[
              Icon(
                Icons.attach_money,
                size: 20,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                snapshot.data.cPoint.toString(),
                style: new TextStyle(fontSize: 15, color: Colors.white),
              ),
            ]),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
