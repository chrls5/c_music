

import 'dart:developer';

import 'package:c_music/MusicPlayer/PlayingQueueModel.dart';
import 'package:c_music/MusicPlayer/SongListTileOrderable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';


class PlayingQueue extends StatefulWidget   {

  _PlayingQueueState createState() => _PlayingQueueState();
}

class _PlayingQueueState extends State<PlayingQueue> with AutomaticKeepAliveClientMixin {

  late List<Widget> children;

  Widget build(BuildContext context) {
    List<SongInfo> songsInQueue = context.watch<PlayingQueueModel>().songsInQueue;
    int sizeQ = songsInQueue.length;

     ScrollController myCntroler = context.read<PlayingQueueModel>().queueScrollCntrl;
    int currInd = context.read<PlayingQueueModel>().currIndexPlaying;
    log("something changed?");
    children = songsInQueue.map((song) => SongListTileReorderable(song, songsInQueue.indexOf(song)==currInd, key: Key(song.id),)).toList();

    return sizeQ == 0 ? Text("Empty Queue") :

    ReorderableListView.builder(
      scrollController: myCntroler,
      itemCount: children.length,
      itemExtent: 70,
      itemBuilder: (context, index) {
        return children[index];
      },  onReorder: (int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      Provider.of<PlayingQueueModel>(context, listen: false).reorderPlayingQueue(oldIndex, newIndex);
    },
    );

    // ReorderableListView(
    //   onReorder: (int oldIndex, int newIndex) {
    //     if (oldIndex < newIndex) {
    //       newIndex -= 1;
    //     }
    //     Provider.of<PlayingQueueModel>(context, listen: false).reorderPlayingQueue(oldIndex, newIndex);
    //   },
    //   scrollController:myCntroler,//queueScrollCntrl,//ScrollController(initialScrollOffset: (70.0 * currInd))   ,
    //   buildDefaultDragHandles: true,
    //   children: children,
    //   padding: EdgeInsets.all(15),
    //
    // )
    // ;

  }

  @override
  bool get wantKeepAlive => true;
}
