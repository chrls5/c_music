import 'dart:developer';
import 'dart:math';

import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:c_music/MusicPlayer/SongListTileOrderable.dart';
import 'package:c_music/common/commonWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

import 'SongListTile.dart';

class PlayingQueueModel extends ChangeNotifier{

   List<SongInfo> songsInQueue = [];
    int currIndexPlaying = -1;
ScrollController queueScrollCntrl = ScrollController(initialScrollOffset: (70.0 * (player.currentIndex ??0.0) ), );


  void setQueue(List<SongInfo> songsToQueue, SongInfo songToPlay, {bool? shuffleMode}){
     songsInQueue = songsToQueue;
     int newInd = songsToQueue.indexOf(songToPlay);

     setAudioSourceQueue(songsToQueue, newInd, shuffleMode);
     queueScrollCntrl.jumpTo(70.0 * newInd - 3*70);
     notifyListeners();

      print("SHUFFLE: " + player.shuffleModeEnabled.toString());
  }

  void setCurrIndex(int newInd){
    currIndexPlaying = newInd;
    notifyListeners();
  }

  void reorderPlayingQueue(int oldIndex, int newIndex){
    MusicPlayer.queueSource.move(oldIndex, newIndex);
    final SongInfo item = songsInQueue.removeAt(oldIndex);
    songsInQueue.insert(newIndex, item);
    notifyListeners();

  }
  void setAudioSourceQueue(List<SongInfo> songsToQueue, int newInd, bool? shuffleMode){
    MusicPlayer.queueSource = ConcatenatingAudioSource(
      // Start loading next item just before reaching it.
      useLazyPreparation: true, // default
      // Customise the shuffle algorithm.
      shuffleOrder: DefaultShuffleOrder(), // default
      // Specify the items in the playlist.
      children: songsToQueue.map((song)=> AudioSource.uri(Uri.file(song.filePath))).toList(),

    );

    int? index = newInd;
    if(shuffleMode!=null && shuffleMode==true) {
      print("HERERERERERE \n\n\n\n\n\n\n");
      player.setShuffleModeEnabled(true);
      player.shuffle();
      index = MusicPlayer.queueSource.shuffleIndices[0];
    }
    else
      player.setShuffleModeEnabled(false);


    player.setAudioSource(
      MusicPlayer.queueSource,
      // Playback will be prepared to start from track1.mp3
      initialIndex: index, // default
      // Playback will be prepared to start from position zero.
      initialPosition: Duration.zero, // default
    );

    player.play();
  }

  void playIndexInQueue(SongInfo songToPlay){
    int newInd  = songsInQueue.indexOf(songToPlay);
    if(newInd ==-1)
      return;

    player.setAudioSource(
      MusicPlayer.queueSource,
      initialIndex:newInd, //only this changes!
      initialPosition: Duration.zero,
    );

        player.play();
  }



  }
