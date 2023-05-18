import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './song.dart';
import './song_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Song> allSongs;

  const FavoritesScreen({Key? key, required this.allSongs}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Song> favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      favoriteSongs = widget.allSongs
          .where((song) => favorites.contains(song.number.toString()))
          .toList();
    });
  }

  Future<void> removeFromFavorites(Song song) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(song.number.toString())) {
      favorites.remove(song.number.toString());
      await prefs.setStringList('favorites', favorites);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song removed from favorites!')),
      );

      loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color.fromRGBO(61, 109, 158, 1),
      ),
      body: ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
               Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      SongDetailScreen(song: favoriteSongs[index]),
                ),
              );
            },
            child: ListTile(
              title: Text(
                '${favoriteSongs[index].title} (${favoriteSongs[index].number})',
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => removeFromFavorites(favoriteSongs[index]),
                child: const Icon(CupertinoIcons.clear_circled, color: Color.fromRGBO(158, 109, 61, 1),),
              ),
            ),
          );
        },
      ),
    );
  }
}
