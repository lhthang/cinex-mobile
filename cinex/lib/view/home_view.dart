
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cinex/view/account_view.dart';
import 'package:cinex/view/history_view.dart';
import 'package:cinex/view/movie_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex= 0;
  List<Widget> _children =[
    MovieView(),
    AccountView(),
    HistoryView(),
  ];

  onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body:  SafeArea(
              child: _children[_currentIndex],
              top: false,
            ),
              bottomNavigationBar: BubbleBottomBar(
                backgroundColor: Color(0xff1a2678),
                opacity: .2,
                currentIndex: _currentIndex,
                onTap: onTabTapped,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                elevation: 16,
                //fabLocation: BubbleBottomBarFabLocation.end, //new
                hasNotch: true, //new
                hasInk: true, //new, gives a cute ink effect
                inkColor: Colors.black12,
                  //selectedLabelStyle: TextStyle( fontWeight: FontWeight.w500 ),
                //unselectedLabelStyle: TextStyle( fontWeight: FontWeight.w500 ),
                items: [
                  BubbleBottomBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset('assets/icons/home_active.png', height: 25),
                    icon: Image.asset('assets/icons/home.png', height: 20),
                    title: Text('Home',style: new TextStyle(fontSize: 15),),
                  ),
                  BubbleBottomBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset('assets/icons/account_active.png', height: 25),
                    icon: Image.asset('assets/icons/account.png', height: 20),
                    title: Text('Profile',style: new TextStyle(fontSize: 15),),
                  ),
                  BubbleBottomBarItem(
                    backgroundColor: Colors.white,
                    activeIcon: Image.asset('assets/icons/active_history.png', height: 25),
                    icon: Image.asset('assets/icons/history.png', height: 20),
                    title: Text('Tickets History',style: new TextStyle(fontSize: 15),),
                  ),
                ],
              ),
    );
  }
}
