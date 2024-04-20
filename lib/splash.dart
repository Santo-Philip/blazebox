import 'dart:async';

import 'package:blazebox/controller/settingscontroller.dart';
import 'package:blazebox/history.dart';
import 'package:blazebox/misc/link.dart';
import 'package:blazebox/settings.dart';
import 'package:blazebox/video.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;
  String? _sharedText;
  late StreamSubscription _intentTextStreamSubscription;
  final dio = Dio();

  @override
  void initState() {
    super.initState();

    _intentTextStreamSubscription =
        ReceiveSharingIntentPlus.getTextStream().listen(
      (String value) async {
        setState(() {
          _sharedText = value;
          debugPrint('Shared: $_sharedText');
        });
          if (_sharedText != null) {
            _isLoading = true;
            await link(value);
          }
      },
      onError: (err) {

        setState(() {
          _isLoading = false;
        });
        log('getLinkStream error: $err');
      },
    );

  ReceiveSharingIntentPlus.getInitialText().then((String? value) async {
    _sharedText ??= value;
      if (_sharedText != null) {
        setState(() {
           _isLoading = true;
        });
          try {
            await link(value!);
            clearSharedLink();
            ReceiveSharingIntentPlus.reset();
          } catch (e) {
            
            setState(() {
              _isLoading = false;
            });
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Internal server error",
                title: "Ooooops");
          }
        }
    }, onError: (err) {
      setState(() {
        _isLoading = false;
      });
      log('Initial Link error : $err');
    });
  }

  void clearSharedLink() {
    setState(() {
      _sharedText = null;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _intentTextStreamSubscription.cancel();
    super.dispose();
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
                  IconButton(
                      onPressed: () {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            text:
                                'To delete an item from the list, press and hold on the item for a moment');
                      },
                      icon: const Icon(
                        Icons.info,
                        color: Color(0xFFA08C8A),
                      )),
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
                        child: LoadingAnimationWidget.fourRotatingDots(
                            color: Color.fromARGB(255, 227, 97, 88), size: 50),
                      )
                    : ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFF5F1224)),
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(22))),
                        onPressed: () async {
                          if (urlController.text != "") {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await link(urlController.text);
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  text: "Internal server error",
                                  title: "Ooooops");
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
