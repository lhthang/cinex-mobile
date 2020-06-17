import 'package:cinex_management/Model/User/role.dart';

class User{
  String id;
  String username;
  String password;
  String email;
  double cPoint;
  List<Role> roles;

  User({this.id,this.username,this.password,this.email,this.cPoint,this.roles});

  factory User.fromJson(Map<String,dynamic> json){
    var list = json['roles'] as List;
    List<Role> roles = list.map((role) => Role.fromJson(role)).toList();
    return User(
      id: json['id'].toString(),
      username: json['username'].toString(),
      password: json['password'].toString(),
      email: json['email'].toString(),
      cPoint: json['cPoint'].toDouble(),
      roles:roles,
    );
  }
}