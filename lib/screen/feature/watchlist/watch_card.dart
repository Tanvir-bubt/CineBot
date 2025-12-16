import 'package:flutter/material.dart';
import 'package:cinebot/model/movie.dart';
import 'package:cinebot/services/movie_service.dart';
import 'package:cinebot/services/hive_service.dart';

class WatchlistCard extends StatefulWidget {
  final Movie movie;
  final bool selected;
  final String currentTab;
  final VoidCallback onTap;
  final Function(String action) onAction;

  const WatchlistCard({
    super.key,
    required this.movie,
    required this.selected,
    required this.currentTab,
    required this.onTap,
    required this.onAction,
  });

  @override
  State<WatchlistCard> createState() => _WatchlistCardState();
}

class _WatchlistCardState extends State<WatchlistCard> {
  late String _poster;
  bool _fetchAttempted = false;

  @override
  void initState() {
    super.initState();
    _poster = widget.movie.poster;
  }

  Future<void> _fetchPosterIfNeeded() async {
    if (_fetchAttempted) return;
    _fetchAttempted = true;

    final info =
    await MovieService.getMovieInfo(widget.movie.name);

    final fetchedPoster = info['image'];

    if (fetchedPoster != null && fetchedPoster.isNotEmpty) {
      setState(() {
        _poster = fetchedPoster;
      });

      // 🔒 Persist it so we never fetch again
      await HvService.addOrUpdateMovie(
        widget.movie.name,
        widget.movie.flag,
        poster: fetchedPoster,
      );
    }
  }

  Widget _buildPoster() {
    if (_poster.isEmpty) {
      _fetchPosterIfNeeded();
      return _noImage();
    }

    return Image.network(
      _poster,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _noImage(),
    );
  }

  Widget _noImage() {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Text(
        '<no images available>',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.selected ? Colors.black : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(8)),
                child: _buildPoster(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                widget.movie.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),

            if (widget.selected) _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        if (widget.currentTab != 'plan_to_watch')
          _actionButton('Move to Plan', 'move_plan'),
        if (widget.currentTab != 'watching')
          _actionButton('Move to Watching', 'move_watching'),
        if (widget.currentTab != 'watched')
          _actionButton('Move to Watched', 'move_watched'),
        _actionButton('Remove', 'remove', destructive: true),
      ],
    );
  }

  Widget _actionButton(
      String label,
      String action, {
        bool destructive = false,
      }) {
    return TextButton(
      onPressed: () => widget.onAction(action),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: destructive ? Colors.red : Colors.black,
        ),
      ),
    );
  }
}
