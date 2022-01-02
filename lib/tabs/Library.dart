import 'dart:convert';
import 'dart:developer';

import 'package:c_music/MusicPlayer/SongListTile.dart';
import 'package:c_music/common/commonWidgets.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> with AutomaticKeepAliveClientMixin {
  late List<SongInfo> songs;
  List<Widget> children = [];
  bool getSongsFromStorage = true;
  late SharedPreferences prefs;

  final ScrollController songDragController = ScrollController();

  Future<String> _getFiles() async {
    try {

      songs = await audioQuery.getSongs();
      log(songs.toString());
    } catch (e) {
      print(e.toString());
    }
    prefs = await SharedPreferences.getInstance();
    prefs.setString("allSongsInfos", jsonEncode(songs));
    return songs.toString();
  }

  Future<String> _getFilesFromStorage() async {
    log("GETTING FILES FROM STORAGE :( ");
    await _getFiles();

    children = songs
        .map((song) => SongListTile(
      song,
      songs,
      key: Key(song.id),
    ))
        .toList();
    return songs.toString();
  }

  Future<String> _getFilesFromPerfs() async {
    prefs = await SharedPreferences.getInstance();
    String? songsFromPref = prefs.getString("allSongsInfos");
    if (songsFromPref == null)
      return "";
    else {
      log("I WONT GET FILES FROM STORAGE THIS TIME! !! ! ! ! ! ! ");
      Iterable jsonSongs = jsonDecode(songsFromPref!);
      //TODO check if new songs are added to local storage!
      songs = List<SongInfo>.from(
          jsonSongs.map((model) => SongInfo.fromJson(model)));

      children = songs
          .map((song) => SongListTile(
                song,
                songs,
                key: Key(song.id),
              ))
          .toList();

      log("SONGS: " +
          songs.length.toString() +
          "\n\n" +
          songs.toString() +
          "\n\n");
    }
    return songs.toString();
  }
  //
  // Future<String> _initializePerfs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   String? songsFromPref = prefs.getString("allSongsInfos");
  //
  //   getSongsFromStorage = songsFromPref == null ? true : false;
  //   if (getSongsFromStorage) {
  //     log("GETTING FILES FROM STORAGE :( ");
  //     await _getFiles();
  //   } else {
  //     log("I WONT GET FILES FROM STORAGE THIS TIME! !! ! ! ! ! ! ");
  //     Iterable jsonSongs = jsonDecode(songsFromPref!);
  //     //TODO check if new songs are added to local storage!
  //     songs = List<SongInfo>.from(
  //         jsonSongs.map((model) => SongInfo.fromJson(model)));
  //   }
  //   children = songs
  //       .map((song) => SongListTile(
  //             song,
  //             songs,
  //             key: Key(song.id),
  //           ))
  //       .toList();
  //   log("SONGS: " +
  //       songs.length.toString() +
  //       "\n\n" +
  //       songs.toString() +
  //       "\n\n");
  //   return songs.toString();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_initializePerfs();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);


  void _onRefresh() async {
    setState(() {
      getSongsFromStorage = true;

    });
    // await _getFiles();
    await _getFilesFromStorage();

    _refreshController.refreshCompleted();
  }

  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),

      controller: _refreshController,
      onRefresh: _onRefresh,
      // onLoading: _onLoading,
      child: FutureBuilder<String>(
        future: getSongsFromStorage
            ? _getFilesFromStorage() // _initializePerfs()
            : _getFilesFromPerfs(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            getSongsFromStorage = false;
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ],
            ));
          } else {
            return Center(
                child: Column(
              children: [
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Loading library...'),
                )
              ],
            ));
          }

          return DraggableScrollbar.arrows(
            padding: EdgeInsets.zero,
            controller: songDragController,
            labelTextBuilder: (double offset) => Text(
              "${offset ~/ 65}",
              style: TextStyle(color: Colors.black),
            ),
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
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
