
import 'package:c_music/common/commonWidgets.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return  BottomExpandableAppBar(
          horizontalMargin: 0,
          appBarHeight: 150,
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(side: BorderSide(width: 16.0, color: Colors.lightBlue.shade50),), StadiumBorder(side: BorderSide(color: Colors.red, width: 23))),
          expandedBackColor: Colors.grey[850],//Theme.of(context).bottomAppBarColor,
          expandedBody: Container(child: Center(child:expandedMusicPlayer),padding: EdgeInsets.only(bottom: 150+10,left:10,right:10, top:10 ),),// PlayingQueue(),//Center(child:MusicPlayer.myQueue),
          bottomAppBarBody: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(8.0),
                child: smallMusicPlayer
            ),

        );
  }
}


class MyBottomBar extends StatefulWidget{
  @override
 _MyBottomBarState createState()=>_MyBottomBarState();

}
class _MyBottomBarState extends State<MyBottomBar>{

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onVerticalDragUpdate:      DefaultBottomBarController.of(context).onDrag,
      onVerticalDragEnd:         DefaultBottomBarController.of(context).onDragEnd,
      //DefaultBottomBarController.of(context).onDragEnd,
      child:  myBottomBar,
    );
  }
}


class BottomBarLabel extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
 return GestureDetector(
   //
   // Set onVerticalDrag event to drag handlers of controller for swipe effect
   onVerticalDragUpdate: DefaultBottomBarController.of(context).onDrag,
   onVerticalDragEnd: DefaultBottomBarController.of(context).onDragEnd,
   child: FloatingActionButton.extended(
     label: AnimatedBuilder(
       animation: DefaultBottomBarController.of(context).state,
       builder: (context, child) => Row(
         children: [
           Text(
               "Queue"
           ),
           const SizedBox(width: 4.0),
           AnimatedBuilder(
             animation: DefaultBottomBarController.of(context).state,
             builder: (context, child) => Transform(
               alignment: Alignment.center,
               transform: Matrix4.diagonal3Values(
                 1,
                 DefaultBottomBarController.of(context).state.value * 2 - 1,
                 1,
               ),
               child: child,
             ),
             child: RotatedBox(
               quarterTurns: 1,
               child: Icon(
                 Icons.chevron_right,
                 size: 20,
               ),
             ),
           ),
         ],
       ),
     ),
     elevation: 2,
     backgroundColor: Colors.red,
     foregroundColor: Colors.white,
     //
     //Set onPressed event to swap state of bottom bar
     onPressed: () => DefaultBottomBarController.of(context).swap(),
   ),
 );

  }

}
