class Song {
  final String title;
  final String lyrics;
  final String category;
  final int number;

  Song(
      {required this.title,
      required this.lyrics,
      required this.number,
      required this.category});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      number: json['number'],
      category: json['category'],
      lyrics: json['lyrics'].replaceAll('\\n', '\n'),
    );
  }
}
