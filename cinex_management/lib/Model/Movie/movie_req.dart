class MovieRequest{
  String imdbID;
  String title;
  List<String> screenTypeIds;
  String released;
  String endAt;
  String rateId;
  List<String> genreIds;
  String wallpaper;
  String poster;

  MovieRequest({this.imdbID,this.title,this.released,this.endAt,this.poster,
    this.screenTypeIds,this.rateId,this.wallpaper,this.genreIds});
}