import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:provider/provider.dart';

import 'PlayingQueueModel.dart';

class SongListTileReorderable extends StatelessWidget {
  bool isCurrent;

  var songInfo;

  SongListTileReorderable(this.songInfo,this.isCurrent,  {Key? key}) : super(key: key);

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  
  @override
  Widget build(BuildContext context) {
    List<SongInfo> songsInQueue = context.read<PlayingQueueModel>().songsInQueue;

    //bool isCurrent =currInd==songsToPlay.indexOf(songInfo);
  log("from inside: " + isCurrent.toString());

    return ListTile(
        leading: Container(
          child: songInfo.albumArtwork !=null? Image.file(
            File(songInfo.albumArtwork),
          )  : Icon(Icons.album_outlined),
          height: 50,
        ),
        title: isCurrent? Text(songInfo.title,  style:  TextStyle(color: Colors.red), maxLines: 1,): Text(songInfo.title, maxLines: 1,),
        subtitle: isCurrent? Text(songInfo.artist,  style:  TextStyle(color: Colors.red), maxLines: 1,): Text(songInfo.title, maxLines: 1,),
        trailing: ReorderableDragStartListener(
          index: songsInQueue.indexOf(songInfo),
          child: const Icon(Icons.drag_handle),
        ),
        //Icon(Icons.more_vert),
      onTap: () => context.read<PlayingQueueModel>().playIndexInQueue( songInfo),

      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

