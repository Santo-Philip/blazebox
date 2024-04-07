import 'package:blazebox/database/bookmark.dart';
import 'package:blazebox/database/history.dart';
// import 'package:blazebox/database/settings.dart';
import 'package:hive/hive.dart';

class BookMarkStore {
  static const boxName = 'bookmark';
  static Box<BookMark> box = Hive.box(boxName);

  Future<void> getvalues({required String id}) async {
    box.get(id);
  }

  Future addValue({required BookMark userModel}) async {
    await box.add(userModel);
  }

  Future deleteBookMark({required int index}) async {
    await box.deleteAt(index);
  }
}

class HistoryStore {
  static const boxName = 'history';
  static Box<History> box = Hive.box(boxName);

  Future<void> getvalues({required String id}) async {
    box.get(id);
  }

  Future addValue({required History historyModel}) async {
    await box.add(historyModel);
  }

  Future deleteBookMark({required int index}) async {
    await box.deleteAt(index);
  }

  Future removeDb()async{
    var keys = box.keys.toList();
    await box.deleteAll(keys);
  }
}

// class SettingStore {
//   static const boxName = 'settings';
//   static Box<Settings> box = Hive.box(boxName);

//   Future<void> getvalues({required int id}) async {
//     box.getAt(id);
//   }

//   Future updateValue({required int id,required Settings value}) async {
//     await box.put(id, value);
//   }
// }
