import 'package:flutter/material.dart';
import 'package:flutter_gallery/flutter_gallery.dart';
import 'package:photo_manager/photo_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery Picker Example',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Gallery Picker Example App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AssetEntity> results = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset : true,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: results.length == 0
                        ? Text('Select Media..')
                        : Text('${results.length} items selected)')
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.perm_media),
            onPressed: () async {
              final _results = await FlutterGallery.pickGallery(
                context: context,
                title: widget?.title,
                color: Colors.red,
                  limit: 15
              );
              if (_results != null) {
                setState(() => results = _results);
              }
            })
    );
  }
}
