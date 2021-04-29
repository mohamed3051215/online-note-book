import "package:flutter/material.dart";
import 'package:notebook/screens/edit_note_screen.dart';

class NoteTile extends StatelessWidget {
  final title, body,id,result;
  NoteTile(this.title, this.body , this.id , this.result);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.blue),
        child: ListTile(
          title: Text(title,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
          subtitle: Text(
            body,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
          contentPadding: EdgeInsets.all(10),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditNoteScreen(title,body,id,result)));
          },
        ),
      ),
    );
  }
}
