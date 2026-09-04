import 'package:cinebot/model/home_type.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeCard extends StatelessWidget {
  final HomeType homeType;

  const HomeCard({super.key, required this.homeType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: homeType.onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 120),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                _buildAnimation(),
                const SizedBox(width: 16),
                Expanded(child: _buildContent(textTheme)),
                const SizedBox(width: 8),
                _buildArrow(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(6),
      child: Lottie.asset(
        'assets/lottie/${homeType.lottie}',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildContent(TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          homeType.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFFF5F5F7),
            fontWeight: FontWeight.w700,
          ),
        ),
        if (homeType.subtitle.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            homeType.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFFA6A6B0),
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildArrow(ThemeData theme) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: theme.colorScheme.primary,
        size: 19,
      ),
    );
  }
}
