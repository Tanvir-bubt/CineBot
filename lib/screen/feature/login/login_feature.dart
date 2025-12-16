import 'package:cinebot/services/hive_service.dart';
import 'package:cinebot/model/user.dart';

class LoginFeature {
  static bool login(String email, String password) {
    final user = HvService.getUser(email, password);
    if (user != null) {
      HvService.userEmail = user.email;
      return true;
    }
    return false;
  }

  /// Register user, returns true if successful
  static Future<bool> register(String name, String email, String password) async {
    final existing = HvService.getUserByEmail(email);
    if (existing != null) return false;

    final newUser = User(name: name, email: email, password: password);
    await HvService.saveUser(newUser);
    HvService.userEmail = newUser.email;
    return true;
  }
}
