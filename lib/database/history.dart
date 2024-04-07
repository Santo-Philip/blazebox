import 'package:hive/hive.dart';

part 'history.g.dart';

@HiveType(typeId: 2)
class History {
  @HiveField(0)
  String name;

  @HiveField(1)
  String size;

  @HiveField(2)
  String link;

  @HiveField(3)
  String thumb;

  History({
    required this.name,
    required this.link,
    required this.size,
    required this.thumb
  });
}