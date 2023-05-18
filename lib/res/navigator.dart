
import 'package:flutter/material.dart';
import '../categories.dart';
import '../favorites_screen.dart';
import '../home_page.dart';
import '../song.dart';
import '../song_detail_screen.dart';

class  MyNavigation {
  void navigateToFavorites(BuildContext context,List<Song> songs) {
    Navigator.push<HomePage>(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritesScreen(allSongs: songs),
      ),
    );
  }

  void navigateToCategories(BuildContext context) {
    Navigator.push<HomePage>(
      context,
      MaterialPageRoute(
        builder: (_) => const CategoriesScreen(),
      ),
    );
  }

  void navigateToDetailsScreen(BuildContext context, Song song) {
    Navigator.push<HomePage>(
      context,
      MaterialPageRoute(
        builder: (_) => SongDetailScreen(song: song),
      ),
    );
  }
}