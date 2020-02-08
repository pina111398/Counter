import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/contadorPersonal.dart';
import 'package:counter/historial.dart';
import 'package:counter/listaContadores.dart';
import 'package:counter/pruebas.dart';
import 'package:counter/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.uid}) : super(key: key);

  final String title;
  final String uid;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  int _currentIndex = 1;

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.history),title: Text("")),
    BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("")),
    BottomNavigationBarItem(icon: Icon(Icons.list),title: Text("")),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.title,style: TextStyle(),),
        centerTitle: true,
        actions: <Widget>[
          Consumer<ThemeNotifier>(
                        builder: (context,notifier,child) => Switch(
                          activeColor: Colors.grey,
                          onChanged: (val){
                            notifier.toggleTheme();
                          },
                          value: notifier.darkTheme ,
                        ),
                      ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                      Navigator.pushReplacementNamed(context, "/login"))
                  .catchError((err) => print(err));
            },
          )
        ],
      ),
      body: 
      SafeArea(
          top: false,
          child: IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              Pruebas(),
              ContadorPersonal(uid: widget.uid),
              ListaContadores(),
            ],
          ),
        ),
      bottomNavigationBar: 
          BottomNavigationBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : null,
            fixedColor: Theme.of(context).primaryColor == Colors.white ? Colors.black : Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false, 
            currentIndex: _currentIndex,
            onTap: (int i){
              setState(() {
              _currentIndex = i; 
              });
            },
            items: items,
          ),

    );
  }
}
