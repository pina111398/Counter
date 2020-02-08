import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 4) {
      return 'Password must be longer than 4 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Container(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email*'),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Contraseña*', hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(height: 20,),
                  RaisedButton(
                    child: Text("Entrar",style: TextStyle(color: Colors.black)),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_loginFormKey.currentState.validate()) {
                        FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailInputController.text,
                              password: pwdInputController.text)
                          .then((currentUser) => 
                          currentUser != null ?
                          Firestore.instance
                              .collection("users")
                              .document(currentUser.user.uid)
                              .get()
                              .then((DocumentSnapshot result) =>
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage(
                                                title: result["fname"] +
                                                    "'s contador",
                                                uid: currentUser.user.uid,
                                              ))))
                              .catchError((err) => print(err)):print('object'))
                          .catchError((err) => print(err));
                      }
                    },
                  ),
                  FlatButton(
                    child: Text("Registrarse",),
                    onPressed: (){
                      Navigator.pushNamed(context, '/register');
                    },
                  )
                ],
              ),
            ))));
  }
}