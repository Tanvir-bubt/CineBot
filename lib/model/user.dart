import 'package:hive_ce/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String password; // store hashed password

  User({
    required this.name,
    required this.email,
    required this.password,
  });
}
