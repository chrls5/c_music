import 'dart:developer';
import 'dart:io';

import 'package:c_music/MusicPlayer/PlayingQueueModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'MusicPlayer.dart';

class SongListTile extends StatelessWidget {
  SongListTile(this.songInfo,this.songsToPlay, {Key? key}) : super(key: key);

  final SongInfo songInfo;
  final List<SongInfo> songsToPlay;

  static final  player = MusicPlayer.player;


  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
          child: songInfo.albumArtwork !=null? Image.file(
            File(songInfo.albumArtwork),
          )  : Icon(Icons.album_outlined),
          height: 50,
        ),
        title: Text(songInfo.title),
        subtitle: Text(songInfo.artist),
        trailing: Icon(Icons.more_vert),
      onTap: () => context.read<PlayingQueueModel>().setQueue(songsToPlay, songInfo),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
