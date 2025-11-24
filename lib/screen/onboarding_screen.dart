

import 'package:cinebot/helper/global.dart';
import 'package:cinebot/model/onboard.dart';
import 'package:cinebot/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PageController();

    final list = [
      Onboard(
        title: 'Your Movie Buddy Awaits!',
        subtitle: 'Discover films you’ll love—personalized just for you.',
        lottie: 'popcorn'),

      Onboard(
        title: 'Tell Us What You Like',
        subtitle: 'Pick genres, moods, and favorites so CineBot can suggest spot-on movies.',
        lottie: 'pick'),

      Onboard(
        title: 'Your Movie Chatbot is Ready',
        subtitle: 'Ask CineBot for recommendations anytime. From thrillers to rom-coms, it’s got you covered.',
        lottie: 'bot'),
    ];

    return Scaffold(
      body: PageView.builder(
        controller: c,
        itemCount: list.length,
        itemBuilder: (ctx, ind) {
          final isLast = ind == list.length - 1;

        return Column(
        children: [
          Lottie.asset('assets/lottie/${list[ind].lottie}.json',
          height: mq.height * .6, width: isLast ? mq.width * .7 : null),
          Text(
            list[ind].title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: .5
            )
          ),

          SizedBox(height: mq.height * .015),
          
          SizedBox(
            width: mq.width * .75,
            child: Text(
              list[ind].subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                letterSpacing: .5,
                color: Colors.black54,
              ),
            ),
          ),
          const Spacer(),
          
          Wrap(
            spacing: 10,
            children: List.generate(
              list.length,
              (i) => Container(
                width: i == ind ? 15 : 10,
                height: 8,
                decoration: BoxDecoration(
                  color: i == ind ? Colors.grey : Colors.grey.shade300,
                  borderRadius:
                  const BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
          ),

          const Spacer(),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              backgroundColor: const Color.fromARGB(139, 255, 238, 0),
              shape: const StadiumBorder(),
              elevation: 10,
              textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black12),
              minimumSize: Size(mq.width * .5, 50),
            ),
            onPressed: () {
              if (isLast) {
                Get.off(() => const HomeScreen());
                //ignore: use_build_context_synchronously
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(builder: (_) => const HomeScreen()));
              } else {
                c.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              }              
            },
            child: Text(isLast ? 'Done' : 'Next'),
          ),
          const Spacer(flex: 2),
        ],
      );
        
      },),
    );
  }
}