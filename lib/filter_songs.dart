import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ribkapesni/res/navigator.dart';
import 'package:ribkapesni/song.dart';

class FilterSongs extends StatelessWidget{
  final List<Song> filteredSongs;

  const FilterSongs({Key? key, required this.filteredSongs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Песнь возрождения'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(61, 109, 158, 1),
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
              onPressed: () => MyNavigation().navigateToDetailsScreen(context, filteredSongs[index]),

            );
          },
        ),
    );
  }
}
