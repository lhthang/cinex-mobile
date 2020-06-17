class Report{
  String movie;
  int showtimes;
  double totalPrice;

  Report({this.movie,this.showtimes,this.totalPrice});

  factory Report.fromJson(Map<String,dynamic> json){
    return Report(
      movie: json['movie'],
      showtimes: json['showtimes'],
      totalPrice: json['totalPrice'],
    );
  }
}