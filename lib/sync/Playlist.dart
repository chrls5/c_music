import 'dart:developer';
import 'dart:io';
import 'package:c_music/sync/runSync.dart';
import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_edit/on_audio_edit.dart';
import 'Song.dart';

class Playlist {
  String title;
  String id;
  String thumnUrl;

  Playlist(this.title, this.id, this.thumnUrl);

  factory Playlist.fromJson(dynamic json) {
    var snippet = json['snippet'];
    return Playlist(snippet["title"] as String, json['id'] as String,
        snippet["thumbnails"]["default"]["url"] as String);
  }

  @override
  String toString() {
    return '{ ${this.title}, ${this.id},  ${this.thumnUrl} }';
  }


  Future<String> _getPathToDownload() async {

    var status = await Permission.storage.status;
    Permission.manageExternalStorage.request();
  if (!status.isGranted) {
    await Permission.storage.request();
  }

    return ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_MUSIC);
  }


  Future<void> syncAndDownload(setState) async {
    List<Song> songs;


    final String base_path = await _getPathToDownload();
    log(base_path);

    var yt = YoutubeExplode();


// Get playlist metadata.
    var playlist = await yt.playlists.get(this.id);

    var title = playlist.title;
    var author = playlist.author;

    await for (var video in yt.playlists.getVideos(playlist.id)) {
      var videoTitle = video.title;
      var videoAuthor = video.author;
    }

    var playlistVideos = await yt.playlists.getVideos(playlist.id).toList();
    int count = 0;
    final OnAudioEdit _audioEdit = OnAudioEdit();

    totalSongs = playlistVideos.length;
    for (var song in playlistVideos) {
      // Get the video manifest.
      var manifest = await yt.videos.streamsClient.getManifest(song.id);
    //  var streams = manifest.videoOnly;
      var streamInfo = manifest.audioOnly.first;


      setState((){
        currSong = ++count;

      });
      log("syncing: " + (count).toString() + "/" + playlistVideos.length.toString());

      if (streamInfo != null) {
        // Get the actual stream
        var stream = yt.videos.streamsClient.get(streamInfo);

        String path = base_path+ "/cmusic_test/"+ this.title;
        String name =  song.author+"-"+song.title+".mp3";
        String full_path = path + "/" + name;
        log(full_path);
        // Open a file for writing.
        var exists = await File(full_path).exists();
        if(exists)
          continue;

      //  var file = await new File(path).create(recursive: true);

        new Directory(path)
            .createSync(recursive: true);

       File file =  await new File(full_path).create(recursive: true);


        var fileStream = file.openWrite();

          log(song.toString());



        // Pipe all the content of the stream into the file.
        await stream.pipe(fileStream);

        // Close the file.
        await fileStream.flush();
        await fileStream.close();

        //
        // Map<TagType, dynamic> tags = {
        //   TagType.TITLE: song.title,
        //   TagType.ARTIST: song.author
        // };
        // bool songf = await _audioEdit.editAudio(path, tags);
        // print(songf); //True or False

      }


    }
  }
}
