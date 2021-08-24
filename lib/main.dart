import 'dart:developer';
import 'package:c_music/MusicPlayer/PlayingQueueModel.dart';
import 'package:provider/provider.dart';

import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'bottomBar/BottomBar.dart';
import 'common/MyTheme.dart';
import 'tabs/tabs.dart';

import 'package:flutter_audio_query/flutter_audio_query.dart';

ThemeData _light = ThemeData.light().copyWith(
  primaryColor: Colors.green,
);
ThemeData _dark = ThemeData.dark().copyWith(
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  bottomAppBarColor: Colors.black,
   indicatorColor: Colors.red,
   colorScheme: ColorScheme.dark().copyWith(
primary: Colors.red //Colors.tealAccent
   ),
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool _isDark = true;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayingQueueModel>(create: (context)=>PlayingQueueModel())
      ],
      child:MaterialApp(
        title: 'C_Music',
        darkTheme: _dark,
        theme: _light,
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home: MyHomePage(title: 'C_Music'),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currTabTitle = tabsNames[0];

  @override
  Widget build(BuildContext context) {
    return
      DefaultBottomBarController(
      child:DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          setState(() {
            currTabTitle = tabsNames[tabController.index];
          });
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: Text(currTabTitle),
            bottom: const TabBar(
              tabs: tabs,
            ),
          ),
          // Actual expandable bottom bar
          bottomNavigationBar: MyFloatingButton(),
          body: TabBarView(
            children: tabsBody,
          ),
        );
      }),
    )
      );
  }
}
