import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './song_detail_screen.dart';
import './song.dart';
import 'categories.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мое приложение',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> songs = [];
  List<Song> filteredSongs = [];


  TextEditingController searchController = TextEditingController();

  Future<void> loadSongs() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final data = await json.decode(response);
    setState(() {
      songs =
          (data as List).map((songJson) => Song.fromJson(songJson)).toList();
      filteredSongs = songs;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSongs();
    searchController.addListener(() {
      filterSongs(searchController.text);
    });
  }

  void filterSongs(String value) {
    setState(() {
      filteredSongs = songs
          .where((song) =>
              (song.title.toLowerCase().contains(value.toLowerCase()) ||
                  song.number.toString().contains(value) ||
                  RegExp(value.replaceAll(RegExp(r'[.,!]+'), ''),
                          caseSensitive: false)
                      .hasMatch(
                          song.lyrics.replaceAll(RegExp(r'[.,!]+'), ''))))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('\u{1F41F} Песнь возрождения'),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: ()  =>  Navigator.push<HomePage>(
            context,
            MaterialPageRoute(
              builder: (_) => const CategoriesScreen(),
            ),
          ),
          child: const Icon(CupertinoIcons.line_horizontal_3_decrease_circle_fill, color: Colors.white,),
        ),
      ),
      body: Column(
        children: [
          CupertinoTextField(
            controller: searchController,
            clearButtonMode: OverlayVisibilityMode.editing,
            placeholder: "Искать по названию или тексту",
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                return CupertinoButton(
                  child: Text(
                    '${filteredSongs[index].title} (${filteredSongs[index].number})',
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            SongDetailScreen(song: filteredSongs[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
