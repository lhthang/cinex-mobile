import 'package:cinex_management/Controller/UserController/role_controller.dart';
import 'package:cinex_management/Controller/UserController/user_controller.dart';
import 'package:cinex_management/View/custom_selection_group.dart';
import 'package:cinex_management/dialog/dialog.dart' as dialog;
import 'package:cinex_management/Model/User/new_user.dart';
import 'package:cinex_management/Model/User/role.dart';
import 'package:cinex_management/Model/User/user.dart';
import 'package:cinex_management/utils/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditUserView extends StatefulWidget {
  final User user;

  EditUserView({Key key,@required this.user}) : super (key: key);
  @override
  _EditUserViewState createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {

  TextEditingController _idController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _cPointController = new TextEditingController();

  TextStyle _itemStyle = new TextStyle(
      color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500);

  TextStyle _itemStyle2 = new TextStyle(
      color: accentColor, fontFamily: 'Dosis', fontSize: 18.0, fontWeight: FontWeight.w500);

  Future<List<Role>> rolesList = RoleController.instance.getAllRoles();


  List<Role> selectedRoles = new List();

  NewUser updateUser = new NewUser(username: '',roleIds: [],password: '',cPoint: 0,email: '' );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idController.text=widget.user.id;
    _usernameController.text=widget.user.username;
    _emailController.text=widget.user.email.toString();
    _cPointController.text=widget.user.cPoint.toString();
    selectedRoles=widget.user.roles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User"),
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
                _buildID(),
                _buildUsername(),
                _buildEmail(),
                _buildcPoint(),
                _createButtonSelectRole(snapshot),
                _createButton(),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }

  _buildID(){
    return new TextField(
      controller: _idController,
      enabled: false,
      style: _itemStyle,
      decoration: new InputDecoration(labelText: 'ID:', labelStyle: _itemStyle2),
    );
  }

  _buildUsername() {
    return new TextField(
      enabled: false,
      controller: _usernameController,
      style: _itemStyle,
      decoration: new InputDecoration(labelText: 'Username:', labelStyle: _itemStyle2),
    );
  }

  _buildEmail() {
    return new TextField(
      controller: _emailController,
      style: _itemStyle,
      decoration: new InputDecoration(labelText: 'Email:', labelStyle: _itemStyle2),
    );
  }

  _buildcPoint() {
    return new TextField(
      keyboardType: TextInputType.number,
      controller: _cPointController,
      style: _itemStyle,
      decoration: new InputDecoration(labelText: 'CPoint:', labelStyle: _itemStyle2),
    );
  }

  _createButtonSelectRole(AsyncSnapshot snapshot){
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
            'Save Change',
            style: TextStyle(
                color: fontColor, fontFamily: 'Dosis', fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            _updateUser();
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
    for (var screenType in rolesList){
      list.add(_buildRole(screenType));
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

  _updateUser() async{
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Confirm'),
            content: new Text('Do you want to update this user ?', style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok',),
                onPressed: () async {
                  /* Pop screens */
                  Navigator.of(context).pop();
                  updateUser=new NewUser(username: _usernameController.text,roleIds: [],
                      password: widget.user.password,email: _emailController.text,cPoint: double.tryParse(_cPointController.text));
                  for (var role in selectedRoles)
                    updateUser.roleIds.add(role.id);
                  if (updateUser.username != '' &&updateUser.roleIds.length>0 &&updateUser.email!=''
                      &&updateUser.cPoint!=null) {
                    if (await UserController.instance.updateUser(widget.user.id,updateUser) ){
                      dialog.showSuccessMessage(
                          this.context, "Success", "Updated successfully!").show();
                    } else
                      dialog.showErrorMessage(this.context,"Error", 'Updated failed.' + '\nPlease try again!').show();
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
