import 'dart:convert';
import 'package:cinex_management/Model/ScreenType/screentype.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

class ScreenTypeController {
  Store store = new Store();
  List<ScreenType> screenTypes ;
  static ScreenTypeController _instance;

  static ScreenTypeController get instance {
    if (_instance == null) _instance = new ScreenTypeController();
    return _instance;
  }


  Future<List<ScreenType>> getAllScreenTypes() async {
    final response = await http.get('$url/screen-types');
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      screenTypes =
          list.map((screenType) => ScreenType.fromJson(screenType)).toList();
      return screenTypes;
    }
    return null;
  }

  Future<bool> insertScreenType(String name) async {
    String token = await store.get("token");
    Map data = {
      'name': name,
    };
    var body = json.encode(data);
    final response = await http.post('$url/screen-types',
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<ScreenType>> searchScreenType(String keyword) async {
    List<ScreenType> items = screenTypes;
    if (keyword.trim() == '') return items;
    return items.where((item) => item.name.toUpperCase().indexOf(keyword.toUpperCase()) != -1).toList();
  }

  Future<bool> updateScreenType(String id,String name) async {
    String token = await store.get("token");
    Map data = {
      'name': name,
    };
    var body = json.encode(data);
    final response = await http.put('$url/screen-types/'+id,
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteScreenType(String id) async {
    String token = await store.get("token");
    final response = await http.delete('$url/screen-types/'+id,
        headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
