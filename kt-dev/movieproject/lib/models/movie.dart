class Movie {
  final String title;
  final String summary;
  final String image;
  final Map<String, dynamic>? additionalInfo;

  Movie({required this.title, required this.summary, required this.image, this.additionalInfo});

  factory Movie.fromJson(Map<String, dynamic> json) {
    final show = json['show'] ?? {};
    return Movie(
      title: show['name'] ?? 'No Title',
      summary: show['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No Summary Available',
      image: show['image']?['medium'] ?? '',
      additionalInfo: show,
    );
  }
}
