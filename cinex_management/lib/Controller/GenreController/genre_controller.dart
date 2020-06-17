import 'dart:convert';
import 'package:cinex_management/Model/Genre/genre.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

class GenreController {
  Store store = new Store();
  List<Genre> genres ;
  static GenreController _instance;

  static GenreController get instance {
    if (_instance == null) _instance = new GenreController();
    return _instance;
  }


  Future<List<Genre>> getAllGenres() async {
    final response = await http.get('$url/genres');
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      genres =
          list.map((genre) => Genre.fromJson(genre)).toList();
      return genres;
    }
    return null;
  }

  Future<bool> insertGenre(String name) async {
    String token = await store.get("token");
    Map data = {
      'name': name,
    };
    var body = json.encode(data);
    final response = await http.post('$url/genres',
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<Genre>> searchGenre(String keyword) async {
    List<Genre> items = genres;
    if (keyword.trim() == '') return items;
    return items.where((item) => item.name.toUpperCase().indexOf(keyword.toUpperCase()) != -1).toList();
  }

  Future<bool> updateGenre(String id,String name) async {
    String token = await store.get("token");
    Map data = {
      'name': name,
    };
    var body = json.encode(data);
    final response = await http.put('$url/genres/'+id,
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteGenre(String id) async {
    String token = await store.get("token");
    final response = await http.delete('$url/genres/'+id,
        headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
