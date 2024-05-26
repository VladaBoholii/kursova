import 'package:cinema_tickets_web_app/models/Showtime.dart';

class Movie {
  final String id;
  final List<Showtime> showtimes;
  final String ageRating;
  final List<String> genres;
  final String titleOriginal;
  final String titleUA;
  final String overview;
  final String poster;
  final int runtime;
  final String tagline;

  Movie(
      {required this.id,
      required this.ageRating,
      required this.genres,
      required this.titleOriginal,
      required this.titleUA,
      required this.overview,
      required this.poster,
      required this.runtime,
      required this.tagline,
      required this.showtimes});

  factory Movie.fromJson(
      Map<String, dynamic> json, List<Showtime> showtimes, String id) {
    return Movie(
      id: id,
      showtimes: showtimes,
      ageRating: json['age_rating'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      titleOriginal: json['title_original'] ?? '',
      titleUA: json['title_ua'] ?? '',
      overview: json['overview'] ?? '',
      poster: json["poster"] ?? "",
      runtime: json['runtime'] ?? 0,
      tagline: json['tagline'] ?? '',
    );
  }
}
