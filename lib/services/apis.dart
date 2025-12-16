import 'dart:core';
import 'package:hive/hive.dart';

class Apis {
  static final String aiKey='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';
  static final String aiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static final String model = 'nvidia/nemotron-nano-12b-v2-vl:free';                   // 'openai/gpt-oss-20b:free'
  static final String movieKey = "40e7884ceab9461aaa67f63638459e60";
  //   Hive apis
  static String _getBoxName(String flag) {
    switch (flag.toLowerCase()) {
      case 'later':
        return 'watch_later';
      case 'watching':
        return 'watching';
      case 'watched':
        return 'watched';
      default:
        throw Exception('Unknown flag: $flag');
    }
  }

  static Future<void> addToHive(String movieName, String flag) async {
    final box = Hive.box<String>(_getBoxName(flag));
    if (!box.values.contains(movieName)) {
      await box.add(movieName);
      print("saved movie: $movieName");
    }
  }
  static List<String> getFromHive(String flag) {
    final box = Hive.box<String>(_getBoxName(flag));
    return box.values.toList();
  }

}
