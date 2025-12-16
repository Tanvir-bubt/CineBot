import 'package:hive_ce/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 1)
class Movie {
  @HiveField(0)
  final String userEmail;

  @HiveField(1)
  final String name;

  @HiveField(2)
  int flag; // 0: plan, 1: watching, 2: watched

  @HiveField(3)
  String poster; // mutable, can be empty

  Movie({
    required this.userEmail,
    required this.name,
    required this.flag,
    this.poster = '',
  });
}
