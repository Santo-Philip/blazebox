import 'dart:developer';

import 'package:blazebox/controller/settingscontroller.dart';
import 'package:blazebox/database/datastore.dart';
import 'package:blazebox/database/history.dart';
import 'package:blazebox/video.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

Future<void> link(String link) async {
  final settings = Get.find<SettingsController>();
  final dio = Dio();
  try {
    final res =
        await dio.get('https://terabox-dl-arman.vercel.app/api?data=${link}');
    if (res.statusCode == 200) {
      Map<String, dynamic> data = res.data;
      final size = data['size'];
      final val = data['link'].toString();
      int questionMarkIndex = val.indexOf('?');
      final link = val.replaceFirst(
          val.substring(0, questionMarkIndex).split('/')[2], 'd3.terabox.app');
      final thumb = data['thumb'];
      Get.offAll(() => const PlayerScreen(), arguments: [
        {'name': data['file_name']},
        {'size': size},
        {'link': link},
        {'thumb': thumb}
      ]);
      if (settings.history == true) {
        final values = History(
            name: data['file_name'], link: link, size: size, thumb: thumb);
        HistoryStore().addValue(historyModel: values);
      }
    }
  } catch (e) {
    log('$e');
   throw Exception('Internal server error : $e');
  }
}
