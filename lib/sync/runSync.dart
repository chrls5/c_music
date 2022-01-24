import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:c_music/common/commonWidgets.dart';
import 'package:c_music/sync/downloadFromYT.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Playlist.dart';

import 'package:easy_folder_picker/DirectoryList.dart';
import 'package:easy_folder_picker/FolderPicker.dart';

int currSong = 0;
int totalSongs = 1;
int currProcc = 0;

int currPls = 0;
int totalPls = 1;
String currentPls ="", currentSong="";

Future<String> _getPathToDownload() async {
  var status = await Permission.storage.status;
  Permission.manageExternalStorage.request();
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  return ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_MUSIC);
}

Future<void> showMyDialog(context) async {

   currentPls ="";
   currentSong="";

  currSong = 0;
  currPls = 0;
  currProcc = 0;
  totalSongs = -1;
  totalPls = -1;
  bool showhidden = false;
  //controller.repeat(reverse: true);
  String selectedDirectory = await _getPathToDownload();

  Future<String> _pickDirectory(BuildContext context) async {
    Directory directory = Directory(selectedDirectory);
    if (directory == null) {
      directory = Directory(FolderPicker.ROOTPATH);
    }

    Directory? newDirectory = await FolderPicker.pick(
        allowFolderCreation: true,
        context: context,
        rootDirectory: directory,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))));


    return  newDirectory == null ? selectedDirectory : newDirectory.path;

  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Sync operation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: !showhidden? <Widget>[
                Text('Syncing with offline songs might take a while.'),
                Text('Would you like to continue?'),
                Text("Current path:" + selectedDirectory),
                TextButton(
                    onPressed: ()  async {
                      String tempd = await _pickDirectory(context);
                      setState(()  {
                        selectedDirectory = tempd;
                      });
                      print(selectedDirectory);
                    } ,
                    child: Text("Choose")),
                
                TextButton(
                  child: Text("Test"),
                  onPressed: () => downloadSong("https://www.youtube.com/watch?v=yXdqXvB7FX8"),
                )
              ] : <Widget>[Text("Sync started...")],
            ),
          ),
          actions: <Widget>[
            Visibility(
                visible: !showhidden,
                child: Row(children: [
                  TextButton(
                    child: const Text('Back'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Spacer(),
                  TextButton(
                    child: const Text('Start'),
                    onPressed: () {
                      setState(() {
                        showhidden = true;
                        syncOperation(setState, selectedDirectory);
                      });
                    },
                  ),
                ])),
            Visibility(
                visible: showhidden,
                child: Column(children: [
                  Row(children: [
                    Text("Current: " + currentSong),
                    Spacer(),
                    Text(currProcc.toString() + "/100")
                  ]),
                  LinearProgressIndicator(value: currProcc / 100),
                  SizedBox(height: 15),
                  Row(children: [
                    Text("Songs: "),
                    Spacer(),
                    Text(currSong.toString() + "/" + totalSongs.toString())
                  ]),
                  LinearProgressIndicator(value: currSong / totalSongs),
                  SizedBox(height: 15),
                  Row(children: [
                    Text("Playlists: ${currentPls}"),
                    Spacer(),
                    Text(currPls.toString() + "/" + totalPls.toString())
                  ]),
                  LinearProgressIndicator(value: currPls / totalPls),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () async {
                      //TODO cancel async function (if implemented on background)
                      Navigator.of(context).pop();
                    },
                  ),
                ]))
          ],
        );
      });
    },
  );
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'https://www.googleapis.com/auth/youtube',
  ],
);

GoogleSignInAccount? _currentUser;

Future<void> syncOperation(setState, String selectedDir) async {
  _handleSignIn();

  _googleSignIn.onCurrentUserChanged
      .listen((GoogleSignInAccount? account) async {
    _currentUser = account;
    if (_currentUser != null) {
      await getPlaylists(_currentUser, setState,selectedDir);
    }
  });
  if (_currentUser != null) {
    await getPlaylists(_currentUser, setState,selectedDir);
  }
  _googleSignIn.signInSilently();
}

Future<void> getPlaylists(GoogleSignInAccount? currentUser, setState, String selectedDir) async {
  String key = "AIzaSyAC1wAkvTMEt1gGTjrO3LX-PtcDcVmtOTg";

  const _baseUrl = 'youtube.googleapis.com';

  final Map<String, String> parameters = {
    'part': 'snippet',
    'mine': 'true',
    'key': key,
    'maxResults': '50',
  };

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  Uri uri = Uri.https(_baseUrl, '/youtube/v3/playlists', parameters);

  List<dynamic> itemsPls = [];
  bool hasNextPage = true;

  do {
    Response response =
        await http.get(uri, headers: await currentUser!.authHeaders);
//  log(response.body);  //parse to json and for each cild get id and snippet (thumbnail and title)

    var resp = json.decode(response.body);
    hasNextPage = resp["nextPageToken"] != null;

    itemsPls.addAll(resp["items"]);

    parameters["pageToken"] = resp["nextPageToken"].toString();
    uri = Uri.https(_baseUrl, '/youtube/v3/playlists', parameters);
  } while (hasNextPage);

  List<Playlist> pls = [];
  for (var x in itemsPls) pls.add(Playlist.fromJson(x));

  setState(() {
    totalPls = pls.length;
  });

  for (var x in pls) {
    setState(() {
      currPls = pls.indexOf(x);
      currentPls = x.title;
    });

    await x.syncAndDownload(setState, selectedDir);
  }

  log(pls.length.toString());
  log(pls[0].toString());
  log("done");
}

Future<void> _handleSignOut() => _googleSignIn.disconnect();

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}
