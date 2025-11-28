import 'package:flutter/material.dart';

/// Small reusable grid card for movie / series
class TrendingCard extends StatelessWidget {
  final String title;
  final String? posterPath; // poster path from TMDB (poster_path)
  final VoidCallback? onTap;
  final bool selected; // to show selected outline

  const TrendingCard({
    super.key,
    required this.title,
    this.posterPath,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Full poster URL builder (w342 gives decent mobile size)
    final posterUrl = (posterPath == null || posterPath!.isEmpty)
        ? null
        : "https://image.tmdb.org/t/p/w342$posterPath";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Card margin + subtle border to match your Figma
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster area
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: posterUrl != null
                    ? Image.network(
                  posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => _placeholder(),
                )
                    : _placeholder(),
              ),
            ),

            // Title area (padding like Figma)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Local placeholder widget when image missing
  Widget _placeholder() => Container(
    color: Colors.grey.shade200,
    child: const Center(
      child: Icon(Icons.image, size: 48, color: Colors.black54),
    ),
  );
}
