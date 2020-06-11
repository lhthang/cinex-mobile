import 'package:cinex/route/route_path.dart' as routes;
import 'package:cinex/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:cinex/dialog/dialog.dart' as dialog;

class LoginView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginView> {
  String username = "";
  String password = "";
  String email="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
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
                _renderButton(context,"Log In",Color(0xff1BE45E)),
                SizedBox(height: 10.0),
                _renderButton(context,"Don't have account? Sign up",Color.fromARGB(221, 191, 34, 80)),
                SizedBox(height: 10.0),
                _renderButton(context,"Forgot password",Color.fromRGBO(34, 64, 221, 80)),
              ],
            )
          ],
        ));
  }

  _renderLogo() {
    return Image(
      image: AssetImage("assets/cinex-logo.png"),
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

  _renderButton(BuildContext context, String text, Color color) {
    return Row(
      children: <Widget>[
        SizedBox(width: 20),
        Expanded(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () {
              switch(text){
                case "Don't have account? Sign up":
                  Navigator.of(context).pushNamed(routes.sign_up);
                  break;
                case "Log In":
                  Future<bool> isLogin = UserController.instance.login(username, password);
                  isLogin.then((value) {
                    if (value)
                      Navigator.of(context).pushNamed(routes.home);
                    else {
                      dialog.showErrorMessage(
                          context, "Error", "Username or password is wrong").show();
                    }
                  });
                  break;
                case "Forgot password":
                  _renderResetPasswordDialog();
                  break;
                default:
                  break;
              }
            },
            padding: EdgeInsets.all(12),
            color: color,
            child: Text(text,
                style: TextStyle(color: Colors.white, fontSize: 18.0)),
          ),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _renderResetPasswordDialog(){
    Dialog _dialog=Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Reset password"),
            ),
            Padding(
              padding:  EdgeInsets.all(10.0),
              child: TextFormField(
                onChanged: (text) {
                  onChangeEmail(text);
                },
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Your email',
                  contentPadding: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              onPressed: () async {
                bool resp = await UserController.instance.forgotPassword(email);
                if (resp ==true){
                  dialog.showSuccessMessage(
                      this.context, "Success", "Please check your email to reset password!").show();
                } else {
                  dialog.showErrorMessage(this.context,"Error", 'Your email is not exist or invalid!').show();
                }
                //_renderForgotPassword();
              },
              padding: EdgeInsets.all(10),
              color: Color.fromRGBO(34, 64, 221, 80),
              child: Text("Reset your password",
                  style: TextStyle(color: Colors.white, fontSize: 18.0)),
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => _dialog);
  }

  onChangeUsername(String text) {
    setState(() {
      username = text;
    });
  }

  onChangePassword(String text) {
    setState(() {
      password = text;
    });
  }

  onChangeEmail(String text) {
    setState(() {
      email = text;
    });
  }
}
