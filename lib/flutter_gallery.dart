// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gallery/media_grid.dart';
import 'package:photo_manager/photo_manager.dart';

class FlutterGallery {
  static const MethodChannel _channel =
      const MethodChannel('flutter_gallery');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<AssetEntity>> pickGallery({
    @required BuildContext context,
    @required String title,
    @required  Color color,
  }) async {
    List<AssetEntity> result;

    await showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.965,
          child: Scaffold(
            body: MediaGrid(
              // CONSUME SELECTED ITEMS HERE, FOR EXAMPLE
              title: title,
              color: color,
              onItemsSelected: (assets) {
                result = assets;
//                print("received ${assets?.length}");
                Navigator.pop(context);
              },
            ),
          ),
        ));
    return result;
  }

}
