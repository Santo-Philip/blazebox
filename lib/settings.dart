import 'package:blazebox/controller/settingscontroller.dart';
import 'package:blazebox/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final settings = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFF151516),
          appBar: AppBar(
            toolbarHeight: 200,
            title: const Text(
              'Settings',
              style: TextStyle(color: Color(0xFFFFDAD5), fontSize: 45),
            ),
            elevation: 0,
            backgroundColor: const Color(0xFF151516),
          ),
          body: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              Get.offAll(() => const SplashScreen());
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'General',
                      style: TextStyle(color: Color(0xFFEDDFDD), fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: controller.mainHistory
                          ? ElevatedButton(
                              onPressed: () {
                                controller.updateSettings(false, 'mainHistory');
                              },
                              child: const Text(
                                'History is hidden',
                                style: TextStyle(fontSize: 24),
                              ))
                          : OutlinedButton(
                              style: const ButtonStyle(
                                  side: MaterialStatePropertyAll(
                                      BorderSide(color: Color(0xFFFFDAD5)))),
                              onPressed: () {
                                controller.updateSettings(true, 'mainHistory');
                              },
                              child: const Text(
                                'History hide',
                                style: TextStyle(
                                    fontSize: 24, color: Color(0xFFFFDAD5)),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: controller.history
                            ? ElevatedButton(
                                onPressed: () {
                                  controller.updateSettings(false, 'history');
                                },
                                child: const Text(
                                  'History Enabled',
                                  style: TextStyle(fontSize: 24),
                                ))
                            : OutlinedButton(
                                style: const ButtonStyle(
                                    side: MaterialStatePropertyAll(
                                        BorderSide(color: Color(0xFFFFDAD5)))),
                                onPressed: () {
                                  controller.updateSettings(true, 'history');
                                },
                                child: const Text(
                                  'History Disable',
                                  style: TextStyle(
                                      fontSize: 24, color: Color(0xFFFFDAD5)),
                                ),
                              ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: controller.mainBookmrk
                          ? ElevatedButton(
                              onPressed: () {
                                controller.updateSettings(
                                    false, 'mainBookmark');
                              },
                              child: const Text(
                                'Bookmark Hidden',
                                style: TextStyle(fontSize: 24),
                              ))
                          : OutlinedButton(
                              style: const ButtonStyle(
                                  side: MaterialStatePropertyAll(
                                      BorderSide(color: Color(0xFFFFDAD5)))),
                              onPressed: () {
                                controller.updateSettings(true, 'mainBookmark');
                              },
                              child: const Text(
                                'Bookmark Hide',
                                style: TextStyle(
                                    fontSize: 24, color: Color(0xFFFFDAD5)),
                              ),
                            ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Player Screen',
                      style: TextStyle(color: Color(0xFFEDDFDD), fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: controller.videoMute
                          ? ElevatedButton(
                              onPressed: () {
                                controller.updateSettings(false, 'videoMute');
                              },
                              child: const Text(
                                'Muted',
                                style: TextStyle(fontSize: 24),
                              ))
                          : OutlinedButton(
                              style: const ButtonStyle(
                                  side: MaterialStatePropertyAll(
                                      BorderSide(color: Color(0xFFFFDAD5)))),
                              onPressed: () {
                                controller.updateSettings(true, 'videoMute');
                              },
                              child: const Text(
                                'Mute video',
                                style: TextStyle(
                                    fontSize: 24, color: Color(0xFFFFDAD5)),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: controller.playerBookmark
                          ? ElevatedButton(
                              onPressed: () {
                                controller.updateSettings(
                                    false, 'playerBookmark');
                              },
                              child: const Text(
                                'Bookmark is hidden',
                                style: TextStyle(fontSize: 24),
                              ))
                          : OutlinedButton(
                              style: const ButtonStyle(
                                  side: MaterialStatePropertyAll(
                                      BorderSide(color: Color(0xFFFFDAD5)))),
                              onPressed: () {
                                controller.updateSettings(
                                    true, 'playerBookmark');
                              },
                              child: const Text(
                                'Bookmark hide',
                                style: TextStyle(
                                    fontSize: 24, color: Color(0xFFFFDAD5)),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: controller.fullscreen
                          ? ElevatedButton(
                              onPressed: () {
                                controller.updateSettings(false, 'fullscreen');
                              },
                              child: const Text(
                                'Video in fullscreen',
                                style: TextStyle(fontSize: 24),
                              ))
                          : OutlinedButton(
                              style: const ButtonStyle(
                                  side: MaterialStatePropertyAll(
                                      BorderSide(color: Color(0xFFFFDAD5)))),
                              onPressed: () {
                                controller.updateSettings(true, 'fullscreen');
                              },
                              child: const Text(
                                'Start Fullscreen',
                                style: TextStyle(
                                    fontSize: 24, color: Color(0xFFFFDAD5)),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  const Center(
                    child: Text(
                      'Telegram : @BlazingSquad',
                      style: TextStyle(color: Color(0xFFEDE0DE)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
