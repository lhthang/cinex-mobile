class Movie{
  String id;
  String name;
  String poster;

  Movie({this.id,this.poster,this.name});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      name: json['title'],
      poster: json['poster'],
    );
  }
}