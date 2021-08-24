import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

import 'MusicPlayer.dart';
import 'PlayingQueueModel.dart';
import 'package:provider/provider.dart';

class SongListTileReorderable extends StatelessWidget {
  var songsToPlay;

  var songInfo;

  SongListTileReorderable(this.songInfo,this.songsToPlay,  {Key? key}) : super(key: key);

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  static final  player = MusicPlayer.player;
  
  
  @override
  Widget build(BuildContext context) {
    int currInd = context.read<PlayingQueueModel>().currIndexPlaying;
    //List<SongInfo> songsInQueue = context.read<PlayingQueueModel>().songsInQueue;

    bool isCurrent =currInd==songsToPlay.indexOf(songInfo);
  log("from inside: " + currInd.toString());

    return ListTile(
        leading: Container(
          child: songInfo.albumArtwork !=null? Image.file(
            File(songInfo.albumArtwork),
          )  : Icon(Icons.album_outlined),
          height: 50,
        ),
        title: isCurrent? Text(songInfo.title,  style:  TextStyle(color: Colors.red),): Text(songInfo.title),
        subtitle: isCurrent? Text(songInfo.artist,  style:  TextStyle(color: Colors.red),): Text(songInfo.title),
        trailing: ReorderableDragStartListener(
          index: songsToPlay.indexOf(songInfo),
          child: const Icon(Icons.drag_handle),
        ),
        //Icon(Icons.more_vert),
      onTap: ()  {

          //TODO Since we are in Queue we dont need to replace current Queue
        // just play the indexed-tapped song
        //Also set as current
         // player.play();
  },
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

