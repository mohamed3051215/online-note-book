import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:notebook/screens/home_screen.dart';
import 'package:notebook/screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  bool loading = false;
  bool logged;
  String uid;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController n = TextEditingController();

  TextEditingController e = TextEditingController();

  TextEditingController p = TextEditingController();
  showError(BuildContext context, onError) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Error'),
              content: Text(onError.toString()),
            ));
  }

  signUp(context) async {
    if (_formKey.currentState.validate()) {
      try {
        setState(() {
          widget.loading = true;
        });
        await Firebase.initializeApp();

        var result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: e.text, password: p.text);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(result.user.uid.toString())
            .set({
          "name": n.text,
          "email": e.text,
          "password": p.text,
          "uid": result.user.uid.toString()
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (conytext) => HomeScreen(result.user.uid.toString())));
        setState(() {
          widget.loading = false;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("logged", true);
        prefs.setString("uid", result.user.uid.toString());
        prefs.setString("email", e.text);
        prefs.setString("password", p.text);
        prefs.setString("name", n.text);
        setState(() {
          widget.uid = prefs.getString("uid");
        });
      } catch (e) {
        showError(context, e);
        widget.loading = false;
      }
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    print("got into");
    hello();
    print(widget.logged);
  }

  void hello() async {
    await Firebase.initializeApp();
    var prefs = await SharedPreferences.getInstance();
    var result = await FirebaseAuth.instance.currentUser;
    setState(() {
      widget.logged = prefs.getBool("logged");
      widget.uid = prefs.getString("uid");
    });
    print(widget.logged);
    print(prefs.getBool("logged"));
  }

  goSignIn(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  home() async {
    await Firebase.initializeApp();
    var result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: e.text, password: p.text);
    print("should go home");
  }

  button(BuildContext context) {
    if (!widget.loading) {
      return Container(
        height: 47,
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            signUp(context);
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red))),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.white60)),
          child: Text("Sign Up",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              )),
        ),
      );
    } else {
      return CircularProgressIndicator(
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.logged != null) if (!widget.logged)
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New in !!",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w600)),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        validator: (text) {
                          if (text.isEmpty || text == null)
                            return "Text Shouldn't be empty";
                          else if (text.contains(']') ||
                              text.contains(']') ||
                              text.contains(']') ||
                              text.contains('[') ||
                              text.contains(';') ||
                              text.contains(':') ||
                              text.contains('.') ||
                              text.contains('>') ||
                              text.contains('<') ||
                              text.contains(',') ||
                              text.contains("'\'") ||
                              text.contains('/') ||
                              text.contains('!') ||
                              text.contains('@') ||
                              text.contains('#'))
                            return "invalid Text ";
                          else
                            return null;
                        },
                        controller: n,
                        decoration: InputDecoration(
                          hintText: "Enter Your name",
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        validator: (text) {
                          if (text.isEmpty || text == null)
                            return "Text Shouldn't be empty";
                          else if (!text.contains("@"))
                            return "Text should contan @email.com";
                          else if (!text.contains(".com"))
                            return "Text should contan username@email.com";
                          else
                            return null;
                        },
                        controller: e,
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        validator: (text) {
                          if (text.isEmpty || text == null)
                            return "Text Shouldn't be empty";
                          else if (text.length < 6)
                            return "The password should be more than 6 chars";
                          else
                            return null;
                        },
                        controller: p,
                        decoration: InputDecoration(
                          helperStyle: TextStyle(fontSize: 20),
                          hintText: "Enter password",
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              button(context),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  goSignIn(context);
                },
                child: Text(
                  "I already have account ! Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    else
      return HomeScreen(widget.uid);
    else
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New in !!",
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w600)),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        validator: (text) {
                          if (text.isEmpty || text == null)
                            return "Text Shouldn't be empty";
                          else if (text.contains(']') ||
                              text.contains(']') ||
                              text.contains(']') ||
                              text.contains('[') ||
                              text.contains(';') ||
                              text.contains(':') ||
                              text.contains('.') ||
                              text.contains('>') ||
                              text.contains('<') ||
                              text.contains(',') ||
                              text.contains("'\'") ||
                              text.contains('/') ||
                              text.contains('!') ||
                              text.contains('@') ||
                              text.contains('#'))
                            return "invalid Text ";
                          else
                            return null;
                        },
                        controller: n,
                        decoration: InputDecoration(
                          hintText: "Enter Your name",
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        validator: (text) {
                          if (text.isEmpty || text == null)
                            return "Text Shouldn't be empty";
                          else if (!text.contains("@"))
                            return "Text should contan @email.com";
                          else if (!text.contains(".com"))
                            return "Text should contan username@email.com";
                          else
                            return null;
                        },
                        controller: e,
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        validator: (text) {
                          if (text.isEmpty || text == null)
                            return "Text Shouldn't be empty";
                          else if (text.length < 6)
                            return "The password should be more than 6 chars";
                          else
                            return null;
                        },
                        controller: p,
                        decoration: InputDecoration(
                          helperStyle: TextStyle(fontSize: 20),
                          hintText: "Enter password",
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              button(context),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  goSignIn(context);
                },
                child: Text(
                  "I already have account ! Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
