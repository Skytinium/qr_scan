import 'package:flutter/material.dart';

//Clase UIProvider debe extender de ChangeNotifier
class UIProvider extends ChangeNotifier {
  int _slectedMenuOpt = 1;

  int get selectedMenuOpt {
    return _slectedMenuOpt;
  }

  set selectedMenuOpt(int index) {
    _slectedMenuOpt = index;
    notifyListeners();
  }
}
