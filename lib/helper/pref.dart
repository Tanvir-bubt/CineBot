import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Pref {
  static late Box _box;
  static Future<void> initialize() async {

    // Initialize Hive and set the default directory for Hive storage
    Hive.init((await getApplicationDocumentsDirectory()).path);
    _box = await Hive.openBox('myData');
  }

  static bool get showOnboarding =>
  _box.get('showOnboarding', defaultValue: true);
  static set showOnboarding(bool v) => _box.put('showOnboarding', v);
  }
