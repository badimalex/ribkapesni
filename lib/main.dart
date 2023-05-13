import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import './song_detail_screen.dart';
import './song.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
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
      filteredSongs = songs
          .where((song) =>
              (song.title.toLowerCase().contains(value.toLowerCase()) ||
               song.number.toString().contains(value) ||
               RegExp(value.replaceAll(RegExp(r'[.,!]+'), ''),
                      caseSensitive: false)
                  .hasMatch(song.lyrics.replaceAll(RegExp(r'[.,!]+'), ''))) &&
              (selectedCategories.isEmpty || selectedCategories.contains(song.category))
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('\u{1F41F} Песнь возрождения'),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CupertinoTextField(
                controller: searchController,
                clearButtonMode: OverlayVisibilityMode.editing,
                placeholder: "Искать по названию или тексту",
              ),
              Wrap(
              spacing: 5.0, // gap between adjacent chips
              runSpacing: 5.0, // gap between lines
              children: categories.map((category) => CupertinoButton(
                color: selectedCategories.contains(category)
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.systemGrey3,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Text(category, style: TextStyle(color: selectedCategories.contains(category) ? CupertinoColors.white : CupertinoColors.black)),
                onPressed: () => toggleCategory(category),
              )).toList(),
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
        ));
  }
}
