import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:c_music/MusicPlayer/MusicPlayerExpanded.dart';
import 'package:c_music/bottomBar/BottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

final  Widget myFloatingActionButton =  BottomBarLabel();
final Widget myBottomNavigationBar = MyBottomBar();
final Widget myBottomBar = BottomBar();
final MusicPlayer smallMusicPlayer = MusicPlayer();
final MusicPlayerExpanded expandedMusicPlayer = MusicPlayerExpanded();
 final  AudioPlayer player = AudioPlayer();
final FlutterAudioQuery audioQuery = FlutterAudioQuery();

