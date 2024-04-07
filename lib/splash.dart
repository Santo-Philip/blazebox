import 'package:blazebox/controller/settingscontroller.dart';
import 'package:blazebox/database/datastore.dart';
import 'package:blazebox/database/history.dart';
import 'package:blazebox/history.dart';
import 'package:blazebox/settings.dart';
import 'package:blazebox/video.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;

  final dio = Dio();

  int extractFileSize(String link) {
    RegExp regex = RegExp(r'size=(\d+)');
    Match? match = regex.firstMatch(link);
    if (match != null) {
      String sizeString = match.group(1)!;
      int fileSize = int.tryParse(sizeString) ?? 0;
      return fileSize;
    }
    return 0;
  }

  String formatBytes(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int index = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && index < units.length - 1) {
      size /= 1024;
      index++;
    }
    return '${size.toStringAsFixed(2)} ${units[index]}';
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController urlController = TextEditingController();
    final settings = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: const Color(0xFF151516),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){
                    QuickAlert.show(
                      context: context, 
                    type: QuickAlertType.info,
                   text: 'To delete an item from the list, press and hold on the item for a moment' );

                  }, icon: const Icon(Icons.info,color: Color(0xFFA08C8A),)),
                  IconButton(
                      onPressed: () {
                        Get.offAll(() => SettingsScreen());
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 40,
                        color: Color(0xFFA08C8A),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Image.asset(
                  'assets/terabox.png',
                  fit: BoxFit.contain,
                  width: 150,
                  height: 150,
                )),
            const Text(
              'BlazeBox',
              style: TextStyle(
                  color: Color.fromARGB(255, 240, 69, 57),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'Powered By : BlazingSquad',
              style: TextStyle(
                  color: Color.fromARGB(255, 55, 99, 210), fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: urlController,
                decoration: const InputDecoration(
                    hintText: 'Paste Your terabox link here',
                    hintStyle: TextStyle(color: Colors.blue),
                    focusColor: Colors.amber,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF422745)),
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? Center(
                        child: LoadingAnimationWidget.dotsTriangle(
                            color: Colors.red, size: 50),
                      )
                    : ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFF5F1224)),
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(22))),
                        onPressed: () async {
                          RegExp regExp = RegExp(r'/s/([\w-]+)');
                          if (regExp.hasMatch(urlController.text)) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              final res = await dio.get(
                                  'https://tera.instavideosave.com/?url=${urlController.text}');
                              if (res.statusCode == 200) {
                                final getsize = res.data['api']['size'];
                                int sizeInt = int.tryParse(getsize) ?? 0;
                                final size = formatBytes(sizeInt);
                                final val = res.data['api']['dlink'].toString();
                                int questionMarkIndex = val.indexOf('?');
                                final link = val.replaceFirst(
                                    val
                                        .substring(0, questionMarkIndex)
                                        .split('/')[2],
                                    'd3.terabox.app');
                                final thumb = res.data['api']['thumbs']['url1'];
                                Get.to(() => const PlayerScreen(), arguments: [
                                  {'name': res.data['api']['server_filename']},
                                  {'size': size},
                                  {'link': link},
                                  {'thumb': thumb}
                                ]);
                                if (settings.history == true) {
                                  final values = History(
                                      name: res.data['api']['server_filename'],
                                      link: link,
                                      size: size,
                                      thumb: thumb);
                                  HistoryStore().addValue(historyModel: values);
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              QuickAlert.show(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  type: QuickAlertType.error,
                                  title: 'Ooops',
                                  text:
                                      'Something went wrong please try again...');
                            }
                          }
                        },
                        child: const Text(
                          'Play',
                          style:
                              TextStyle(fontSize: 22, color: Color(0xFFFFEDEB)),
                        )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (settings.mainHistory == false)
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xFF571E1B))),
                      onPressed: () {
                        Get.to(() => const HistoryScreen());
                      },
                      child: const Text(
                        'History',
                        style: TextStyle(color: Color(0xFFFFEDEB)),
                      )),
                ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFFFFEDEB)),
                    ),
                    onPressed: () async {
                      Uri url = Uri.parse('https://telegram.me/blazingsquad');
                      await launchUrl(url);
                    },
                    child: const Text(
                      'Join for updates',
                      style: TextStyle(color: Color(0xFF231C1B)),
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (settings.mainBookmrk == false) ItemsList(),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      )),
    );
  }
}
