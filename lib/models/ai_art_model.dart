// Basic Imports
import 'package:flutter/material.dart';

class AIArtModel extends ChangeNotifier {
  late final List<String> encodedImages;

  AIArtModel() {
    this.encodedImages = [];
  }

  void addImage({required String encodedImage, bool update = true}) {
    this.encodedImages.add(encodedImage);
    if (update) notifyListeners();
  }

  void clear() {
    this.encodedImages.clear();
    notifyListeners();
  }

  void update() => notifyListeners();
}
