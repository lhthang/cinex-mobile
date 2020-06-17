import 'package:cinex_management/Model/ScreenType/screentype.dart';

class Room {
  String id;
  String name;
  int totalSeats;
  int totalSeatsPerRow;
  int totalRows;
  List<ScreenType> screenTypes;

  Room({this.id,this.name,this.screenTypes,this.totalRows,this.totalSeats,this.totalSeatsPerRow});

  factory Room.fromJson(Map<String,dynamic> json){
    var list = json['screenTypes'] as List;
    List<ScreenType> screenTypes = list.map((screenType) => ScreenType.fromJson(screenType)).toList();
    return Room(
      id: json['id'],
      name: json['name'],
      totalRows: json['totalRows'],
      totalSeatsPerRow: json['totalSeatsPerRow'],
      totalSeats: json['totalSeats'],
      screenTypes: screenTypes,
    );
  }
}