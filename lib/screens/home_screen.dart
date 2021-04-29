import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:notebook/screens/signup_screen.dart';
import 'package:notebook/widgets/note_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_note_screen.dart';

class HomeScreen extends StatelessWidget {
  final result;
  HomeScreen(this.result);
  goAddScreen(BuildContext context, rsult) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddNoteScreen(
                  result: rsult,
                )));
  }

  logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("logged", false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Note Book"),
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
                itemBuilder: (BuildContext bc) => [
                      PopupMenuItem(
                          child: TextButton(
                        onPressed: () {
                          logOut(context);
                        },
                        child: Container(
                            width: 100,
                            height: 30,
                            child: Text("Log Out",
                                style: TextStyle(fontSize: 18))),
                      )),
                    ],
                onSelected: (route) {
                  print("hello world");
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            goAddScreen(context, result);
          },
          backgroundColor: Colors.white,
          child: Text("+", style: TextStyle(fontSize: 30, color: Colors.blue)),
        ),
        backgroundColor: Colors.blue.shade200,
        body: Center(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(result.toString())
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text('Loading');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return NoteTile(document["title"], document["body"],
                            document["id"], result);
                      }).toList(),
                    );
                }
              }),
        ));
  }
}
