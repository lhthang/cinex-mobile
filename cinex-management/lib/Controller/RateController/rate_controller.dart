import 'dart:convert';

import 'package:cinex_management/Model/Rate/rate.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

class RateController {
  Store store = new Store();
  List<Rate> rates ;
  static RateController _instance;

  static RateController get instance {
    if (_instance == null) _instance = new RateController();
    return _instance;
  }


  Future<List<Rate>> getAllRates() async {
    final response = await http.get('$url/rates');
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      rates =
          list.map((rate) => Rate.fromJson(rate)).toList();
      return rates;
    }
    return null;
  }

  Future<bool> insertRate(Rate newRate) async {
    String token = await store.get("token");
    Map data = {
      'name': newRate.name,
      'minAge': newRate.minAge,
    };
    var body = json.encode(data);
    final response = await http.post('$url/rates',
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<Rate>> searchRate(String keyword) async {
    List<Rate> items = rates;
    if (keyword.trim() == '') return items;
    return items.where((item) => item.name.toUpperCase().indexOf(keyword.toUpperCase()) != -1).toList();
  }

  Future<bool> updateRate(String id,Rate updateRate) async {
    String token = await store.get("token");
    Map data = {
      'name': updateRate.name,
      'minAge': updateRate.minAge,
    };
    var body = json.encode(data);
    final response = await http.put('$url/rates/'+id,
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteRate(String id) async {
    String token = await store.get("token");
    final response = await http.delete('$url/rates/'+id,
        headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
