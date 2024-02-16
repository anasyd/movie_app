class Movie {
  String title;
  String originalTitle;
  String overview;
  String posterPath;
  String backDropPath;
  String releaseDate;
  double voteAverage;

  Movie({
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backDropPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> movieJson) {
    return Movie(
        title: movieJson["title"],
        originalTitle: movieJson["original_title"],
        overview: movieJson["overview"],
        posterPath: movieJson["poster_path"],
        backDropPath: movieJson["backdrop_path"],
        releaseDate: movieJson["release_date"],
        voteAverage: movieJson["vote_average"].toDouble());
  }
}
