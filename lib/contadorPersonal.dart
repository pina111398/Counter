import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:counter/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContadorPersonal extends StatefulWidget {
  final String uid;

  const ContadorPersonal({Key key, this.uid}) : super(key: key);

  @override
  _ContadorPersonalState createState() => _ContadorPersonalState();
}

class _ContadorPersonalState extends State<ContadorPersonal>with TickerProviderStateMixin  {

  bool esVisible;
  AnimationController rotationController;

  bool cargando;
  @override
  void initState() {
    cargando = true;
    // TODO: implement initState
    super.initState();
    esVisible = false;
    rotationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _sacaUltima();
  }
  _sacaUltima(){
    CollectionReference refdia = Firestore.instance.collection('porDias');
    CollectionReference refUser = Firestore.instance.collection('users');
      refUser
      .where("uid",isEqualTo: "${widget.uid}")
      .limit(1)
      .getDocuments()
      .then((QuerySnapshot snapshot){
        refdia
          .where("fname",isEqualTo: "${snapshot.documents[0].data['fname']}")
          .orderBy("fecha",descending: true)
          .limit(1)
          .getDocuments()
          .then((QuerySnapshot snap){
            setState(() {
              ultima = DateTime.parse(snap.documents[0].data['fecha']);
              cargando = false;
            });
          }); 
      }); 
  }
  actualizaContador(int numero,bool suma,String fname)async{
     await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .updateData({'contador': numero});
    if (suma){
      CollectionReference refdia = Firestore.instance.collection('porDias');
      try {
        refdia
          .document()
          .setData({
            "fecha": DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
            "fname": fname,
          });
      } catch (e) {
        print(e.toString());
      } 
    }
    else{
      CollectionReference refdia = Firestore.instance.collection('porDias');
      refdia
      .where("fname",isEqualTo: "$fname")
      .orderBy("fecha",descending: true)
      .limit(1)
      .getDocuments()
      .then((QuerySnapshot snapshot){
        refdia.document(snapshot.documents[0].documentID)
        .delete();
      }); 
      /*where("fname",isEqualTo: "$fname")
      .orderBy("fecha",descending: true)
      .limit(1).*/
    }
  }
  DateTime ultima;
  /*static Duration dur =  ;
  String differenceInYears = (dur.inHours/24).floor().toString();*/
  @override
  Widget build(BuildContext context) {
    return 
    Center(
        child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    !cargando ? Text("Tu última fue hace "+ (DateTime.now().difference(ultima).inHours).floor().toString()+" horas") : Container(),
                    SizedBox(height: 50,),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("users")
                          .where("uid", isEqualTo: widget.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container();
                          default:
                            return 
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot.data.documents[0]['contador'].toString(),style: TextStyle(fontSize: 62)),
                                  SizedBox(height: 42,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FloatingActionButton(
                                        heroTag: 'uno',
                                        backgroundColor: Colors.orange,
                                        child: Icon(Icons.add),
                                        onPressed: ()async{
                                          await mostrarPencilVester();
                                          actualizaContador(snapshot.data.documents[0]['contador']+1,true,snapshot.data.documents[0]['fname']);
                                        },
                                      ),
                                      SizedBox(width: 42,),
                                      FloatingActionButton(
                                        heroTag: 'dos',
                                        backgroundColor: Colors.orange,
                                        child: Icon(Icons.remove),
                                        onPressed: (){
                                          actualizaContador(snapshot.data.documents[0]['contador']-1,false,snapshot.data.documents[0]['fname']);
                                        },
                                      )
                                    ],
                                  )
                                ],
                              );
                        }
                      },
                    ),
                  ],
                ),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOutBack)).animate(rotationController),
                   child: Visibility(
                    visible: esVisible,
                    child: Image(image: AssetImage('assets/images/pencilvester.png'),),
                  ),
                )
              ],
            )),
      );
  }
  mostrarPencilVester()async{
    setState(() {
      esVisible = true;
    });
    rotationController.forward();
    await Future.delayed(Duration(seconds: 1));
    rotationController.reset();
    setState(() {
      esVisible = false;
    });
  }
}