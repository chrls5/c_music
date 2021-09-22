import 'dart:developer';
import 'dart:io';

import 'package:c_music/MusicPlayer/PlayingQueueModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

import 'MusicPlayer.dart';
import 'PlayingQueueScreen.dart';

class MusicPlayerExpanded extends StatefulWidget {
  MusicPlayerExpanded( {Key? key}) : super(key: key);

  @override
  _MusicPlayerExpandedState createState() => _MusicPlayerExpandedState();
}

class _MusicPlayerExpandedState extends State<MusicPlayerExpanded> {

  @override
  Widget build(BuildContext context) {
    return  PlayingQueue();
  }
}
