import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";

// ignore: must_be_immutable
class EditNoteScreen extends StatefulWidget {
  final title;
  final id;
  final body;
  final result;
  bool loading = false;
  EditNoteScreen(this.title, this.body, this.id, this.result);
  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController t = TextEditingController();
  TextEditingController b = TextEditingController();
  showError(BuildContext context, onError) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text("Error"), content: Text(onError.toString())));
  }


  Widget button() {
    if (!widget.loading)
      return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(Icons.update_outlined),
        ),
        onTap: () {
          updateNote(context);
        },
      );
    else
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 30,
          height: 40,
          child: CircularProgressIndicator(
            backgroundColor: Colors.red,
          ),
        ),
      );
  }

  updateNote(BuildContext context) async {
    try {
      if (_formKey.currentState.validate()) {
        await Firebase.initializeApp();
        String title = t.text;
        String body = b.text;
        setState(() {
          widget.loading = true;
        });
        await FirebaseFirestore.instance
            .collection(widget.result.toString())
            .doc(widget.id.toString())
            .update({"title": title, "body": body}).onError(
                (error, stackTrace) {
          showError(context, error);
        });
        Navigator.pop(context);
        setState(() {
          widget.loading = false;
        });
      }
    } catch (e) {
      showError(context, e);
      setState(() {
        widget.loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
        actions: [
          button(),
        ],
      ),
      backgroundColor: Colors.blue,
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
    );
  }
}
