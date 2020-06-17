import 'package:flutter/material.dart';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          child: _renderView(),
        ),
      )
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
        Container(
          margin: EdgeInsets.only(left: 20,right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _renderTitleScreen(),
              _renderLogo(),
              SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("465 Hong Bang Street, Ward 14, District 5, Ho Chi Minh city",style: new TextStyle( fontFamily: 'Dosis',
                    fontSize: 15, color: Colors.white)),
                  SizedBox(height: 20,),
                  Text("Hotline: 08-3838-6666",style: new TextStyle( fontFamily: 'Dosis',
                    fontSize: 15, color: Colors.white)),
                  SizedBox(height: 20,),
                  Text("Manager: Thang Le",style: new TextStyle( fontFamily: 'Dosis',
                    fontSize: 15, color: Colors.white)),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  _renderTitleScreen() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 30),
      child: Text(
        "About",
        style: new TextStyle( fontFamily: 'Dosis',
            fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  _renderLogo() {
    return Image(
      color: Colors.white,
      image: AssetImage("assets/cinex-logo.png"),
    );
  }
}