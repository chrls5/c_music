import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';

import 'YoutubeVideo.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';


 // TextEditingController videoURL = new TextEditingController();
  late Result video;
  bool isFetching = false;
  bool fetchSuccess = false;
  bool isDownloading = false;
  bool downloadsuccess = false;
  String status = "Download ";
  String progress = "";

  Future<void> downloadSong(String videoURL)  async {
    log("GETINFO STARTED");
    await getInfo(videoURL);
    log("DIRECTURI STARTED");
    await directURI(video.id, video.vid, video.ajax, video.ftype,
        video.fquality);
    log("Direct URI stopped");

    // var response = await http.get(Uri.parse("https://api.download-lagu-mp3.com/@api/json/mp3/eIqkS_lTZZI"));
    // log(response.body);


    // var resp = await http.get(Uri.parse("https://youtube.googleapis.com/youtube/v3/videos?part=snippet&id=CevxZvSJLk8&key=AIzaSyAC1wAkvTMEt1gGTjrO3LX-PtcDcVmtOTg"));
    // log(resp.body);
    // print("started");
    //
    // final result = await FlutterYoutubeDownloader.downloadVideo(
    //     videoURL, "Video Title goes Here.mp3", 18);
    //
    // print(result);
    // print("finished");


  }

  Map<String, String> headers = {
    "X-Requested-With": "XMLHttpRequest",
  };

  late Map<String, String> body;

  void insertBody(String videoURL) {
    body = {"url": videoURL, "ajax": "1"};
  }

  //----------------------------------Get Video Info

  Future<void> getInfo(String videoURL) async {
    insertBody(videoURL);
    progress = "";
    status = "Download";
    downloadsuccess = false;
    isDownloading = false;
    isFetching = true;
    fetchSuccess = false;
    try {
      var response = await http.post(
          Uri.parse("https://y2mate.com/fr/analyze/ajax"),
          body: body,
          headers: headers);
      print(response.body);
      video = Result.convertResult(response.body);
      print("Results: " + video.audioName);
      isFetching = false;
      fetchSuccess = true;
    } catch (e) {
      log("Exiting ");
      exit(0);
      print(e.toString());
      isFetching = true;
      fetchSuccess = false;
    }
    print("${video.thumbnail}\n${video.audioName}\n${video.vid}\n${video.id}");
  }

  //----------------------------------Get Download Link

  Future<void> directURI(
      String _id, String vid, String ajax, String ftype, String quality) async {
    isDownloading = true;
    status = "Downloading ...";
    try {
      var bodies = {
        "type": "youtube",
        "_id": _id,
        "v_id": vid,
        "ajax": ajax,
        "ftype": ftype.replaceAll(".", ""),
        "fquality": quality,
      };
      var response = await http.post(Uri.parse("https://y2mate.com/fr/convert"),
          body: bodies);
      print(response.body);
      if (response.body.contains("Error:")) {
        Fluttertoast.showToast(
          msg: "Cant Download Now \n Please Try Later ...",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
        isDownloading = false;
        return;
      }
      var directURL = RegExp(r'<a href=\\"(.*?)\\"')
          .firstMatch(response.body)
          ?.group(1)
          ?.replaceAll("\\", "");
      print("FIle Link :" + directURL!);
      downloadVideo(directURL, video.audioName, video.ftype);
    } catch (e) {
      isDownloading = false;
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red[300],
        textColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

//----------------------------------Download Video
  Future<void> downloadVideo(
      String trackURL, String trackName, String format) async {
    try {
      Dio dio = Dio();

      var directory = await getApplicationDocumentsDirectory();
      print("${directory.path}/" + trackName + format);
      await dio.download(trackURL, "${directory.path}/" + trackName + format,
          onReceiveProgress: (rec, total) {
        progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
      });

      isDownloading = false;
      status = "Download Done ^_^";
      downloadsuccess = true;
    } catch (e) {
      isDownloading = false;
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red[300],
        textColor: Colors.black,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

