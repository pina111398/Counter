import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pruebas extends StatefulWidget {
  @override
  _Pruebastate createState() => new _Pruebastate();
}

class _Pruebastate extends State<Pruebas> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text("Historial",style: TextStyle(fontWeight: FontWeight.bold),),
            onTap: ()=>
              Navigator.pushNamed(context, '/historial')
            ,
          ),
          new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                    .collection("porMes")
                    .orderBy("mes",descending: true)
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
                      return Flexible(
                        child: new ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              EntryItem(snapshot.data.documents[index]['mes'],snapshot.data.documents[index].documentID),
                          itemCount: snapshot.data.documents.length,
                        ),
                      );
                  }
                },
          ),
        ],
      ),
    );
  }
}
  class EntryItem extends StatefulWidget {

  const EntryItem(this.mes, this.documentID);

  final String mes;
  final String documentID;

  @override
  _EntryItemState createState() => _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  bool isExpanded = false;
  Widget _buildTiles() {
    return ExpansionTile(
      onExpansionChanged: (bool expanding) => setState(() => this.isExpanded = expanding),
      title: 
        Consumer<ThemeNotifier>(
                        builder: (context,notifier,child) => 
                        Text(widget.mes,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,
                        color: notifier.darkTheme  ? Colors.white : Colors.black,)),
                      ),
      children:[
        StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("porMes/${widget.documentID}/resultados").orderBy('contador',descending: true)
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
                          Padding(
                            padding: const EdgeInsets.only(right: 10,left: 10),
                            child: ListTile(
                              title: Text(document['fname'],),
                              trailing: Text(document['contador'].toString()),
                            ),
                          );
                        
                    }).toList(),
                  );
              }
            },
          ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles();
  }
}