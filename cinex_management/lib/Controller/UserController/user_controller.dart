import 'dart:convert';
import 'package:cinex_management/Model/User/new_user.dart';
import 'package:cinex_management/Model/User/user.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

class UserController {
  Store store = new Store();

  List<User> users;
  static UserController _instance;

  static UserController get instance {
    if (_instance == null) _instance = new UserController();
    return _instance;
  }

  Future<String> login(String username, String password) async {
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
      Map<String, dynamic> information = parseJwt(token);
      String roles = information['roles'].toString();
      if (roles.contains("admin")) return "access";
      return "refuse";
    }
    return "fail";
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

  Future<List<User>> getAllUsers() async {
    String token = await store.get("token");
    final response =
        await http.get('$url/users', headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      users = list.map((user) => User.fromJson(user)).toList();
      return users;
    }
    return null;
  }

  Future<bool> insertUser(NewUser newUser) async {
    String token = await store.get("token");
    Map data = {
      'username': newUser.username,
      'password': newUser.password,
      'roleIds': newUser.roleIds,
      'email': newUser.email,
      'cPoint': newUser.cPoint,
    };
    var body = json.encode(data);
    final response = await http.post('$url/add-staff',
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> updateUser(String id,NewUser newUser) async {
    String token = await store.get("token");
    Map data = {
      'username': newUser.username,
      'password': newUser.password,
      'roleIds': newUser.roleIds,
      'email': newUser.email,
      'cPoint': newUser.cPoint,
    };
    var body = json.encode(data);
    final response = await http.put('$url/users/update/'+id,
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<User>> searchUser(String keyword) async {
    List<User> items = users;
    if (keyword.trim() == '') return items;
    return items
        .where((item) =>
            item.username.toUpperCase().indexOf(keyword.toUpperCase()) != -1 ||
            item.email.toUpperCase().indexOf(keyword.toUpperCase()) != -1)
        .toList();
  }

  Future<bool> deleteUser(String id) async {
    String token = await store.get("token");
    final response = await http.delete('$url/users/'+id,
        headers: createHeaderWithAuth(token));
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
