import 'dart:core';

class Apis {
  static final String aiKey='2114eb47ee8320e016e43b9d320f86197';
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

//f686ecebe8cfc3ebc1ad7b41dac50fa
}
