import 'dart:developer';

import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:c_music/MusicPlayer/MusicPlayerExpanded.dart';
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
              RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
          expandedBackColor: Theme.of(context).bottomAppBarColor,
          expandedBody: Center(
            child: expandedMusicPlayer//Text("Queue"),
          ),
          bottomAppBarBody: Container(
                color: Colors.black54,
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
      onVerticalDragUpdate: (dragUpdateDetails){
        DefaultBottomBarController.of(context).onDrag(dragUpdateDetails);
      },

      onVerticalDragEnd: (dragUpdateDetails){
        DefaultBottomBarController.of(context).onDragEnd(dragUpdateDetails);
        log("hahaha");
      },

      //DefaultBottomBarController.of(context).onDragEnd,
      child:  widget.myBottomBar,
    );
  }
}


