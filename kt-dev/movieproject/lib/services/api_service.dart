import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static Future<List<Movie>> fetchMovies(String query) async {
    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((data) => Movie.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
