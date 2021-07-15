import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note.dart';
import 'package:flutter_notes/pages/edit_notes_page.dart';
import 'package:flutter_notes/pages/main_page.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:path_provider/path_provider.dart';

List<Note> notes = [];

class NotesWidget extends StatefulWidget {
  NotesWidget({Key? key, this.items, this.refresh}) : super(key: key);
  var refresh;
  var items;
  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  var delItem;
  int stop = 1;
  List config = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.refresh != null) {
      widget.refresh!();
    }

    SliverChildBuilderDelegate builderDelegate = SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        final itemTitle = notes[index].title;
        final itemContent = notes[index].content;
        final itemDate = notes[index].date;
        return Dismissible(
          direction: DismissDirection.endToStart,
          key: UniqueKey(),
          onDismissed: (direction) {
            delItem = notes[index];
            setState(() {
              notes.removeAt(index);
              writeData(_localNotesFile, notes);
            });
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Note dismissed"),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  setState(() {
                    notes.insert(index, delItem);
                    writeData(_localNotesFile, notes);
                  });
                },
              ),
            ));
          },
          background: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                color: Colors.red,
              ),
              alignment: Alignment.centerRight,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      Text('Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: SizedBox(
                width: double.infinity,
                child: Material(
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        SlideTransitionCustom(EditNotesPage(
                          title: itemTitle,
                          content: itemContent,
                          notifyParent: refresh,
                          index: index,
                          date: itemDate,
                        )),
                      ),
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '$itemTitle',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  itemDate != null
                                      ? Text(
                                          '$itemDate',
                                          style: TextStyle(fontSize: 10),
                                        )
                                      : Text('')
                                ],
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              Text(
                                '$itemContent',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      childCount: notes.length,
    );
    readNotesJson();
    readConfigJson();
    return notes.isNotEmpty
        ? SliverAnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: changeView
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300.0,
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      childAspectRatio: 1.0,
                    ),
                    delegate: builderDelegate)
                : SliverList(delegate: builderDelegate))
        : SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
            return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 200),
                  child: Text(
                    'Empty...',
                    style: TextStyle(fontSize: 50, color: Colors.grey),
                  ),
                ));
          }, childCount: 1));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localNotesFile async {
    final path = await _localPath;
    return File('$path/notes.json').create();
  }

  Future<File> get _localConfigFile async {
    final path = await _localPath;
    return File('$path/config.json').create();
  }

  Future<File> writeData(Future<File> localFile, List encodeString) async {
    final file = await localFile;
    String jsonTags = jsonEncode(encodeString);
    return file.writeAsString(jsonTags);
  }

  Future<void> readNotesJson() async {
    final file = await _localNotesFile;

    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      Iterable data = await json.decode(contents);
      if (notes.isEmpty && stop > 0) {
        setState(() {
          notes = data.map((model) => Note.fromObject(model)).toList();
          notes = new List.from(notes.reversed);
          stop--;
        });
      }
      notes = data.map((model) => Note.fromObject(model)).toList();
    }
  }

  Future<void> readConfigJson() async {
    final file = await _localConfigFile;

    final contents = await file.readAsString();
    if (contents.isEmpty && notes.isEmpty) {
      notes.add(
          Note.withDate('My name is Artem', 'I`m from Ukraine. I am 19 years old.', '2021/07/14'));
      notes.add(
          Note.withDate('I study in Kharkiv at KNURE', 'I study at the Faculty of Computer Science, major 121 - Software Engineering. I live in a hostel near the university.', '2021/07/14'));
      notes.add(
          Note.withDate('Hobbies', 'My hobbies are reading books, learning programming languages, playing board games, playing computer games.', '2021/07/14'));

      config.add(true);
      setState(() {
        writeData(_localNotesFile, notes);
        writeData(_localConfigFile, config);
      });
    }
  }

  void refresh() {
    setState(() {});
  }
}

class SlideTransitionCustom extends PageRouteBuilder {
  final Widget page;

  SlideTransitionCustom(this.page)
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: Duration(milliseconds: 1000),
            reverseTransitionDuration: Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  parent: animation,
                  reverseCurve: Curves.fastOutSlowIn);
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation),
                child: page,
              );
            });
}
