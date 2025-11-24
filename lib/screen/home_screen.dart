import 'package:cinebot/helper/global.dart';
import 'package:cinebot/helper/pref.dart';
import 'package:cinebot/model/home_type.dart';
import 'package:cinebot/widget/home_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinebot/widget/app_sidebar.dart'; // ✅ Import Sidebar

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false; // Set onboarding as completed
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the media query variable for global use
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white60,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Cine',
                style: TextStyle(
                  color: const Color.fromRGBO(0, 27, 61, 1), // Navy for Cine
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: 'Bot',
                style: TextStyle(
                  color: const Color.fromRGBO(0, 191, 99, 0.5019607843137255), // Green for Bot
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            onPressed: () {},
            icon: Icon(Icons.brightness_4_rounded, color: Colors.grey),
          )
        ],
      ),

      drawer: const AppSidebar(), // ✅ Added Sidebar Here

      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * .03,
          vertical: mq.height * .01,
        ),
        children: HomeType.values
            .map((e) => HomeCard(homeType: e))
            .toList(),
      ),
    );
  }
}
