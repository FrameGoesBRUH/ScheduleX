import 'package:flutter/material.dart';
import 'package:schedulex/pages/model/event.dart';
import 'package:schedulex/Theme/dark_Theme.dart';
import 'package:schedulex/Theme/light_Theme.dart';

// ThemeDat

class EventProvider with ChangeNotifier {
  final dark_Theme = darkMode;
// ThemeData
  final light_Theme = lightMode;
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  final List<Event> _events = [];
  List<Event> get events => _events;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  void setDate(DateTime date) => _selectedDate = date;
  List<Event> get eventsOfSelectedDate => _events;

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(String id) {
    _events.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearEvent() {
    _events.clear();
    notifyListeners();
  }

  void toggleTheme(bool val) {
    if (val == true) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
