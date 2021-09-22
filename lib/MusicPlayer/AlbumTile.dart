import 'package:c_music/bottomBar/BottomBar.dart';
import 'package:c_music/common/commonWidgets.dart';
import 'package:c_music/common/pageRouteTransitions.dart';
import 'package:c_music/tabs/Albums.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:c_music/MusicPlayer/SongListTile.dart';

import '../main.dart';
import '../selectedValueModel.dart';
import 'PlayingQueueModel.dart';

class AlbumTile extends StatelessWidget {
  final AlbumInfo albumInfo;

  AlbumTile(this.albumInfo, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: InkResponse(
          child: albumInfo.albumArt != null
              ? Image.file(
                  File(albumInfo.albumArt),
                )
              : Icon(
                  Icons.album_outlined,
                  size: 100,
                ),
          enableFeedback: true,
          onTap:
              () => Provider.of<SelectedValueModel>(context, listen: false).setAlbumSelected(albumInfo),
        ),
        footer: Container(
          padding: EdgeInsets.all(10),
          color: Colors.black.withOpacity(.2),
          child: Text(
            albumInfo.title + "\n" + albumInfo.artist,
            maxLines: 2,
          ),
        ));
  }
}

class AlbumSongs extends StatelessWidget {
  Widget build(BuildContext context) {
    List<SongInfo> songs = [];
    final ScrollController songDragController = ScrollController();
    List<Widget> children = [];

    Future<String> _getFiles() async {
      try {
        songs = await audioQuery.getSongsFromAlbum(
            albumId:
                Provider.of<SelectedValueModel>(context).albumSelected?.id);
      } catch (e) {
        print(e.toString());
      }
      children = songs
          .map((song) => SongListTile(
                song,
                songs,
                key: Key(song.id),
                customImage: Icon(Icons.audiotrack),
              ))
          .toList();

      // prefs.setString("allSongsInfos", jsonEncode(songs));
      return songs.toString();
    }

    return FutureBuilder<String>(
      future: _getFiles(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
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

        AlbumInfo x;

        AlbumInfo? alb = Provider.of<SelectedValueModel>(context).albumSelected;
        AlbumInfo albumInfo = alb!;
        String albumImagePath = albumInfo == null ? "none" : albumInfo.albumArt;
        int albumDuration = 0;
        for (SongInfo x in songs) albumDuration += int.parse(x.duration);


    return LayoutBuilder(builder: (context2, constraints)
        {
          return ListView(children: [
            Row(
              children: [
                Container(
                  width: 40,
                  child:   IconButton(
                      onPressed: () =>
                          Provider.of<SelectedValueModel>(context, listen: false)
                              .setAlbumSelected(null),
                      icon:Icon(Icons.arrow_back_ios, )),
padding: EdgeInsets.only(left:10),

                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 40,
                  height:  135,
                  padding: EdgeInsets.only(bottom: 20,top: 20),
                  child: Row(children: [

                    albumInfo.albumArt != null
                        ? Image.file(
                      File(albumImagePath),
                      height: 100,
                      width: 100,
                    )
                        : Icon(
                      Icons.album_outlined,
                      size: 100,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.album_outlined,
                                size: 20,
                              ),
                              Text(" " + albumInfo.title,
                                  style: TextStyle(fontSize: 15)),
                            ]),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                            ),
                            Row(children: [
                              Icon(
                                Icons.person,
                                size: 20,
                              ),
                              Text(" " + albumInfo.artist,
                                  style: TextStyle(fontSize: 15)),
                            ]),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                            ),
                            Row(children: [
                              Icon(
                                Icons.access_time,
                                size: 20,
                              ),
                              Text(
                                  " " +
                                      Duration(milliseconds: albumDuration)
                                          .toString()
                                          .split(".")[0],
                                  style: TextStyle(fontSize: 15)),
                            ]),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                            ),
                            Row(children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                              ),
                              Text(
                                  albumInfo.firstYear == null
                                      ? " -"
                                      : " " + albumInfo.firstYear.substring(0, 4),
                                  style: TextStyle(fontSize: 15)),
                            ]),
                          ]),
                    ),
                  ]),
                ),

              ],
            ),

            Divider(
              color: Colors.white,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            Row(children: [
              MaterialButton(
                  onPressed: () =>
                      context.read<PlayingQueueModel>().setQueue(
                          songs, songs[0]),
                  child: Row(children: [
                    Icon(
                      Icons.shuffle,
                      color: Colors.red,
                    ),
                    Text(" Play all")
                  ])),
              Padding(padding: EdgeInsets.only(right: 10)),
              MaterialButton(
                  onPressed: () {
                    context
                        .read<PlayingQueueModel>()
                        .setQueue(songs, songs[0], shuffleMode: true);
                  },
                  child: Row(children: [
                    Icon(
                      Icons.shuffle,
                      color: Colors.red,
                    ),
                    Text(" Shuffle all")
                  ])),
            ]),
            Container(
              height: constraints.maxHeight/7*4,
              child: DraggableScrollbar.arrows(
                padding: EdgeInsets.zero,
                controller: songDragController,
                labelTextBuilder: (double offset) =>
                    Text(
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
              ),
            )
          ]);
        });
      },
    );
  }
}
