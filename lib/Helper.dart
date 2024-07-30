import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movizplaza/movieModel.dart';

const String baseUrl =
    "https://firebasestorage.googleapis.com/v0/b/friendsbirthdayapp.appspot.com/o/db.json?alt=media&token=1032dd9f-7271-4455-9c8a-6f3a011ef81f";

const String logoUrl = "https://firebasestorage.googleapis.com/v0/b/friendsbirthdayapp.appspot.com/o/BrandAssets_Logos_01-Wordmark.jpg?alt=media&token=7812177c-b03d-488a-ad9c-a946998a51e8";
const String anotherLogo = "https://firebasestorage.googleapis.com/v0/b/friendsbirthdayapp.appspot.com/o/download.png?alt=media&token=ac4f01d4-b651-4f6f-86fa-e14d368aaa87";
const String anotheroneLogo = "https://firebasestorage.googleapis.com/v0/b/friendsbirthdayapp.appspot.com/o/download.jpeg?alt=media&token=647df208-e31a-4fbc-a782-c5bd4b8343fd";
const String lastlogo = "https://firebasestorage.googleapis.com/v0/b/friendsbirthdayapp.appspot.com/o/f.jpeg?alt=media&token=0e7a33e6-4cc9-4c85-95eb-191a6c78c179";

final moviesProvider = FutureProvider<List<Movie>>((ref) async {
  final response = await http.get(Uri.parse(baseUrl));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => Movie.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load movies');
  }
});

final genreProvider = Provider<List<String>>((ref) {
  final movies = ref.watch(moviesProvider).maybeWhen(
        data: (data) => data,
        orElse: () => [],
      );
  final genreCounts = <String, int>{'All': movies.length};
  for (var movie in movies) {
    for (var genre in movie.genre) {
      genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
    }
  }
  return genreCounts.entries.map((e) => '${e.key} (${e.value})').toList();
});

final selectedGenreProvider = StateProvider<String>((ref) {
  return 'All';
});

final showAdultMoviesProvider = StateProvider<bool>((ref) {
  return false;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final appLogo = StateProvider<String>((ref) => logoUrl);

final myanotherApplogo = StateProvider<String>((ref) => anotherLogo);

final jioLogo = StateProvider<String>((ref) => anotheroneLogo);

final fLogo = StateProvider<String>((ref)=>lastlogo);

final viewBygenre = StateProvider<bool>((ref)=>false);