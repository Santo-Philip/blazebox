import 'package:blazebox/database/datastore.dart';
import 'package:blazebox/video.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151516),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FastCachedImageConfig.clearAllCachedImages();
                await HistoryStore().removeDb();
              },
              icon: const Icon(
                Icons.delete_outline,
                size: 34,
              )),
          const SizedBox(
            width: 20,
          )
        ],
        toolbarHeight: 80,
        elevation: 0,
        foregroundColor: const Color(0xFFFFEDEB),
        backgroundColor: const Color(0xFF5F1224),
        title: const Text(
          'History',
          style: TextStyle(color: Color(0xFFFFEDEB)),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          HistoryList(),
          const SizedBox(
            height: 20,
          )
        ],
      )),
    );
  }
}

class HistoryList extends StatelessWidget {
  final HistoryStore dataStore = HistoryStore();

  HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HistoryStore.box.listenable(),
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
              leading: SizedBox(
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
                HistoryStore().deleteBookMark(index: currentIndex);
              },
              onTap: () {
                Get.offAll(
                  () => const PlayerScreen(),
                  arguments: [
                    {'name': data.name},
                    {'size': data.size},
                    {'link': data.link},
                    {'thumb': data.thumb}
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
