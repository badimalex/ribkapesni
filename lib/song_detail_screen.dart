import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'song.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  SongDetailScreen({required this.song});

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.song.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.plus),
              onPressed: _increaseFontSize,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.minus),
              onPressed: _decreaseFontSize,
            ),
          ],
        ),
      ),
      child: CupertinoScrollbar(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                '${widget.song.number}', // Display the song number
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                widget.song.lyrics,
                style: TextStyle(fontSize: _fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
