import 'package:flutter/material.dart';
import 'package:flutter_notes/pages/edit_notes_page.dart';
import 'package:flutter_notes/widgets/main_appBar.dart';
import 'package:flutter_notes/widgets/notes_widget.dart';

bool changeView = false;
var opacityTrue = 1.0;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final customers = ["Marry", "aaaa", "ssss"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              MainAppBar(
                notifyParent: refresh,
              ),
              NotesWidget(),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                color: Colors.orange,
                shadowColor: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  radius: 100,
                  onTap: () => {
                    Navigator.push(
                      context,
                      SlideTransitionCustom(EditNotesPage(notifyParent: refresh,)),
                    ),
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    child: Icon(
                      Icons.add,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {
    });
  }
}
