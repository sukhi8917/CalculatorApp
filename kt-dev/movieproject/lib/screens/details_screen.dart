import 'package:flutter/material.dart';
import '../models/movie.dart';

class DetailsScreen extends StatelessWidget {
  final Movie movie;

  DetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.image.isNotEmpty)
              Image.network(movie.image, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(movie.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(movie.summary, style: TextStyle(fontSize: 16)),
            if (movie.additionalInfo != null) ...[
              SizedBox(height: 20),
              Text('Additional Info:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(movie.additionalInfo.toString()),
            ],
          ],
        ),
      ),
    );
  }
}
