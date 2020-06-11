import 'dart:convert';
import 'package:cinex_management/Model/Room/room.dart';
import 'package:cinex_management/Model/Room/room_req.dart';
import 'package:cinex_management/utils/func.dart';
import 'package:cinex_management/utils/store.dart';
import 'package:http/http.dart' as http;
import 'package:cinex_management/utils/constant.dart';

class RoomController {
  Store store = new Store();
  List<Room> rooms ;
  static RoomController _instance;

  static RoomController get instance {
    if (_instance == null) _instance = new RoomController();
    return _instance;
  }


  Future<List<Room>> getAllRooms() async {
    final response = await http.get('$url/rooms');
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body).toList();
      rooms =
          list.map((room) => Room.fromJson(room)).toList();
      return rooms;
    }
    return null;
  }

  Future<bool> insertRoom(RoomRequest newRoom) async {
    String token = await store.get("token");
    Map data = {
      'name': newRoom.name,
      'screenTypeIds': newRoom.screenTypeIds,
      'totalSeatsPerRow': newRoom.totalSeatsPerRow,
      'totalRows': newRoom.totalRows,
    };
    var body = json.encode(data);
    final response = await http.post('$url/rooms',
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<Room>> searchRoom(String keyword) async {
    List<Room> items = rooms;
    if (keyword.trim() == '') return items;
    return items.where((item) => item.name.toUpperCase().indexOf(keyword.toUpperCase()) != -1).toList();
  }

  Future<bool> updateRoom(String id,RoomRequest roomRequest) async {
    String token = await store.get("token");
    Map data = {
      'name': roomRequest.name,
      'screenTypeIds': roomRequest.screenTypeIds,
      'totalSeatsPerRow': roomRequest.totalSeatsPerRow,
      'totalRows': roomRequest.totalRows,
    };
    var body = json.encode(data);
    final response = await http.put('$url/rooms/'+id,
        body: body, headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteRoom(String id) async {
    String token = await store.get("token");
    final response = await http.delete('$url/rooms/'+id,
        headers: createHeaderWithAuth(token));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
