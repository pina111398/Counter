import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable{}

class Fetch extends CounterEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'Fetch';
  }
}
class Aumentar extends CounterEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'Aumentar';
  }
}
class Disminuir extends CounterEvent{
  @override
  String toString() {
    // TODO: implement toString
    return 'Disminuir';
  }
}