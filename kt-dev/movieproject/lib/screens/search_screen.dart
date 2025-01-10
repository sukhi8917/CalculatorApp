import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/movie_card.dart';
import '../models/movie.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  List<Movie> movies = [];

  void searchMovies() async {
    if (searchQuery.isNotEmpty) {
      final results = await ApiService.fetchMovies(searchQuery);
      setState(() {
        movies = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: 'Search movies...'),
          onChanged: (value) => setState(() => searchQuery = value),
          onSubmitted: (_) => searchMovies(),
        ),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(
            movie: movies[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailsScreen(movie: movies[index])),
              );
            },
          );
        },
      ),
    );
  }
}
