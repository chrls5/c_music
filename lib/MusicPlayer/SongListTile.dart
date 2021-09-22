import 'dart:developer';
import 'dart:io';

import 'package:c_music/MusicPlayer/PlayingQueueModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'MusicPlayer.dart';

class SongListTile extends StatelessWidget {
  final customImage ;

  SongListTile(this.songInfo,this.songsToPlay, {Key? key, this.customImage}) : super(key: key);

  final SongInfo songInfo;
  final List<SongInfo> songsToPlay;



  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
          child: customImage==null? songInfo.albumArtwork !=null? Image.file(
            File(songInfo.albumArtwork),
          )  : Icon(Icons.album_outlined) :customImage ,
          height: 50,
        ),
        title: Text(songInfo.title, maxLines: 1,),
        subtitle: Text(songInfo.artist, maxLines: 1,),
        trailing: Icon(Icons.more_vert),
      onTap: () => context.read<PlayingQueueModel>().setQueue(songsToPlay, songInfo),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
