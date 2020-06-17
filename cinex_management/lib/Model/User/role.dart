class Role{
  String id;
  String role;

  Role({this.id,this.role});
  factory Role.fromJson(Map<String,dynamic> json){
    return Role(
      id: json['id'],
      role: json['role'],
    );
  }
}