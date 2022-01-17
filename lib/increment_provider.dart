import 'package:flutter/widgets.dart';

class IncrementProvider extends ChangeNotifier {
  int _initialValue = 0;

  int initialValue() => _initialValue;

  void increment() {
    _initialValue++;
    notifyListeners();
  }
}
