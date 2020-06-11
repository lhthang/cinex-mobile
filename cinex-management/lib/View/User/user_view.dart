import 'package:cinex_management/Controller/UserController/user_controller.dart';
import 'package:cinex_management/Model/User/role.dart';
import 'package:cinex_management/Model/User/user.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:cinex_management/route/route_path.dart' as routes;
import 'package:cinex_management/dialog/dialog.dart' as dialog;

class UserView extends StatefulWidget {
  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {

  String searchKey= "";
  Future<List<User>> usersList= UserController.instance.getAllUsers();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildSearchBar(),
          SizedBox(
            height: 10,
          ),
          Expanded(child: _buildData(usersList)),
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
                  usersList =
                      UserController.instance.searchUser(searchKey);
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
              await Navigator.of(context).pushNamed(routes.add_user);
              setState(() {
                usersList= UserController.instance.getAllUsers();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildData(Future<List<User>> usersList) {
    return FutureBuilder(
      future: usersList,
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
              return _renderUser(snapshot.data[index]);
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _renderUser(User user){
    return Container(
      //padding: EdgeInsets.only(left: 5,right: 5),
      height: 130,
      child: Card(
        elevation: 1.25,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                //padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.person_outline,
                  size: 40,
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
                      child: Text(user.username,style: mainTitle,),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(user.email,
                          style: subTitle),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("\$: " +user.cPoint.toString(),style: TextStyle(fontSize: 12,color: Colors.black54)),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: _buildRolesOfUser(user),
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
                        await Navigator.pushNamed(context,routes.edit_user,arguments: user);
                        setState(() {
                          usersList=UserController.instance.getAllUsers();
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
                        _deleteUser(user);
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

  _buildRolesOfUser(User user){
    List<Widget> list = new List();
    if (user.roles.length>=3){
      for(int i=0;i<2;i++){
        list.add(_buildScreenType(user.roles[i]));
      }
      list.add(_buildScreenType(new Role(role: "...")));
      return list;
    }
    for (var role in user.roles){
      list.add(_buildScreenType(role));
    }
    return list;
  }

  _buildScreenType(Role role){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(role.role.toUpperCase()),
    );
  }

  _deleteUser(User user){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm', style: titleStyle),
            content: new Text('Do you want to delete this user: ' + user.username + '?',
                style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Ok', style: okButtonStyle),
                  onPressed: () async {
                    /* Pop screens */
                    Navigator.of(context).pop();
                    if (await UserController.instance.deleteUser(user.id)) {
                      setState(() {
                        usersList = UserController.instance.getAllUsers();
                      });
                      dialog.showSuccessMessage(
                          this.context, "Success", "Deleted "+ user.username+ " successfully!").show();
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
