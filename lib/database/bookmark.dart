import 'package:hive/hive.dart';

part 'bookmark.g.dart';

@HiveType(typeId: 1)
class BookMark {
  @HiveField(0)
  String name;

  @HiveField(1)
  String size;

  @HiveField(2)
  String link;

  @HiveField(3)
  String thumb;

  BookMark({
    required this.name,
    required this.link,
    required this.size,
    required this.thumb
  });
}