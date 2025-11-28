import 'package:flutter/material.dart';
import 'package:cinebot/services/tmdb_service.dart';
import 'widgets/trending_card.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<dynamic>> _moviesFuture;
  late Future<List<dynamic>> _tvFuture;

  // Optional: track selected index to show border like Figma
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _moviesFuture = TMDBService.getTrendingMovies();
    _tvFuture = TMDBService.getTrendingTV();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper grid builder for both lists
  Widget _buildGrid(List<dynamic> items, bool isTv) {
    // We use GridView.count with 2 columns like your Figma
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,        // two columns
        childAspectRatio: 0.72,   // adjust to match poster+title height
        mainAxisSpacing: 8,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, idx) {
        final item = items[idx];
        // TMDb uses title (movies) and name (tv)
        final title = isTv ? (item['name'] ?? 'Untitled') : (item['title'] ?? 'Untitled');
        final poster = item['poster_path'] as String?;
        final selected = _selectedIndex == idx && _tabController.index == (isTv ? 1 : 0);

        return Stack(
          children: [
            TrendingCard(
              title: title,
              posterPath: poster,
              selected: selected,
              onTap: () {
                setState(() => _selectedIndex = idx);
                // TODO: navigate to details screen
                // Navigator.pushNamed(context, '/details', arguments: item['id']);
              },
            ),

            // optional small edit icon at top-right of each card (like your Figma)
            Positioned(
              right: 6,
              top: 6,
              child: GestureDetector(
                onTap: () {
                  // small action - e.g., open edit modal or quick actions
                  _showQuickActions(item);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: const Icon(Icons.edit, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Example quick action
  void _showQuickActions(dynamic item) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Watchlist'),
              onTap: () {
                Navigator.pop(context);
                // TODO: call watchlist add
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                // TODO: navigate to details
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AppBar and TabBar on top to switch between Movies / TV
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey.shade200, // looks like your selected pill
          ),
          tabs: const [
            Tab(child: Text('Movies')),
            Tab(child: Text('TV Series')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Movies tab
          FutureBuilder<List<dynamic>>(
            future: _moviesFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              }
              final items = snap.data ?? [];
              return _buildGrid(items, false);
            },
          ),

          // TV Series tab
          FutureBuilder<List<dynamic>>(
            future: _tvFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              }
              final items = snap.data ?? [];
              return _buildGrid(items, true);
            },
          ),
        ],
      ),
    );
  }
}
