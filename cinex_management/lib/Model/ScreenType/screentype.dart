class ScreenType{
  String id;
  String name;

  ScreenType({this.id,this.name});
  factory ScreenType.fromJson(Map<String,dynamic> json){
    return ScreenType(
      id: json['id'],
      name: json['name'],
    );
  }
}