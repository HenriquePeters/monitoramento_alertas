import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  bool activated = true;
  bool criticalMode = false;
  bool vibrate = true;
  bool sound = true;
  bool banner = true;
  List<Event> events = [];
  String apiStatus = '';

  AppProvider() {
    _loadPrefs();
    _loadEvents();
    _loadApiStatus();
  }

  Future<void> _loadPrefs() async {
    vibrate = await StorageService().getBool('vibrate', defaultValue: true);
    sound = await StorageService().getBool('sound', defaultValue: true);
    banner = await StorageService().getBool('banner', defaultValue: true);
    criticalMode = await StorageService().getBool('criticalMode', defaultValue: false);
    notifyListeners();
  }

  Future<void> _loadEvents() async {
    events = await StorageService().getAllEvents();
    notifyListeners();
  }

  Future<void> _loadApiStatus() async {
    apiStatus = await ApiService().fetchStatus();
    notifyListeners();
  }

  Future<void> toggleActivated() async {
    activated = !activated;
    notifyListeners();
  }

  Future<void> simulateAlert({String source = 'Manual'}) async {
    if (!activated) return;
    final ev = Event(
      id: DateTime.now().millisecondsSinceEpoch,
      type: 'Panic',
      source: source,
      timestamp: DateTime.now(),
      processedAt: null,
    );
    await StorageService().insertEvent(ev);
    events.insert(0, ev);
    notifyListeners();
    await NotificationService().showAlert(
      title: 'Alerta disparado',
      body: 'Alerta do tipo ${ev.type} (fonte: ${ev.source})',
      critical: criticalMode,
      playSound: sound,
      vibrate: vibrate,
    );
  }

  Future<void> updatePreferences({bool? v, bool? s, bool? b, bool? critical}) async {
    if (v != null) { vibrate = v; await StorageService().setBool('vibrate', v); }
    if (s != null) { sound = s; await StorageService().setBool('sound', s); }
    if (b != null) { banner = b; await StorageService().setBool('banner', b); }
    if (critical != null) { criticalMode = critical; await StorageService().setBool('criticalMode', critical); }
    notifyListeners();
  }

  Future<void> refreshApiStatus() async {
    apiStatus = await ApiService().fetchStatus();
    notifyListeners();
  }
}
