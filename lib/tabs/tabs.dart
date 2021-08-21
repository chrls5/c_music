import 'package:c_music/tabs/Albums.dart';
import 'package:c_music/tabs/Artists.dart';
import 'package:c_music/tabs/Genres.dart';
import 'package:c_music/tabs/Library.dart';
import 'package:c_music/tabs/Playlists.dart';
import 'package:c_music/tabs/YTMusic.dart';
import 'package:flutter/material.dart';

const List<String> tabsNames = [
  "Library", "Albums", "Artists", "Genres", "Playlists", "YT Music"
];

const List<Widget> tabsBody = <Widget>[
  Library(),
  Albums(),
  Artists(),
  Genres(),
  Playlists(),
  YTMusic()
  ];

const List<Tab> tabs = <Tab>[
  Tab(icon: Icon(Icons.music_note,color: Colors.white)),
  Tab( icon: Icon(Icons.album,color: Colors.white)),
  Tab( icon: Icon(Icons.person,color: Colors.white)),
  Tab( icon: Icon(Icons.sell,color: Colors.white)),
  Tab( icon: Icon(Icons.my_library_music,color: Colors.white)),
  Tab( child: Text('YM', style: TextStyle(fontSize: 19, color: Colors.white),),),

];