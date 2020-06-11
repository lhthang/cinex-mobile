import 'package:cinex_scan/route/route_path.dart' as routes;
import 'package:cinex_scan/dialog/dialog.dart' as dialog;
import 'package:cinex_scan/controller/login_controller.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginView> {
  String username= "";
  String password ="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            SizedBox(height: 50,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _renderLogo(),
                SizedBox(height: 10.0),
                _renderUsername(),
                SizedBox(height: 10.0),
                _renderPassword(),
                SizedBox(height: 10.0),
                _renderLoginButton(context),
              ],
            )
          ],
        )
    );
  }

  onChangeUsername(String username)
  {
    setState(() {
      this.username=username;
    });
  }

  onChangePassword(String password)
  {
    setState(() {
      this.password=password;
    });
  }

  _renderLogo() {
    return Image(
      image: AssetImage("assets/cinex-logo.png",),
    );
  }

  _renderUsername() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        onChanged: (text) {
          onChangeUsername(text);
        },
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Username',
          contentPadding: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );
  }

  _renderPassword() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        onChanged: (text) {
          onChangePassword(text);
        },
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );
  }

  _renderLoginButton(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 20),
        Expanded(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {
              //Navigator.of(context).pushNamed(routes.home);
              String isAccess = await LoginController.instance.login(username, password);
              if (isAccess=="access") Navigator.of(context).pushNamed(routes.home);
              else {
                if (isAccess == "refuse")
                  dialog.showErrorMessage(
                      context, "Error", "You don't have permission to access this application").show();
                else
                  dialog.showErrorMessage(
                      context, "Error", "Username or password is wrong!").show();
              }

            },
            padding: EdgeInsets.all(12),
            color: Color.fromRGBO(34, 64, 221, 80),
            child: Text('Log In',
                style: TextStyle(color: Colors.white, fontSize: 18.0)),
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
