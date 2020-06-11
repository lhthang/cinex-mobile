
import 'package:cinex_management/View/Showtime/showtime_view.dart';
import 'package:cinex_management/Controller/UserController/user_controller.dart';
import 'package:cinex_management/Model/User/user.dart';
import 'package:cinex_management/View/Genre/genre_view.dart';
import 'package:cinex_management/View/Movie/movie_view.dart';
import 'package:cinex_management/View/Rate/rate_view.dart';
import 'package:cinex_management/View/Room/room_view.dart';
import 'package:cinex_management/View/ScreenType/screentype_view.dart';
import 'package:cinex_management/View/Ticket/ticket_view.dart';
import 'package:cinex_management/View/User/user_view.dart';
import 'package:cinex_management/View/report_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<User> user = UserController.instance.getUserDetail();
  int _currentIndex= 0;
  String screenName = "Home";
  List<Widget> _children =[
    Center(
      child: Image.asset('assets/cinex-logo.png'),
    ),
    ScreenTypeView(),
    RoomView(),
    GenreView(),
    RateView(),
    MovieView(),
    ShowtimeView(),
    TicketView(),
    UserView(),
    ReportView(),
  ];

  onTabTapped(int index,String screenName) {
    setState(() {
      _currentIndex = index;
      this.screenName=screenName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(screenName),centerTitle: true,),
      body:  SafeArea(
        child: Center(
          child: _children[_currentIndex],
        ),
        top: false,
      ),
              drawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text("cinema-admin"),
                      accountEmail: Text("lhthang.98@gmail.com"),
                      currentAccountPicture: CircleAvatar(
                        child: Image.asset('assets/icons/manager-avt.png'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.home
                      ),
                      title: Text("Home"),
                      onTap: (){
                        onTabTapped(0,"Home");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.tablet
                      ),
                      title: Text("Screen Type"),
                      onTap: (){
                        onTabTapped(1,"Screen Type");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.store
                      ),
                      title: Text("Room"),
                      onTap: (){
                        onTabTapped(2,"Room");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.view_comfy
                      ),
                      title: Text("Genre"),
                      onTap: (){
                        onTabTapped(3,"Genre");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.sentiment_satisfied
                      ),
                      title: Text("Rate"),
                      onTap: (){
                        onTabTapped(4,"Rate");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.movie
                      ),
                      title: Text("Movie"),
                      onTap: (){
                        onTabTapped(5,"Movie");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.slideshow
                      ),
                      title: Text("Showtime"),
                      onTap: (){
                        onTabTapped(6,"Showtime");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.tab
                      ),
                      title: Text("Ticket"),
                      onTap: (){
                        onTabTapped(7,"Ticket");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.people
                      ),
                      title: Text("User"),
                      onTap: (){
                        onTabTapped(8,"User");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.show_chart
                      ),
                      title: Text("Dashboard"),
                      onTap: (){
                        onTabTapped(9,"Dashboard");
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                          Icons.exit_to_app
                      ),
                      title: Text("Log out"),
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
    );
  }
}
