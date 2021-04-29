import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notebook/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

// ignore: must_be_immutable
class SignInScreen extends StatefulWidget {
  bool loading = false;
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

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

  goSignUp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  container(BuildContext context) {
    if (!widget.loading)
      return Container(
        height: 47,
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            signIn(context);
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red))),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.white60)),
          child: Text("Sign In",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              )),
        ),
      );
    else
      return CircularProgressIndicator(
        backgroundColor: Colors.red,
      );
  }

  signIn(context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        widget.loading = true;
      });
      await Firebase.initializeApp();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: e.text, password: p.text)
          .catchError((onError) {
        showError(context, onError);
        setState(() {
          widget.loading = false;
        });
      });
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: e.text, password: p.text);
      print("You result is : " + result.toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(result.user.uid.toString())));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("logged", true);
      prefs.setString("uid", result.user.uid.toString());
      prefs.setString("email", e.text);
      prefs.setString("password", p.text);
    } else {
      showError(context, "invalid data");
      setState(() {
        widget.loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Scaffold(
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
                      Text("Sign In",
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.w600)),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: TextFormField(
                          controller: e,
                          validator: (String text) {
                            if (text.isEmpty || text == null)
                              return "Text Shouldn't be empty";
                            else if (!text.contains("@"))
                              return "Text should contan @email.com";
                            else if (!text.contains(".com"))
                              return "Text should contan username@email.com";
                            else
                              return null;
                          },
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
                          controller: p,
                          validator: (String text) {
                            if (text.isEmpty || text == null)
                              return "Text Shouldn't be empty";
                            else if (text.length < 6)
                              return "Password should be stronger (+6 chars)";
                            else
                              return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
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
                container(context),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    goSignUp(context);
                  },
                  child: Text(
                    "Don't have an account ?Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
