import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note.dart';
import 'package:flutter_notes/widgets/notes_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class EditNotesPage extends StatefulWidget {
  EditNotesPage(
      {Key? key,
      this.notifyParent,
      this.title,
      this.content,
      this.date,
      this.index})
      : super(key: key);
  Function()? notifyParent;
  String? title;
  String? content;
  String? date;
  int? index;

  @override
  _EditNotesPageState createState() => _EditNotesPageState();
}

class _EditNotesPageState extends State<EditNotesPage>
    with TickerProviderStateMixin {
  late AnimationController controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 700));
  late Animation<Offset> offset =
      Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 2.0))
          .animate(controller);

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 2.0))
        .animate(controller);
  }

  bool newNote = false;
  bool isCheckedDate = false;
  bool currentDate = false;
  bool changeDate = false;
  bool savedChanges = false;
  bool newData = false;
  int stop = 1;
  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // currentDate = isCheckedDate;
    if (widget.title != null && widget.content != null && stop > 0) {
      titleController.text = widget.title!;
      contentController.text = widget.content!;
      if (widget.date != null) {
        isCheckedDate = true;
        currentDate = true;
      }
      controller.forward();
      newData = false;
      stop--;
    } else if (stop > 0 && widget.title == null && widget.content == null) {
      controller.forward();
      newData = false;
      newNote = true;
      stop--;
    }

    return Container(
      child: WillPopScope(
        onWillPop: (() {
          if (savedChanges) {
            Navigator.pop(context);
          } else if (widget.index == null && !newData) {
            Navigator.pop(context);
          } else if (newData) {
            _openCustomDialog();
          } else
            Navigator.pop(context);

          return Future.value(true);
        }),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                newNote ? Text('New note') : Text('Edit Note'),
                Row(
                  children: [
                    Text('Date:'),
                    Checkbox(
                      value: isCheckedDate,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedDate = value!;
                          if (isCheckedDate) {
                            newNote
                                ? checkNewNote()
                                : newData = chechEditNote();
                          } else {
                            newData = chechEditNote();
                          }
                          // if (isCheckedDate) {
                          //   var now = new DateTime.now();
                          //   var formatter = new DateFormat('yyyy/MM/dd');
                          //   widget.date = formatter.format(now);
                          //   changeDate = !changeDate;
                          //   if (changeDate = false) {
                          //     widget.date = null;
                          //   }
                          //   if (value == false) widget.date = null;
                          //   if ((titleController.text.isNotEmpty &&
                          //               contentController.text.isNotEmpty) &&
                          //           (titleController.text != widget.title ||
                          //               contentController.text !=
                          //                   widget.content) ||
                          //       checkDate2 == isCheckedDate) {
                          //     controller.forward();
                          //     newData = false;
                          //   } else {
                          //     controller.reverse();
                          //     newData = true;
                          //   }
                          // } else if (!newNote) {
                          //   // changeDate = !changeDate;
                          //   controller.reverse();
                          //   newData = true;
                          // }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        TextField(
                          controller: titleController,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              newNote
                                  ? newData = checkNewNote()
                                  : newData = chechEditNote();

                              // if ((titleController.text.isNotEmpty &&
                              //             contentController.text.isNotEmpty) &&
                              //         (titleController.text != widget.title ||
                              //             contentController.text !=
                              //                 widget.content) ||
                              //     changeDate) {
                              //   controller.reverse();
                              //   newData = true;
                              // } else {
                              //   controller.forward();
                              //   newData = false;
                              // }
                            });
                          },
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 2,
                        ),
                        Flexible(
                          child: TextField(
                            controller: contentController,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Content',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                newNote
                                    ? newData = checkNewNote()
                                    : newData = chechEditNote();
                                // if ((titleController.text.isNotEmpty &&
                                //             contentController
                                //                 .text.isNotEmpty) &&
                                //         (titleController.text != widget.title ||
                                //             contentController.text !=
                                //                 widget.content) ||
                                //     changeDate) {
                                //   controller.reverse();
                                //   newData = true;
                                // } else {
                                //   controller.forward();
                                //   newData = false;
                                // }
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SlideTransition(
                          position: offset,
                          child: Material(
                            color: Colors.orange,
                            shadowColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              radius: 100,
                              onTap: () => {
                                writeNote(),
                                Scaffold.of(context).hideCurrentSnackBar(),
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: newNote
                                      ? Text('New note saved!')
                                      : Text("Changes saved!"),
                                )),
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                child: Icon(
                                  Icons.check,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/notes.json').create();
  }

  Future<File> writeNote() async {
    final file = await _localFile;
    Note note = Note.withDate(
        titleController.text, contentController.text, widget.date);
    if (widget.index != null) {
      notes[widget.index!] = note;
    } else {
      notes.insert(0, note);
    }

    String jsonTags = jsonEncode(notes);
    widget.notifyParent!();
    savedChanges = true;
    return file.writeAsString(jsonTags);
  }

  void _openCustomDialog() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                title: Text('Attention'),
                content: Text('Do you want to save your changes?'),
                actions: [
                  FlatButton(
                    child: Text('Exit with saving'),
                    onPressed: () {
                      writeNote();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Exit without saving'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 400),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Align();
        });
  }

  bool checkNewNote() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy/MM/dd');
    widget.date = formatter.format(now);
    bool result = false;
    if ((titleController.text.isNotEmpty &&
        contentController.text.isNotEmpty)) {
      result = true;
      controller.reverse();
    } else
      controller.forward();
    setDate();
    return result;
  }

  bool chechEditNote() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy/MM/dd');
    widget.date = formatter.format(now);
    bool result = false;
    if ((titleController.text.isNotEmpty &&
                contentController.text.isNotEmpty) &&
            (titleController.text != widget.title ||
                contentController.text != widget.content) ||
        currentDate != isCheckedDate) {
      // if()
      result = true;
      controller.reverse();
    } else
      controller.forward();
    if ((titleController.text.isEmpty ||
        contentController.text.isEmpty)) {
      result = false;
      controller.forward();
    }
    setDate();
    return result;
  }

  void setDate() {
    if (isCheckedDate) {
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy/MM/dd');
      widget.date = formatter.format(now);
    } else
      widget.date = null;
  }
}
