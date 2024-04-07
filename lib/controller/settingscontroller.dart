import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsController extends GetxController {
  bool history = true;
  bool mainHistory = true;
  bool mainBookmrk = true;
  bool playerBookmark = true;
  bool videoMute = false;
  bool fullscreen = false;

  @override
  void onInit() {
    getSettings();
    super.onInit();
  }

  Future getSettings() async {
    Box box;
    try {
      box = Hive.box('settings');
    } catch (e) {
      box = await Hive.openBox('settings');
    }
    
    mainHistory = box.get('mainHistory') ?? true;
    history = box.get('history')?? true;
    mainBookmrk = box.get('mainBookmark')?? true;
    playerBookmark = box.get('playerBookmark')?? true;
    videoMute = box.get('videoMute')?? false;
    fullscreen = box.get('fullscreen')?? false;

     update();
  }

  updateSettings(bool settings, String key) async {
    var box = await Hive.openBox('settings');
    box.put(key, settings);
    getSettings();
  }
}
