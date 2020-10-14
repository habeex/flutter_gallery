import 'package:photo_manager/photo_manager.dart';

class MediaOption {
  AssetEntity asset;
  int selectedPosition;
  dynamic thumb;

  MediaOption({this.asset, this.thumb});
}

class MediaAlbum {
  String name;
  int assetCount;

  MediaAlbum({this.name, this.assetCount});
}
