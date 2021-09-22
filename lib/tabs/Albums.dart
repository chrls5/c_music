import 'dart:convert';
import 'dart:developer';

import 'package:c_music/common/commonWidgets.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:c_music/MusicPlayer/SongListTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:c_music/MusicPlayer/AlbumTile.dart';

import '../selectedValueModel.dart';
import 'Library.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  static _AlbumsState state = _AlbumsState();

  void setSelectedAlbum() {

  }
  @override
  State<Albums> createState() => state;
}


class _AlbumsState extends State<Albums> with AutomaticKeepAliveClientMixin {
  late List<AlbumInfo> albums;
  List<Widget> children = [];
  bool getFromStorage = true;
  late SharedPreferences prefs;

  final ScrollController songDragController = ScrollController();

  Future<String> _getFiles() async {
    try {
      albums = await audioQuery.getAlbums();
    } catch (e) {
      print(e.toString());
    }
    prefs.setString("allAlbumsInfos", jsonEncode(albums));
    return albums.toString();
  }

  Future<String> _initializePerfs() async {
    prefs = await SharedPreferences.getInstance();
    String? songsFromPref = null;//prefs.getString("allAlbumsInfos");

    getFromStorage = songsFromPref == null ? true : false;
    if (!getFromStorage) {
      log("I WONT GET FILES FROM STORAGE THIS TIME! !! ! ! ! ! ! ");
      Iterable jsonSongs = jsonDecode(songsFromPref!);
      //TODO check if new albums are added to local storage!
      albums = List<AlbumInfo>.from(
          jsonSongs.map((model) => AlbumInfo.fromJson(model)));
    } else {
      log("GETTING FILES FROM STORAGE :( ");
      await _getFiles();
    }
    log(albums.toString());
    children = albums.map((song) => AlbumTile(
      song,
      key: Key(song.id),
    )).toList();
    log("albums: " +
        albums.length.toString() +
        "\n\n" +
        albums.toString() +
        "\n\n");
    return albums.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_initializePerfs();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getFromStorage
          ? _initializePerfs()
          : null, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          getFromStorage = false;
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
                    child: Text('Loading Albums...'),
                  )
                ],
              ));
        }

        return context.watch<SelectedValueModel>().albumSelected!=null  ? AlbumSongs() :
        GridView.count(

            crossAxisCount: 2,
            children: children,
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
