import 'package:cinebot/screen/feature/chatbot/chatbot_feature.dart';
import 'package:cinebot/screen/feature/profile_feature.dart';
import 'package:cinebot/screen/feature/trending/trending_screen.dart';
import 'package:cinebot/screen/feature/watchlist_feature.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum HomeType{whatToWatch, trendingNow, watchList, profile}

extension MyHomeType on HomeType{ 
  String get title => switch (this) {
    HomeType.whatToWatch => 'Your movie buddy is ready!',
    HomeType.trendingNow => 'Trending Now' ,
    HomeType.watchList => 'From your Watchlist',
    HomeType.profile => 'Your Profile'
    };

    String get subtitle => switch (this) {
    HomeType.whatToWatch => 'Discover movies for your mood',
    HomeType.trendingNow => "See what's hot this week",
    HomeType.watchList => 'Track your saved films',
    HomeType.profile => ''
    };

    String get lottie => switch (this) {
    HomeType.whatToWatch => 'bot.json',
    HomeType.trendingNow => 'trending.json' ,
    HomeType.watchList => 'star.json',
    HomeType.profile => 'profile.json'
    };

    VoidCallback get onTap => switch (this) {
    HomeType.whatToWatch => () => Get.to(() => const ChatbotFeature()),
    HomeType.trendingNow => () => Get.to(() => const TrendingScreen()),
    HomeType.watchList => () => Get.to(() => const WatchlistFeature()),
    HomeType.profile => () => Get.to(() => const ProfileFeature())
  };
}