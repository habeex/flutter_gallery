import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'media_option.dart';

class MediaGrid extends StatefulWidget {
  final ValueChanged<List<AssetEntity>> onItemsSelected;
  final String title;
  final Color color;
  final int limit;
  MediaGrid({this.onItemsSelected, this.title, this.color, this.limit});

  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<MediaOption> allMedia = [];
  List<MediaOption> selectedMedia = [];
  int currentPage = 0;
  int selectedMediaCount = 0;
  int lastPage;

  bool isFetching = false;
  bool loadedInitial = false;

  List<MediaAlbum> allAlbums = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (allMedia.isEmpty && !loadedInitial) {
      _fetchNewMedia();
      loadedInitial = true;
    }
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    setState(() => isFetching = true);

    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();

    if (result) {
      // GET ALBUMS
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(onlyAll: true);

      allAlbums.addAll(
        albums.map((e) => MediaAlbum(
              assetCount: e.assetCount,
              name: Platform.isIOS ? e.name : e.name,
            )),
      );

      List<AssetEntity> media = albums.length > 0 ? await albums[0].getAssetListPaged(currentPage, 60) : [];

      for (var asset in media) {
        final thumb = await asset.thumbDataWithSize(200, 200);
        final mediaOption = MediaOption(asset: asset, thumb: thumb);

        allMedia.add(mediaOption);
      }

      setState(() {
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  String _showDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return twoDigits(duration.inHours) != '00'
        ? "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
        : twoDigitMinutes != '00' ? "$twoDigitMinutes:$twoDigitSeconds" : "0:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    selectedMediaCount = 0;
    if (isFetching && allMedia.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
           Visibility(
             visible: selectedMedia.length > 0,
             child: Container(
                 margin: EdgeInsets.only(top: 15, bottom: 15, right: 10),
                 padding: EdgeInsets.symmetric(horizontal: 6),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20),
                   color: Colors.white,
                 ),
                 child: Center(
                   child: Text(
                     "${selectedMedia.length}",
                     style: TextStyle(color: widget.color, fontWeight: FontWeight.bold),
                   ),
                 )),
           )
        ],
      ),
      floatingActionButton: selectedMedia.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () => widget.onItemsSelected(selectedMedia.map((e) => e.asset).toList()),
              child: Icon(Icons.check),
            ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scroll) {
                _handleScrollEvent(scroll);
                return;
              },
              child: GridView.builder(
                  itemCount: allMedia.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    int selectedPosition = 0;
                    if(selectedMedia.contains(allMedia[index])){
                      selectedMediaCount++;
                      selectedPosition = selectedMediaCount;
                    }

                    return mediaItem(allMedia[index], selectedPosition: selectedPosition);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget mediaItem(MediaOption media, {int selectedPosition}) {
    return InkWell(
      onTap: () {
        setState(() {
          if (selectedMedia.contains(media)) {
            selectedMedia.remove(media);
          } else {
            if(selectedMedia.length < widget.limit){
              selectedMedia.add(media);
            }else{
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Maximum of ${widget.limit}"),
              ));
            }
          }
        });
      },
      child: Stack(
        children: <Widget>[
          Stack(
            key: ValueKey(media.asset.id),
            children: <Widget>[
              Positioned.fill(
                child: Image.memory(
                  media.thumb,
                  fit: BoxFit.cover,
                ),
              ),
              media.asset.type == AssetType.video ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5, bottom: 5),
                  child: Text(
                    "${_showDuration(media.asset.videoDuration)}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ) : Container(),
            ],
          ),
          selectedMedia.contains(media) ? Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Container(
                color: Colors.white54,
              )),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 25,
                          height: 25,
                          color: widget.color,
                          child: Center(
                            child: Icon(Icons.check, color: Colors.white)
//                            Text("$selectedPosition", style: TextStyle(color: Colors.white),),
                          ))
                  ),
                ),
              ),
            ],
          ) : Container(),
        ],
      ),
    );
  }
}
