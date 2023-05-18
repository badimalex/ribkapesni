import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'song.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({Key? key, required this.song}) : super(key: key);

  @override
  _SongDetailScreenState createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    });
  }

  Future<void> _saveFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
  }

  Future<void> addToFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> favorites = prefs.getStringList('favorites')?.toSet() ?? {};

    if (!favorites.contains(widget.song.number.toString())) {
      favorites.add(widget.song.number.toString());
      await prefs.setStringList('favorites', favorites.toList());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song added to favorites!')),
      );
    }
  }

  void _increaseFontSize() {
    setState(() {
      _fontSize += 1;
      _saveFontSize();
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize -= 1;
      _saveFontSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(61, 109, 158, 1),
        actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: addToFavorites,
              child: const Icon(CupertinoIcons.heart, color: Colors.white,),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _increaseFontSize,
              child: const Icon(CupertinoIcons.plus, color: Colors.white,),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _decreaseFontSize,
              child: const Icon(CupertinoIcons.minus, color: Colors.white,),
            ),
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
            children: [
                Text(
                  '${widget.song.number}', // Display the song number
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade400,),
                ),
                Text(
                  widget.song.lyrics,
                  style: TextStyle(fontSize: _fontSize),
                ),
            ],
          ),
      ),
    );
  }
}
