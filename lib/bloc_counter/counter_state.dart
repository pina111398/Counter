import 'package:equatable/equatable.dart';

abstract class CounterState extends Equatable{
  CounterState([List props = const []]):super(props);
}

class CounterSinInicializar extends CounterState{
  @override
  String toString() {
    // TODO: implement toString
    return 'CounterSinInicializar';
  }
}
class CounterError extends CounterState{
  @override
  String toString() {
    // TODO: implement toString
    return 'Counter Error';
  }
}

class CounterCargado extends CounterState{
  final int counter;
  final int counterEnemigo;
  CounterCargado({
    this.counter,
    this.counterEnemigo,
  }):super([counter,counterEnemigo]);

  @override
  String toString() {
    // TODO: implement toString
    return 'Counter cargados: ${counter}';
  }
}