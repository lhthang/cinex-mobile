import 'package:cinex/model/new_user.dart';
import 'package:cinex/route/route_path.dart' as routes;
import 'package:cinex/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:cinex/dialog/dialog.dart' as dialog;

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String username = "";
  String password = "";
  String email = "";

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
                _renderEmail(),
                SizedBox(height: 10.0),
                _renderPassword(),
                SizedBox(height: 10.0),
                _renderSignUpButton(context),
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

  _renderEmail() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        onChanged: (text) {
          onChangeEmail(text);
        },
        validator: validateEmail,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Email",
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

  _renderSignUpButton(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 20),
        Expanded(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () {
              _signUp();
            },
            padding: EdgeInsets.all(12),
            color: Color.fromRGBO(34, 64, 221, 80),
            child: Text("Register",
                style: TextStyle(color: Colors.white, fontSize: 18.0)),
          ),
        ),
        SizedBox(width: 20),
      ],
    );
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

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

   _signUp() async {
    NewUser newUser = new NewUser(username, email, password);
    bool isSuccess = await UserController.instance.signUp(newUser);
    if (isSuccess) {
      dialog.showSuccessMessage(
          context, "Success", "Register successfully").show().then((val){
          Navigator.of(context).pushNamed(routes.login);
      });

    } else
      dialog.showErrorMessage(context, "Error", "Register failed").show();
  }
}
