import 'dart:ffi';

class User{
  String id;
  String username;
  String password;
  String email;
  double cPoint;

  User({this.id,this.username,this.password,this.email,this.cPoint});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      id: json['id'].toString(),
      username: json['username'].toString(),
      password: json['password'].toString(),
      email: json['email'].toString(),
      cPoint: json['cPoint'].toDouble(),
    );
  }
}