// Basic Imports
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AITransformModel extends ChangeNotifier {
  Uint8List? encodedOriginal, encodedNew;

  void setOriginal({required Uint8List encoded}) {
    this.encodedOriginal = encoded;
    notifyListeners();
  }

  void setNew({required Uint8List encoded}) {
    this.encodedNew = encoded;
    notifyListeners();
  }

  void clear() {
    this.encodedOriginal = null;
    this.encodedNew = null;
    notifyListeners();
  }

  void update() => notifyListeners();
}
