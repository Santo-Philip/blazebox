import 'package:blazebox/controller/settingscontroller.dart';
import 'package:blazebox/database/bookmark.dart';
import 'package:blazebox/database/datastore.dart';
import 'package:blazebox/splash.dart';
import 'package:dio/dio.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<PlayerScreen> {
  late FlickManager flickManager;

  dynamic title;
  dynamic size;
  dynamic link;
  dynamic thumb;
  final dio = Dio();
  final settings = Get.find<SettingsController>();

  @override
  void initState() {
    super.initState();
     dynamic arguments = Get.arguments;
     title = arguments[0]['name'];
     size = arguments[1]['size'];
     link = arguments[2]['link'];
     thumb = arguments[3]['thumb'];
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(link),
      ),
    );
    if (settings.fullscreen == true) {
      flickManager.flickControlManager?.toggleFullscreen();
    }
    if (settings.videoMute == true) {
      flickManager.flickControlManager?.mute();
    }
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF231C1B),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  if (flickManager.flickControlManager!.isFullscreen) {
                    flickManager.flickControlManager!.exitFullscreen();
                  } else {
                    Get.offAll(() => const SplashScreen());
                  }
                },
                child: FlickVideoPlayer(flickManager: flickManager),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                height: 80,
                color: const Color(0xFF231C1B),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Color(0xFFFFEDEB), fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 80,
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          final values = BookMark(
                              name: title, link: link, size: size, thumb: thumb);
                          BookMarkStore().addValue(userModel: values);
                        },
                        icon: const Icon(
                          Icons.bookmark,
                          color: Colors.amber,
                        ),
                        label: const Text(
                          'Save',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          String? externalStorageDirPath;
                          externalStorageDirPath =
                              (await getApplicationDocumentsDirectory())
                                  .absolute
                                  .path;
                          await FlutterDownloader.enqueue(
                            url: link,
                            allowCellular: true,
                            saveInPublicStorage: true,
                            savedDir: externalStorageDirPath,
                            openFileFromNotification: true,
                            showNotification: true,
                          );
                        },
                        style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                        label: Text(
                          size,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFFFFEDEB))),
                        onPressed: () async {
                          Uri url = Uri.parse('https://razorpay.me/@mehub');
                          await launchUrl(url);
                        },
                        icon: const Icon(
                          Icons.coffee,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Donate',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      OutlinedButton.icon(onPressed: () async{
                       await Share.share(link,subject: title);
                      },icon: Icon(Icons.share), label: Text("Share",style: const TextStyle(color: Colors.white),),)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if(settings.playerBookmark == false)
              ItemsList(),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}

class ItemsList extends StatelessWidget {
  final BookMarkStore dataStore = BookMarkStore();

  ItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: BookMarkStore.box.listenable(),
      builder: (context, Box box, widget) {
        List<dynamic> allItems = box.values.toList().reversed.toList();

        return ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 20,
            );
          },
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: allItems.length,
          itemBuilder: (context, index) {
            var data = allItems[index];
            int currentIndex = box.values.toList().indexOf(data);
            return ListTile(
              title: Text(
                data.name ?? '',
                style: const TextStyle(color: Color(0xFFFFEDEB)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              leading:SizedBox(
                  height: double.infinity,
                  width: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FastCachedImage(
                      fadeInDuration: const Duration(milliseconds: 500),
                      fit: BoxFit.cover,
                      url: data.thumb,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                      loadingBuilder: (context, progress) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            if (progress.isDownloading &&
                                progress.totalBytes != null)
                              Text(
                                  '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                                  style: const TextStyle(color: Colors.red)),
                            SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                    color: Colors.red,
                                    value: progress.progressPercentage.value)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              onLongPress: () {
                BookMarkStore().deleteBookMark(index: currentIndex);
              },
              onTap: () {
                Get.off(() => const PlayerScreen(), arguments: [
                  {'name': data.name},
                  {'size': data.size},
                  {'link': data.link},
                  {'thumb': data.thumb}
                ],);
              },
            );
          },
        );
      },
    );
  }
}
