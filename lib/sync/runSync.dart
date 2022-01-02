
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'Playlist.dart';



int currSong = 0;
int totalSongs = 1;

int currPls = 0;
int totalPls =1;



Future<void> showMyDialog(context) async {
  currSong = 0;
  currPls = 0;
  totalSongs=-1;
  totalPls=-1;
  bool showhidden= false;
  //controller.repeat(reverse: true);

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {

      return StatefulBuilder( builder: (context, setState){
      return AlertDialog(
        title: const Text('Sync operation'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Syncing with offline songs might take a while.'),
              Text('Would you like to continue?'),
            ],
          ),
        ),
        actions: <Widget>[
          Visibility(
            visible: !showhidden,
            child: Row(children:[
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
                  setState((){showhidden=true;                 syncOperation(setState);
                  });

                },
              ),
            ])
          ),

          Visibility(
            visible: showhidden,
            child: Column(
              children:[
                Row(children:[
                  Text("Songs: " ),
                  Spacer(),
                  Text(currSong.toString()+"/"+totalSongs.toString())
                ]),
                LinearProgressIndicator(value: currSong/totalSongs),
                SizedBox(height: 15),

                Row(children:[
                  Text("Playlists: " ),
                  Spacer(),
                  Text(currPls.toString()+"/"+totalPls.toString())
                ]),
                LinearProgressIndicator(value: currPls/totalPls),

                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () async {
                    //TODO cancel async function (if implemented on background)
                    Navigator.of(context).pop();
                  },
                ),
              ]
              )
          )
        ],
      );});
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

Future<void> syncOperation(setState) async {

  _handleSignIn();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      _currentUser = account;
      if (_currentUser != null) {
        await getPlaylists(_currentUser, setState);
      }
    });
  if (_currentUser != null) {
    await getPlaylists(_currentUser, setState);
  }
    _googleSignIn.signInSilently();



}

Future<void> getPlaylists(GoogleSignInAccount? currentUser, setState) async {
  String key = "AIzaSyAC1wAkvTMEt1gGTjrO3LX-PtcDcVmtOTg";

  const _baseUrl = 'youtube.googleapis.com';

  final Map<String, String> parameters = {
    'part': 'snippet',
    'mine': 'true',
    'key': key,
    'maxResults' : '50',
  };

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

   Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlists',
      parameters
  );

  List<dynamic> itemsPls = [];
  bool hasNextPage = true;

  do {
    Response response = await http.get(
        uri, headers: await currentUser!.authHeaders);
//  log(response.body);  //parse to json and for each cild get id and snippet (thumbnail and title)

    var resp = json.decode(response.body);
    hasNextPage = resp["nextPageToken"]!=null;

    itemsPls.addAll(resp["items"]);

    parameters["pageToken"] = resp["nextPageToken"].toString();
    uri = Uri.https(
        _baseUrl,
        '/youtube/v3/playlists',
        parameters
    );

  } while(hasNextPage);

  List<Playlist> pls = [];
  for( var x in itemsPls)
    pls.add(Playlist.fromJson(x));

  setState((){
    totalPls = pls.length;  });

  for( var x in pls) {

    setState((){
      currPls = pls.indexOf(x);
    });
    await x.syncAndDownload(setState);
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