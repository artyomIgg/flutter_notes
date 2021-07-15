import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes/pages/main_page.dart';
import 'package:path_provider/path_provider.dart';

class MainAppBar extends StatefulWidget {
  var changeView;
  Function()? notifyParent;
  MainAppBar({Key? key, this.changeView, this.notifyParent}) : super(key: key);
  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    readStateAppJson();
    return Container(
      child: SliverAppBar(
        backgroundColor: Colors.white,
        expandedHeight: 120,
        collapsedHeight: 80,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            stretchModes: [StretchMode.zoomBackground],
            title: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notes',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        shadowColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          radius: 100,
                          onTap: () => {
                            refresh(),
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Icon(
                              changeView ? Icons.menu : Icons.grid_view,
                              size: 36,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void refresh() {
    setState(() {
      changeView = !changeView;
      widget.notifyParent!();
      opacityTrue = opacityTrue == 0.0 ? 1 : 0.0;
      writeStateAppJson();
    });
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/stateApp.json').create();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  
  Future<void> readStateAppJson() async {
    try {
    final file = await _localFile;

    final contents = await file.readAsString();
    var data = await json.decode(contents);
    changeView = data;
    }
    catch(e){
      print(e);
    }
  }
  Future<File> writeStateAppJson() async {
    final file = await _localFile;
    String jsonTags = jsonEncode(changeView);
    return file.writeAsString(jsonTags);
  }
}
