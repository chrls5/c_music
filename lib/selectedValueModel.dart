import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SelectedValueModel extends ChangeNotifier {

   AlbumInfo? albumSelected =null;

  void setAlbumSelected(selectedVal){
    this.albumSelected = selectedVal;
    notifyListeners();
  }


}
