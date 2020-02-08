import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaContadores extends StatefulWidget {
  @override
  _ListaContadoresState createState() => _ListaContadoresState();
}

class _ListaContadoresState extends State<ListaContadores> {
  @override
  Widget build(BuildContext context) {
    return 
      Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("users").orderBy("contador",descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container();
                      default:
                        int i = 0;
                        return new ListView(
                          shrinkWrap: true,
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                                i++;
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  leading: i==1 ? Image(image: AssetImage('assets/images/crown.png'),width: 25,) : i==2 ? Icon(Icons.looks_two,color: Colors.grey[700]) : i==3 ? Icon(Icons.looks_3,color: Colors.brown[700]) :null,
                                  title: Text(document['fname'],style: TextStyle(fontSize: 21),),
                                  trailing: Text(document['contador'].toString(),style: TextStyle(fontSize: 21)),
                                ),
                                Divider(height: 5,)
                              ],
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("porDias")
                      .orderBy("fecha",descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container();
                      default:
                        int i = 0;
                        return new ListView(
                          shrinkWrap: true,
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                                i++;
                            return 
                                ListTile(
                                  title: Text("Última hecha por: " +document['fname'],style: TextStyle(fontSize: 16),),
                                  subtitle: Text(document['fecha']),
                                );
                              
                          }).toList(),
                        );
                    }
                  },
                ),
              ],
            )),
      );
  }
}