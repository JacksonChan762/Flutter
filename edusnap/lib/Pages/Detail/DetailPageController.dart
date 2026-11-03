// ignore_for_file: file_names
import 'package:flutter/foundation.dart';

import '../../Models/JournalEntry.dart';

class DetailPageController extends ChangeNotifier {
  DetailPageController(this._entry);
  JournalEntry _entry;
  JournalEntry get entry => _entry;
  void update(JournalEntry entry) {
    _entry = entry;
    notifyListeners();
  }
}
