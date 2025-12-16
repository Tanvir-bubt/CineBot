import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:cinebot/model/user.dart';
import 'package:cinebot/model/movie.dart';

// watchlist >> profile >> login

class HvService {
  static const String _userBox = 'userBox';
  static const String _movieBox = 'movieBox';
  static const String _appBox = 'appBox';
  static bool showOnboarding=true;
  static String userEmail='';
  static bool get isLoggedIn => userEmail.isNotEmpty;


  /// ────────────── INIT HIVE ──────────────

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(MovieAdapter());
    await Hive.openBox<User>(_userBox);
    await Hive.openBox<Movie>(_movieBox);
    await Hive.openBox<Map>(_appBox);
    final appBox = Hive.box<Map>(_appBox);
    Map<String, dynamic> appData = Map<String, dynamic>.from(appBox.get('appData') ?? {});

    if (!appData.containsKey('showOnboarding')) {
      // first time, set default value to 1 (true)
      appData['showOnboarding'] = 0;
      await appBox.put('appData', appData);
    }

    showOnboarding = appData['showOnboarding'] == 1;
  }

  // ────────────── USER CRUD ──────────────
  static Future<void> saveUser(User user) async {
    final box = Hive.box<User>(_userBox);
    await box.put(user.email, user);
  }

  /// Get user by email only (for registration checks)
  static User? getUserByEmail(String email) {
    final box = Hive.box<User>(_userBox);
    return box.get(email);
  }


  static User? getUser(String email, String password) {
    final box = Hive.box<User>(_userBox);
    final user = box.get(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  static Future<void> updateUser(String email, {String? newName, String? newPassword}) async {
    final box = Hive.box<User>(_userBox);
    final user = box.get(email);
    if (user != null) {
      final updatedUser = User(
        name: newName ?? user.name,
        email: user.email, // keep email stable
        password: newPassword ?? user.password,
      );
      await box.put(email, updatedUser);
    }
  }


  // ────────────── MOVIE CRUD ──────────────
   static Future<List<Movie>> getUserMovies() async {
    final box = Hive.box<Movie>(_movieBox);
    return box.values
        .where((movie) => movie.userEmail == userEmail)
        .toList();
  }


  static Future<void> deleteMovie(String userEmail, String movieName) async {
    final box = Hive.box<Movie>(_movieBox);
    final key = '${userEmail}_$movieName';
    await box.delete(key);
  }


  static Future<void> addOrUpdateMovie(String movieName,int flag, {String? poster,}) async {
    final box = Hive.box<Movie>(_movieBox);
    final key = '${userEmail}_$movieName';

    final existingMovie = box.get(key);

    if (existingMovie != null) {
      existingMovie.flag = flag;

      // only update poster if provided
      if (poster != null && poster.isNotEmpty) {
        existingMovie.poster = poster;
      }

      await box.put(key, existingMovie);
    } else {
      final newMovie = Movie(
        userEmail: userEmail,
        name: movieName,
        flag: flag,
        poster: poster ?? '',
      );

      await box.put(key, newMovie);
    }
  }


  // ────────────── APP SETTINGS ──────────────
  static Future<void> saveAppData(Map<String, dynamic> appData) async {
    final box = Hive.box<Map>(_appBox);
    await box.put('appData', appData);
  }

  static Map<String, dynamic> getAppData() {
    final box = Hive.box<Map>(_appBox);
    return Map<String, dynamic>.from(box.get('appData') ?? {});
  }

  static Future<void> setShowOnboarding(bool value) async {
    showOnboarding = value;
    final appBox = Hive.box<Map>(_appBox);
    Map<String, dynamic> appData = Map<String, dynamic>.from(appBox.get('appData') ?? {});
    appData['showOnboarding'] = value ? 1 : 0;
    await appBox.put('appData', appData);
  }
}
