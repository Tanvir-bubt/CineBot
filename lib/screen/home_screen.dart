import 'package:cinebot/helper/global.dart';
import 'package:cinebot/model/home_type.dart';
import 'package:cinebot/services/hive_service.dart';
import 'package:cinebot/widget/home_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    HvService.showOnboarding = false;
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                mq.width * 0.06,
                24,
                mq.width * 0.06,
                8,
              ),
              sliver: SliverToBoxAdapter(child: _buildHeader(textTheme)),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                mq.width * 0.06,
                24,
                mq.width * 0.06,
                8,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'What are you in the mood for?',
                  style: textTheme.headlineMedium,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                mq.width * 0.04,
                8,
                mq.width * 0.04,
                32,
              ),
              sliver: SliverList.builder(
                itemCount: HomeType.values.length,
                itemBuilder: (context, index) {
                  return HomeCard(homeType: HomeType.values[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.movie_creation_outlined,
                color: Color(0xFF6C63FF),
                size: 25,
              ),
            ),
            const SizedBox(width: 14),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Cine',
                    style: TextStyle(
                      color: Color(0xFFF5F5F7),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: 'Bot',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text('Welcome back 👋', style: textTheme.bodyMedium),
        const SizedBox(height: 6),
        Text('Find your next favorite movie.', style: textTheme.displayMedium),
        const SizedBox(height: 10),
        Text(
          'Explore, discover and keep track of movies you love.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
