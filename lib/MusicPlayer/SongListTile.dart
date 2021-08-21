import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

import 'MusicPlayer.dart';

class SongListTile extends StatefulWidget {
  SongListTile(this.songInfo,this.songsToPlay, {Key? key}) : super(key: key);

  final SongInfo songInfo;
  final List<SongInfo> songsToPlay;

  @override
  _SongListTileState createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  static final  player = MusicPlayer.player;


  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Container(
          child: widget.songInfo.albumArtwork !=null? Image.file(
            File(widget.songInfo.albumArtwork),
          )  : Icon(Icons.album_outlined),
          height: 50,
        ),
        title: Text(widget.songInfo.title),
        subtitle: Text(widget.songInfo.artist),
        trailing: Icon(Icons.more_vert),
      onTap: ()  {
       //   player.setFilePath(widget.songInfo.filePath);
        //  player.setAudioSource(AudioSource.uri(Uri(path: widget.songInfo.filePath)));
          player.setAudioSource(
            ConcatenatingAudioSource(
              // Start loading next item just before reaching it.
              useLazyPreparation: true, // default
              // Customise the shuffle algorithm.
              shuffleOrder: DefaultShuffleOrder(), // default
              // Specify the items in the playlist.
              children: widget.songsToPlay.map((song)=> AudioSource.uri(Uri.parse(song.filePath))).toList(),

            ),
            // Playback will be prepared to start from track1.mp3
            initialIndex: widget.songsToPlay.indexOf(widget.songInfo), // default
            // Playback will be prepared to start from position zero.
            initialPosition: Duration.zero, // default
          );


          player.play();
  },
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
