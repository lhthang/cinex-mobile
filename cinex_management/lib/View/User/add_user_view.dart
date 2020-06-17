import 'package:cinex_management/Controller/UserController/role_controller.dart';
import 'package:cinex_management/Controller/UserController/user_controller.dart';
import 'package:cinex_management/View/custom_selection_group.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:cinex_management/Model/User/new_user.dart';
import 'package:cinex_management/Model/User/role.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddUserView extends StatefulWidget {
  @override
  _AddUserViewState createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {

  Future<List<Role>> rolesList = RoleController.instance.getAllRoles();

  List<Role> selectedRoles = new List();

  NewUser newUser = new NewUser(username: '',roleIds: [],cPoint: 0,password: '',email: '' );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New User"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _buildView(rolesList),
      ),
    );
  }

  _buildView (Future<List<Role>> list){
    return FutureBuilder(
        future: list,
        builder: (context,snapshot){
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                _createUsername(),
                _createEmail(),
                _createcPoint(),
                _createButtonSelectRoles(snapshot),
                _createButton(),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  _createUsername() {
    return TextField(
      style: TextStyle(
          color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(labelText: 'Username* :', labelStyle: TextStyle(
          color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          newUser.username=text;
        });
      },
    );
  }

  _createEmail() {
    return TextField(
      style: TextStyle(
          color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(labelText: 'Email* :', labelStyle: TextStyle(
          color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          newUser.email=text;
        });
      },
    );
  }

  _createcPoint() {
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(
          color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
      decoration: new InputDecoration(labelText: 'CPoint* :', labelStyle: TextStyle(
          color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500)),
      onChanged: (text){
        setState(() {
          newUser.cPoint=double.tryParse(text);
        });
      },
    );
  }

  _createButtonSelectRoles(AsyncSnapshot snapshot){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              height: 30,
              child: Material(
                elevation: 1.25,
                borderRadius:  BorderRadius.circular(3),
                color: Colors.greenAccent,
                child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                          Icons.arrow_drop_down
                      ),
                      Text("Role",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500) ,
                      )
                    ],
                  ),
                  onTap: () {
                    _showRolesDialog(snapshot.data);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: Wrap(
              direction: Axis.horizontal,
              children:  _buildRolesOfUser(selectedRoles),
            ),
          )
        ],
      ),
    );
  }

  _createButton(){
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: double.infinity,
        child: new RaisedButton(
          color: Colors.greenAccent,
          child: new Text(
            'Create User',
            style: TextStyle(
                color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _createUser();
          },
        ),
      ),
    );
  }

  _buildRolesOfUser(List<Role> rolesList){
    List<Widget> list = new List();
    if (rolesList.length>3){
      for(int i=0;i<3;i++){
        list.add(_buildRole(rolesList[i]));
      }
      list.add(_buildRole(new Role(role: "...")));
      return list;
    }
    for (var role in rolesList){
      list.add(_buildRole(role));
    }
    return list;
  }

  _buildRole(Role role){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: accentColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(role.role.toUpperCase()),
    );
  }

  _showRolesDialog(List<Role> list){
    List<CustomSelectionItem> options = list.map((item) {
      return CustomSelectionItem(value: item.id, label: item.role.toUpperCase());
    }).toList();

    List<String> selectedRoleIds = selectedRoles.map((item) {
      return item.id;
    }).toList();

    List<Role> _getSelectedRoles() {
      return list.where((item) => selectedRoleIds.contains(item.id)).toList();
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.center,
              child: Text("Select your screen type"),
            ),
            contentPadding: EdgeInsets.only(top: 12.0),
            content: CustomSelectionGroup(
              options: options,
              initialSelectedValues: selectedRoleIds,
              onChanged: (newSelectedIds) {
                print(newSelectedIds);
                selectedRoleIds = List.from(newSelectedIds);
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  setState(() {
                    selectedRoles=_getSelectedRoles();
                  });
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  _createUser() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to create new user ?', style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  for (var role in selectedRoles)
                    newUser.roleIds.add(role.id);
                  newUser.password=newUser.username;
                  String password=  newUser.password;
                  Navigator.of(context).pop();
                  if (newUser.username != '' &&newUser.roleIds.length>0 &&newUser.password!=''
                      &&newUser.email!='') {
                    if (await UserController.instance.insertUser(newUser) ){
                      dialog.showSuccessMessage(
                          this.context, "Success", "Create new user successfully!"+ '\nDefault password is $password').show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Create new user failed.' + '\nPlease try again!').show();
                    return;
                  }
                  dialog.showErrorMessage(this.context,"Error", 'Some fields are invalid.' + '\nPlease try again!').show();
                },
              ),
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
