import 'package:cinex_scan/model/cluster.dart';

class Room{
  String id;
  String name;
  Cluster cluster;

  Room({this.id,this.name,this.cluster});
  factory Room.fromJson(Map<String, dynamic> json) {
    Cluster cluster= new Cluster();
    cluster=Cluster.fromJson(json['cluster']);
    return Room(
      id: json['id'],
      name: json['name'],
      cluster: cluster,
    );
  }
}