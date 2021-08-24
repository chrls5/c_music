

import 'dart:developer';

import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:c_music/MusicPlayer/PlayingQueueModel.dart';
import 'package:c_music/MusicPlayer/SongListTileOrderable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';

import 'SongListTile.dart';

class PlayingQueue extends StatefulWidget   {

  _PlayingQueueState createState() => _PlayingQueueState();
}

class _PlayingQueueState extends State<PlayingQueue> with AutomaticKeepAliveClientMixin {

  late List<Widget> children;

  Widget build(BuildContext context) {
    // Consumer<PlayingQueueModel>(
    // )
    List<SongInfo> songsInQueue = context.read<PlayingQueueModel>().songsInQueue;
    int sizeQ = songsInQueue.length;

    children = songsInQueue.map((song) => SongListTileReorderable(song, songsInQueue, key: Key(song.id),)).toList();

    return sizeQ == 0 ? Text("Empty Queue") : ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          Provider.of<PlayingQueueModel>(context, listen: false).reorderPlayingQueue(oldIndex, newIndex);
      },
      buildDefaultDragHandles: true,

      children: children,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
