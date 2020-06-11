import 'dart:convert';

import 'package:cinex/controller/user_controller.dart';
import 'package:cinex/model/user.dart';
import 'package:cinex/model/user_req.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:cinex/dialog/dialog.dart' as dialog;
class AccountView extends StatefulWidget {
  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  Future<User> user = UserController.instance.getUserDetail();

  User detailUser;

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _walletController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _oldPasswordController = new TextEditingController();
  bool _update = false;
  bool isConfirm = false;
  FocusNode myFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          child: _renderView(),
        ),
      ),
      //backgroundColor: Colors.yellow,
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
            children: <Widget>[
              _renderTitleScreen(),
              Expanded(
                child: Container(
                  child: _renderUser(user),
                )
              ),
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
        "Profile",
        style: new TextStyle( fontFamily: 'Dosis',
            fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  _renderUser(Future<User> user){
    return FutureBuilder(
      future: user,
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.done && snapshot.hasData){
          detailUser = snapshot.data;
          _emailController.text = detailUser.email;
          _usernameController.text=detailUser.username;
          _walletController.text=detailUser.cPoint.toString();
          return Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child: ListView(
              padding: EdgeInsets.only(top: 10),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                _renderAvatar(),
                _renderChangePasswordButton(),
                _renderLabel("Username"),
                _renderUsernameTextField(),
                _renderEmailLabel(),
                _renderEmailTextfield(),
                _renderLabel("Wallet"),
                _renderWalletTextField(),
                _renderButton(),
                _renderLogout(),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  _renderAvatar(){
    return Container(
      //margin: EdgeInsets.only(top: 10),
      width: 120,
      height: 120,
      child: CircleAvatar(
        radius: 18,
        child: ClipOval(
          child: Image.asset('assets/avatar/man.jpg'),
        ),
      ),
    );
  }

  _renderLabel(String label){
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle( fontFamily: 'Dosis',
                fontSize: 16.0,
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  _renderEmailLabel(){
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email",
            style: TextStyle( fontFamily: 'Dosis',
                fontSize: 16.0,
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){
                  setState(() {
                    _update= !_update;
                    if (_update)
                      FocusScope.of(context).requestFocus(myFocusNode);
                  });
                  print(_update);
                },
                child: new Icon(
                  Icons.edit,
                  color: Colors.lightBlue,
                  size: 15.0,
                ),
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  _renderUsernameTextField(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Enter Your Name",
              ),
              controller: _usernameController,
              style: TextStyle(color: Colors.white),
              enabled: false,),
          ),
        ],
      ),
    );
  }

  _renderWalletTextField(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
              ),
              controller: _walletController,
              style: TextStyle(color: Colors.white),
              enabled: false,),
          ),
        ],
      ),
    );
  }

  _renderEmailTextfield(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              enabled: _update,
              autofocus: true,
              focusNode: myFocusNode,
            ),
          ),
        ],
      ),
    );
  }

  _renderChangePasswordButton(){
    return Container(
      //margin: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            color: Colors.greenAccent,
            child: Text("Change password",style: new TextStyle( fontFamily: 'Dosis',
                fontSize: 15, fontWeight: FontWeight.w500)),
            onPressed: () async {
              bool changePassword = await _renderResetPasswordDialog();
              if (changePassword){
                String email = _emailController.text;
                UserRequest userRequest = new UserRequest(email: email,password: _passwordController.text,oldPassword: _oldPasswordController.text);
                Response response = await UserController.instance.updateUserInformation(detailUser.username,userRequest);
                if (response.statusCode==200){
                  await dialog.showSuccessMessage(this.context,"Success", 'Updated successfully!').show();
                  setState(() {
                    _oldPasswordController.clear();
                    _passwordController.clear();
                    _update = false;
                  });
                }
                if (response.statusCode==400){
                  String message = jsonDecode(response.body)['message'];
                  dialog.showErrorMessage(this.context,"Error", message + '\nPlease try again!').show();
                }
              }
            },
          ),
        ],
      )
    );
  }

  _renderButton(){
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          color: Color(0xff44c7cb),
          child: Text("Update Information",style: new TextStyle( fontFamily: 'Dosis',
              fontSize: 15, fontWeight: FontWeight.w500)),
          onPressed: () async {
            String newEmail = _emailController.text;
            isConfirm = await _showDialog();
            if(isConfirm){
              UserRequest userRequest = new UserRequest(email: newEmail,password: "",oldPassword: "");
              Response response = await UserController.instance.updateUserInformation(detailUser.username,userRequest);
              if (response.statusCode==200){
                await dialog.showSuccessMessage(this.context,"Success", 'Updated successfully!').show();
                setState(() {
                  user = UserController.instance.getUserDetail();
                  _update = false;
                });
              }
              if (response.statusCode==400){
                String message = jsonDecode(response.body)['message'];
                dialog.showErrorMessage(this.context,"Error", message + '\nPlease try again!').show();
              }
            }
          },
        ),
      ),
    );
  }

  _renderResetPasswordDialog() async {
    bool val = false;
    val = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            //this right here
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Reset password"),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _oldPasswordController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Your old password',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Your new password',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: new Text('Cancel', style:
                TextStyle(color: Colors.redAccent, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
    return val == true;
  }

  _showDialog() async {
    bool value = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to update information?', style:
            TextStyle(color: Color.fromARGB(255, 38, 54, 70), fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500)),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  Navigator.of(context).pop(true);
                },
              ),
              new FlatButton(
                child: new Text('Cancel', style:
                TextStyle(color: Colors.redAccent, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
    return value == true;
  }

  _renderLogout(){
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          color: Colors.redAccent,
          child: Text("Log out",style: new TextStyle( fontFamily: 'Dosis',
              fontSize: 15, fontWeight: FontWeight.w500)),
          onPressed: ()  {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
