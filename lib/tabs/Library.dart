import 'dart:developer';

import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:c_music/MusicPlayer/SongListTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);
  @override
  State<Library> createState() => _LibraryState(songDragController: ScrollController());
}

final FlutterAudioQuery audioQuery = FlutterAudioQuery();

class _LibraryState extends State<Library>  with AutomaticKeepAliveClientMixin {
  late List<SongInfo> songs;
   List<Widget> children =[];
  bool getSongsFromFile = true;
  final ScrollController songDragController ;

   _LibraryState({
    required this.songDragController,
  });

  Future<String> _getFiles() async {
    try {
      songs = await audioQuery.getSongs();
    } catch (e) {
      print(e.toString());
    }

    children = songs.map((song) => SongListTile(song, songs, key: Key(song.id),)).toList();
    return songs.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _getFiles();

  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getSongsFromFile? _getFiles():null, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      //  List<Widget> children;
        if (snapshot.hasData ) {
          getSongsFromFile = false;
         // children = songs.map((song) => SongListTile(song, songs, key: Key(song.id),)).toList();
        } else if (snapshot.hasError) {

          return Center(child:Column(children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ],));

        } else {

          return Center(child:Column(children: [
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Loading library...'),
            )
          ],));

        }

        // return Center(
        //   child: DraggableScrollbar.arrows(controller: songDragController ,
        //   child:ListView(
        //   controller: songDragController,
        //     children: children,
        //   ),
        //   ),
        // );
return DraggableScrollbar.arrows(
  controller: songDragController,
  labelTextBuilder: (double offset) => Text("${offset ~/ 65}", style: TextStyle(color: Colors.black),),
  child: ListView.builder(
    controller: songDragController,
    itemCount: children.length,
    itemExtent: 65,
    itemBuilder: (context, index) {
      return children[index];
    },
  ),
);

      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
