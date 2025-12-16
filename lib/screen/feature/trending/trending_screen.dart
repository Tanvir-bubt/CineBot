import 'package:flutter/material.dart';
import 'package:cinebot/services/movie_service.dart';
import 'trending_card.dart';

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

  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _moviesFuture = MovieService.getTrendingMovies();
    _tvFuture = MovieService.getTrendingTV();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildGrid(List<dynamic> items, bool isTv) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: List.generate(items.length, (idx) {
          final item = items[idx];
          final title = isTv
              ? (item['name'] ?? 'Untitled')
              : (item['title'] ?? 'Untitled');

          final poster = item['poster_path'] as String?;
          final selected =
              _selectedIndex == idx &&
                  _tabController.index == (isTv ? 1 : 0);

          return TrendingCard(
            title: title,
            posterPath: poster,
            selected: selected,
            onTap: () => setState(() => _selectedIndex = idx),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey.shade200,
          ),
          tabs: const [
            Tab(text: 'Movies'),
            Tab(text: 'TV Series'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<dynamic>>(
            future: _moviesFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              }
              return _buildGrid(snap.data ?? [], false);
            },
          ),
          FutureBuilder<List<dynamic>>(
            future: _tvFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              }
              return _buildGrid(snap.data ?? [], true);
            },
          ),
        ],
      ),
    );
  }
}
