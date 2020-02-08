import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent,CounterState>{

  @override
  CounterState get initialState => CounterSinInicializar();
  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    print('evento: '+event.toString());
    if (event is Fetch){
      try{
        List<int> counter = await getCounter();
        yield CounterCargado(
              counter: counter[0],
              counterEnemigo: counter[1],
            );
      }
      catch(_){
        yield CounterError();
      }
    }
    if (event is Aumentar){
      try{
        yield CounterCargado(
              counter: (currentState as CounterCargado).counter + 1,
              counterEnemigo: (currentState as CounterCargado).counterEnemigo,
            );
      }
      catch(_){
        yield CounterError();
      }
    }
    if (event is Disminuir){
      try{
        yield CounterCargado(
              counter: (currentState as CounterCargado).counter - 1,
              counterEnemigo: (currentState as CounterCargado).counterEnemigo,
            );
      }
      catch(_){
        yield CounterError();
      }
    }
  }
  Future<List<int>> getCounter() async {
    List<int> contadores = [];
    CollectionReference ref = Firestore.instance.collection('user');
    QuerySnapshot eventsQuery = await ref
        .getDocuments();
    contadores.add(eventsQuery.documents[0]['contador']);
    contadores.add(eventsQuery.documents[1]['contador']);
    return contadores;
  }
}
