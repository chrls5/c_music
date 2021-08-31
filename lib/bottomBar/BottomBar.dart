import 'dart:developer';

import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:c_music/MusicPlayer/MusicPlayerExpanded.dart';
import 'package:c_music/MusicPlayer/PlayingQueueScreen.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  static MusicPlayer smallMusicPlayer = MusicPlayer();
  static MusicPlayerExpanded expandedMusicPlayer = MusicPlayerExpanded();

  @override
  Widget build(BuildContext context) {

    return  BottomExpandableAppBar(
          horizontalMargin: 0,
          appBarHeight: 150,
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(side: BorderSide(width: 16.0, color: Colors.lightBlue.shade50),), StadiumBorder(side: BorderSide(color: Colors.red, width: 23))),
          expandedBackColor: Colors.grey[850],//Theme.of(context).bottomAppBarColor,
          expandedBody: Center(child:expandedMusicPlayer),// PlayingQueue(),//Center(child:MusicPlayer.myQueue),
          bottomAppBarBody: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(8.0),
                child: smallMusicPlayer
            ),

        );
  }
}


class MyFloatingButton extends StatefulWidget{
  @override
 _MyFloatingButtonState createState()=>_MyFloatingButtonState();

  BottomBar myBottomBar = BottomBar();

}
class _MyFloatingButtonState extends State<MyFloatingButton>{
  static final  player = MusicPlayer.player;


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onVerticalDragUpdate:      DefaultBottomBarController.of(context).onDrag,
      onVerticalDragEnd:         DefaultBottomBarController.of(context).onDragEnd,
      //DefaultBottomBarController.of(context).onDragEnd,
      child:  widget.myBottomBar,
    );
  }
}


