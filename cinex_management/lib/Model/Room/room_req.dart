class RoomRequest{
  String name;
  int totalRows;
  int totalSeatsPerRow;
  List<String> screenTypeIds;

  RoomRequest({this.name,this.screenTypeIds,this.totalRows,this.totalSeatsPerRow});
}