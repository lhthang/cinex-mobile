class Rate{
  String id;
  String name;
  int minAge;

  Rate({this.id,this.name,this.minAge});
  factory Rate.fromJson(Map<String,dynamic> json){
    return Rate(
      id: json['id'],
      name: json['name'],
      minAge: json['minAge'],
    );
  }
}