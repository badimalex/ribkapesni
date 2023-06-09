import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ribkapesni/res/navigator.dart';
import './song.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Song> songs = [];
  List<Song> filteredSongs = [];

  TextEditingController searchController = TextEditingController();

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      filteredSongs = songs
          .where((song) => favorites.contains(song.number.toString()))
          .toList();
    });
  }

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
    loadFavorites();
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
              .hasMatch(song.lyrics.replaceAll(RegExp(r'[.,!]+'), ''))))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(61, 109, 158, 1),
        title: const Text('Песнь возрождения'),
      centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              margin: EdgeInsets.only(bottom: 15.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(61, 109, 158, 1),
              ),
              child: Text('Песнь\nвозрождения', style: TextStyle(color: Colors.white, fontSize: 24),),
            ),
            ListTile(
              leading: const Icon(
                Icons.favorite_outlined,
                color: Colors.blueGrey,
              ),
              title: const Text('Избранное', style: TextStyle(color: Colors.blueGrey),),
              onTap: () => MyNavigation().navigateToFavorites(context, songs),
            ),
            ListTile(
              leading: const Icon(
                Icons.library_music_rounded,
                color: Colors.blueGrey,
              ),
              title: const Text('Тематика песен', style: TextStyle(color: Colors.blueGrey),),
              onTap: () => MyNavigation().navigateToCategories(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 15),
              child: CupertinoTextField(
                padding: const EdgeInsets.all(16),
                controller: searchController,
                clearButtonMode: OverlayVisibilityMode.editing,
                placeholder: "Искать псалом",
                placeholderStyle: TextStyle(color: Colors.blueGrey.shade200),
                style: const TextStyle(color: Color.fromRGBO(61, 109, 158, 1)),
                cursorColor: const Color.fromRGBO(61, 109, 158, 1),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blueGrey.shade100,
                    width: 2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Text(
                          filteredSongs[index].title,
                          style: const TextStyle(color: Color.fromRGBO(61, 109, 158, 1)),
                        ),
                        onPressed: () => MyNavigation().navigateToDetailsScreen(context, filteredSongs[index]),
                      ),
                      Text('${filteredSongs[index].number}', style: TextStyle(color: Colors.blueGrey.shade400),),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
