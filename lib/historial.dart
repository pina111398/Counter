import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Historial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        appBar: AppBar(
          title: Text('Historial'),
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("porDias")
                .orderBy("fecha",descending: true)
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
                            title: Text(document['fname'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            trailing: Text(document['fecha']),
                          );
                        
                    }).toList(),
                  );
              }
            },
          ),
        ),
      );
  }
}