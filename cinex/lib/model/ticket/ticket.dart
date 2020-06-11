class Ticket{
  String id;
  String showtimeId;
  String movieId;
  String startAt;
  double price;
  String username;
  String status;
  String name;
  String buyAt;

  Ticket({this.id,this.price,this.movieId,this.startAt,this.username,this.showtimeId,
    this.status,this.name,this.buyAt});

  factory Ticket.fromJson(Map<String,dynamic> json){
    return Ticket(
      id: json['id'],
      name: json['name'],
      startAt: json['startAt'],
      price: json['price'],
      username: json['username'],
      showtimeId: json['username'],
      movieId: json['movieId'],
      status: json['status'],
      buyAt: json['buyAt'],
    );
  }
}