import 'package:flutter/material.dart';
import 'package:blazebox/controller/settingscontroller.dart';
import 'package:blazebox/database/bookmark.dart';
import 'package:blazebox/database/history.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class Initializer {
  static Future<void> initialize() async {
     WidgetsFlutterBinding.ensureInitialized();
  String storageLocation = (await getApplicationDocumentsDirectory()).path;
  await FastCachedImageConfig.init(subDir: storageLocation, clearCacheAfter: const Duration(days: 15));
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryAdapter());
  Hive.registerAdapter(BookMarkAdapter());
  await Hive.openBox<BookMark>('bookmark');
  await Hive.openBox<History>('history');
  Get.put(SettingsController());
   await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: false ,
  );
    WidgetsFlutterBinding.ensureInitialized();
  }
}