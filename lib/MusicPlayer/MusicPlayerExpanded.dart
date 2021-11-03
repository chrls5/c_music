
import 'package:flutter/material.dart';

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
