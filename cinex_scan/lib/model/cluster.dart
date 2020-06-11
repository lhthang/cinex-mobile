class Cluster{
  String id;
  String name;

  Cluster({this.id,this.name});
  factory Cluster.fromJson(Map<String, dynamic> json) {
    return Cluster(
      id: json['id'],
      name: json['name'],
    );
  }
}