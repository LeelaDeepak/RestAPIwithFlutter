class Movie {
  final String name;
  final String posterUrl;
  final List<String> genre;
  final String desc;
  final bool isAdult;
  final String language;
  final int rating;
  final String date;

  Movie({
    required this.name,
    required this.posterUrl,
    required this.genre,
    required this.desc,
    required this.isAdult,
    required this.language,
    required this.rating,
    required this.date,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'],
      posterUrl: json['posterUrl'],
      genre: List<String>.from(json['genre']),
      desc: json['desc'],
      isAdult: json['isAdult'],
      language: json['language'],
      rating: json['rating'],
      date: json['date'],
    );
  }
}