import 'package:c_music/MusicPlayer/MusicPlayer.dart';
import 'package:flutter/cupertino.dart';

class Albums extends StatelessWidget {
  const Albums({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MusicPlayer.myQueue;
  }
}