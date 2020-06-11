import 'dart:convert';
import 'package:cinex_scan/constant/constant.dart';
import 'package:cinex_scan/constant/func.dart';
import 'package:cinex_scan/constant/store.dart';
import 'package:http/http.dart' as http;

class LoginController {
  Store store = new Store();

  static LoginController _instance;

  static LoginController get instance {
    if (_instance == null) _instance = new LoginController();
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
      if (roles.contains("admin") || roles.contains("staff")) return "access";
      return "refuse";
    }
    return "fail";
  }
}
