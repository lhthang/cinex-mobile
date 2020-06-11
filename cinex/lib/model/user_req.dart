import 'package:cinex/model/user.dart';

class UserRequest{
  String email;
  String oldPassword;
  String password;

  UserRequest({this.email,this.password,this.oldPassword});
}