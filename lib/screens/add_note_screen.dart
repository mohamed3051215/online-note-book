import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";

// ignore: must_be_immutable
class AddNoteScreen extends StatefulWidget {
  final result;
  bool loading = false;
  AddNoteScreen({@required this.result});
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var id;
  TextEditingController t = TextEditingController();

  TextEditingController b = TextEditingController();
  showError(BuildContext context, onError) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Error"),
              content: Text("$onError"),
            ));
  }

  addNote(BuildContext context, result) async {
    if (_formKey.currentState.validate()) {
      try {
        await Firebase.initializeApp();
        setState(() {
          widget.loading = true;
        });
        String title = t.text;
        String body = b.text;
        // ignore: unused_local_variable
        var task = await FirebaseFirestore.instance
            .collection(result.toString())
            .add({"title": title, "body": body, "id": null}).then((value) {
          id = value;
        });
        await FirebaseFirestore.instance
            .collection(result.toString())
            .doc(id.id.toString())
            .update({"id": id.id.toString()});
        print("that is you id $id \nthat is your id2 ${id.id}");
        Navigator.pop(context);
        setState(() {
          widget.loading = false;
        });
      } catch (e) {
        showError(context, e);
        setState(() {
          widget.loading = false;
        });
      }
    }
  }

  Widget button(BuildContext ctx) {
    if (!widget.loading)
      return TextButton(
        child: Text("+",
            style: TextStyle(fontSize: 40, color: Colors.red.shade300)),
        onPressed: () {
          addNote(ctx, widget.result);
        },
      );
    else
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 20,
          height: 10,
          child: CircularProgressIndicator(
            backgroundColor: Colors.red,
            strokeWidth: 4.0,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        actions: [
          button(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: t,
                  validator: (text) {
                    if (text.isEmpty || text == "" || text == null)
                      return "Title Shouldn't be embty";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white60,
                      filled: true,
                      hintText: "Add the note title",
                      hintStyle: TextStyle(fontSize: 25)),
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: b,
                  validator: (text) {
                    if (text.isEmpty || text == "" || text == null)
                      return "Note Shouldn't be embty";
                    else
                      return null;
                  },
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      fillColor: Colors.white60,
                      filled: true,
                      hintText: "Add the note",
                      hintStyle: TextStyle(fontSize: 20)),
                  style: TextStyle(fontSize: 20),
                  maxLines: null,
                ),
              ),
            ],
          ),
        )),
      ),
      backgroundColor: Colors.blue,
    );
  }
}

// .onError((error, stackTrace) {
//           showError(context, error);
//           setState(() {
//             widget.loading = false;
//           });
//         })
