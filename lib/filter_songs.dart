import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ribkapesni/song.dart';
import 'package:ribkapesni/song_detail_screen.dart';

class FilterSongs extends StatelessWidget{
  final List<Song> filteredSongs;

  const FilterSongs({Key? key, required this.filteredSongs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('\u{1F41F} Песнь возрождения'),),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: ()  =>  Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, color: Colors.white,),
        ),
      ),
      body:ListView.builder(
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
    );
  }
}
