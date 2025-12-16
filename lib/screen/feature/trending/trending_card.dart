import 'package:flutter/material.dart';

class TrendingCard extends StatefulWidget {
  final String title;
  final String? posterPath;
  final VoidCallback? onTap;
  final bool selected;

  const TrendingCard({
    super.key,
    required this.title,
    this.posterPath,
    this.onTap,
    this.selected = false,
  });

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard>
    with TickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final posterUrl =(widget.posterPath == null || widget.posterPath!.isEmpty)? null: "https://image.tmdb.org/t/p/w342${widget.posterPath}";
    return SizedBox(
      width: 150, // IMPORTANT: fixed width for Wrap layout
      child: GestureDetector(
        onTap: () {
          setState(() => _expanded = !_expanded);
          widget.onTap?.call();
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.selected
                  ? Colors.black
                  : Colors.grey.shade300,
              width: widget.selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // allows vertical growth
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (posterUrl != null)
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(6)),
                  child: Center(
                    child: Image.network(
                      posterUrl,
                      width: 120,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: Text(
                  widget.title,
                  maxLines: _expanded ? null : 1,
                  overflow: _expanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
