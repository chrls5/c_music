import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:c_music/MusicPlayer/MusicPlayerExpanded.dart';
import 'package:c_music/bottomBar/BottomBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';

final  Widget myFloatingActionButton =  BottomBarLabel();
final Widget myBottomNavigationBar = MyBottomBar();
final Widget myBottomBar = BottomBar();
final MusicPlayer smallMusicPlayer = MusicPlayer();
final MusicPlayerExpanded expandedMusicPlayer = MusicPlayerExpanded();
 final  AudioPlayer player = AudioPlayer();
final FlutterAudioQuery audioQuery = FlutterAudioQuery();

class myTextWidget extends StatelessWidget{

final double minFontSize = 15;
 final double maxFontSize = 15;
final String text;
final TextStyle style;


 myTextWidget( this.text, this.style, {double? minFontSize, double? maxFontSize,});

  @override
  Widget build(BuildContext context) {
   return Expanded(child:Container(
      height: 20,
       child: AutoSizeText(
         text,
         minFontSize: minFontSize ?? 15,
         maxFontSize: maxFontSize ?? 15,
         style: style,
         overflowReplacement: Marquee(
           text: text,
           blankSpace: 20,
           accelerationCurve: Curves.easeOutCubic,
//      velocity: velocity,
           startPadding: 2.0,
           startAfter: Duration(seconds: 1),
           pauseAfterRound: Duration(seconds: 4),
           style: style,
         ),
       ))
   ) ;

  }

}

