import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ribkapesni/filter_songs.dart';
import 'package:ribkapesni/song.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Song> filteredSongs = [];
  List<String> selectedCategories = [];
  List<String> categories = [
    'Дополнительно',
    'Молитвенные',
    'Призыв к покаянию',
    'Утешение и ободрение',
    'Хвала и благодарение',
    'Небесные обители',
    'Молодёжные',
    'Иисус Христос',
    'Путь веры, вера и упование',
    'Воскресение Христово',
    'Практическая жизнь с Богом',
    'Спасение',
    'Любовь',
    'Божья любовь и величие',
    'Детские и семейные',
    'Духовная борьба и победа',
    'Страдание и смерть Христа',
    'Следование за Христом',
    'Жатвенные',
    'О Церкви',
    'Призыв к труду',
    'Утренние и вечерние',
    'Перед началом собрания',
    'Библейские истории',
    'На бракосочетание',
    'На крещение',
    'На новый год',
    'На погребение',
    'На рукоположение',
    'На хлебопреломление',
    'Наставление и самоиспытание',
    'Весть о спасении',
    'Для новообращённых',
    'Время',
    'Второе пришествие Христа и суд',
    'Рождество Христово',
    'О Духе Святом',
    'Приветственные и прощальные',
    'Решительность и верность',
    'Последнее время',
    'Разные христианские праздники',
    'Слово Божье',
    'Христианская радость'
  ];

  String selectedCategory = '';
  TextEditingController searchController = TextEditingController();

  Future<void> loadSongs() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final data = await json.decode(response);
    setState(() {
      filteredSongs =
          (data as List).map((songJson) => Song.fromJson(songJson)).toList();
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

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
      filterSongs(searchController.text);
    });
  }

  void filterSongs(String value) {
    setState(() {
      filteredSongs = filteredSongs
          .where((song) =>
      (song.title.toLowerCase().contains(value.toLowerCase()) ||
          song.number.toString().contains(value) ||
          RegExp(value.replaceAll(RegExp(r'[.,!]+'), ''),
              caseSensitive: false)
              .hasMatch(
              song.lyrics.replaceAll(RegExp(r'[.,!]+'), ''))) &&
          (selectedCategories.isEmpty ||
              selectedCategories.contains(song.category)))
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
      ),
      body: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                final category = categories[index];

                return CupertinoButton(
                  onPressed: () async  {
                    toggleCategory(category);
                    await Navigator.push<CategoriesScreen>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FilterSongs(filteredSongs: filteredSongs),
                      ),
                    );
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(category),
                );
              },
            ),
    );
  }
}