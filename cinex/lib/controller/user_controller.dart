import 'dart:convert';
import 'dart:io';

import 'package:cinex/model/new_user.dart';
import 'package:cinex/model/user.dart';
import 'package:cinex/model/user_req.dart';
import 'package:cinex/utils/func.dart';
import 'package:cinex/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex/utils/constant.dart';

class UserController {
  Store store = new Store();

  List<User> users;
  static UserController _instance;

  static UserController get instance {
    if (_instance == null) _instance = new UserController();
    return _instance;
  }

  Future<bool> login(String username, String password) async {
    Map data = {
      'username': username,
      'password': password,
    };

    var body = json.encode(data);
    final response = await http.post('$url/login', body: body);

    if (response.statusCode == 200) {
      String token = json.decode(response.body)['token'];
      print(token);
      store.save("token", token);
      return true;
    }
    return false;
  }

  Future<User> getUserDetail() async {
    String token = await store.get("token");
    Map<String, dynamic> information = parseJwt(token);
    String username = information['username'].toString();
    final response = await http.get('$url/user/$username',
        headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      User user = User.fromJson(json.decode(response.body));
      return user;
    }
    return null;
  }

  Future<http.Response> updateUserInformation(String username,UserRequest userRequest) async {
    String token = await store.get("token");
    Map data = {
      'email': userRequest.email,
      'oldPassword': userRequest.oldPassword,
      'password': userRequest.password,
    };

    var body = json.encode(data);
    final response = await http.put('$url/user/'+username, body: body,headers: createHeaderWithAuth(token));

    return response;
  }

  Future<bool> signUp(NewUser newUser) async {
    Map data = {
      'username': newUser.username,
      'email': newUser.email,
      'password': newUser.password,
    };

    var body = json.encode(data);
    final response =
    await http.post('$url/register', body: body, headers: createHeader());
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> forgotPassword(String email) async {
    final response =
    await http.post('$url/forgot?email='+email);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
