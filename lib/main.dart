import 'dart:developer';
import 'package:c_music/MusicPlayer/PlayingQueueModel.dart';
import 'package:c_music/tabs/Library.dart';
import 'package:permission_handler/permission_handler.dart';
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
        home: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currTabTitle = tabsNames[0];
@override
  void initState()  {
    // TODO: implement initState
    super.initState();
//  getPermissions();  //AUDIO QUERY DOES THIS!

}


 Future<void> getPermissions() async {
   Map<Permission, PermissionStatus> statuses = await [
   Permission.location,
       Permission.storage,
     Permission.manageExternalStorage,
   ].request();
   print( statuses[Permission.location] );
   print( statuses[Permission.storage] );
   print( statuses[Permission.manageExternalStorage] );

 }

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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(currTabTitle),
            bottom: const TabBar(
              tabs: tabs,
            ),
          ),

          //////TO DELETE? /////

          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GestureDetector(
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
          ),
          //// END OF DELETE ///

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
