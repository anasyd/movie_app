class Movie {
  String title;
  String originalTitle;
  String overview;
  String? posterPath;
  String? backDropPath;
  String releaseDate;
  double voteAverage;
  int id;

  Movie(
      {required this.title,
      required this.originalTitle,
      required this.overview,
      this.posterPath,
      this.backDropPath,
      required this.releaseDate,
      required this.voteAverage,
      required this.id});

  factory Movie.fromJson(Map<String, dynamic> movieJson) {
    return Movie(
        title: movieJson["title"],
        originalTitle: movieJson["original_title"],
        overview: movieJson["overview"],
        posterPath: movieJson["poster_path"],
        backDropPath: movieJson["backdrop_path"],
        releaseDate: movieJson["release_date"],
        voteAverage: movieJson["vote_average"].toDouble(),
        id: movieJson["id"].toInt());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'original_title': originalTitle,
        'overview': overview,
        'poster_path': posterPath,
        'backdrop_path': backDropPath,
        'release_date': releaseDate,
        'vote_average': voteAverage,
      };
}
