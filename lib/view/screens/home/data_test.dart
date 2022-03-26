import 'package:flutter/cupertino.dart';

class DataTest extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  setIndex(int value) {
    _index = value;
    this.notifyListeners();
  }
}