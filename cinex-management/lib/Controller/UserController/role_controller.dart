import 'dart:convert';
import 'package:cinex_management/Model/User/role.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

class RoleController {
  Store store = new Store();
  List<Role> roles ;
  static RoleController _instance;

  static RoleController get instance {
    if (_instance == null) _instance = new RoleController();
    return _instance;
  }


  Future<List<Role>> getAllRoles() async {
    String token = await store.get("token");
    final response = await http.get('$url/roles',headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      roles =
          list.map((role) => Role.fromJson(role)).toList();
      return roles;
    }
    return null;
  }
}
