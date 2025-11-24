import 'package:cinebot/helper/global.dart';
import 'package:cinebot/model/home_type.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeCard extends StatelessWidget {
  
  final HomeType homeType;

  const HomeCard({super.key, required this.homeType});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: homeType.onTap,
      child: Card(
        color: const Color.fromRGBO(0, 191, 99, 0.4), // Soft tint of Bot Green
        elevation: 2, // Slight elevation for better contrast
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Lottie animation
              Lottie.asset(
                'assets/lottie/${homeType.lottie}',
                width: mq.width * 0.25, // Slightly smaller for better balance
                fit: BoxFit.contain,
              ),
      
              // Text + Icon (for better visual hierarchy)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text.rich(
                    TextSpan(
                      text: homeType.title,
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 27, 61, 1), // Use Cine Navy for text
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        if (homeType.subtitle.isNotEmpty)
                          TextSpan(
                            text: '\n${homeType.subtitle}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
      
              // Optional arrow icon to make it feel tappable
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color.fromRGBO(0, 191, 99, 0.403921568627451),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}