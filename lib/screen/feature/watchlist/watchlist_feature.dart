import 'package:flutter/material.dart';
import 'package:cinebot/services/hive_service.dart';
import 'package:cinebot/model/movie.dart';
import 'watch_card.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Map<String, List<Movie>>> _watchlistFuture;

  // keep selection PER TAB
  final Map<int, int?> _selectedIndexPerTab = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadWatchlist();
  }

  void _loadWatchlist() {
    setState(() {
      _selectedIndexPerTab.clear(); // reset selection on reload
      _watchlistFuture = HvService.getUserMovies().then((movies) {
        return {
          'plan_to_watch': movies.where((m) => m.flag == 0).toList(),
          'watching': movies.where((m) => m.flag == 1).toList(),
          'watched': movies.where((m) => m.flag == 2).toList(),
        };
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildGrid(List<Movie> items, String currentTab) {
    final tabIndex = _tabController.index;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: List.generate(items.length, (idx) {
          final item = items[idx];
          final selected = _selectedIndexPerTab[tabIndex] == idx;

          return WatchlistCard(
            movie: item, // pass the whole Movie object
            selected: selected,
            currentTab: currentTab,
            onTap: () {
              setState(() {
                _selectedIndexPerTab[tabIndex] =
                selected ? null : idx;
              });
            },
            onAction: (action) async {
              if (action == 'remove') {
                await HvService.deleteMovie(HvService.userEmail, item.name);
              } else {
                final newFlag = action == 'move_plan'? 0: action == 'move_watching'? 1: 2;
                await HvService.addOrUpdateMovie(item.name,newFlag,poster: item.poster,);
              }
              _loadWatchlist();
            },
          );

        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Watchlist',
          style: TextStyle(color: Colors.black),
        ),
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
            Tab(text: 'Plan to Watch'),
            Tab(text: 'Watching'),
            Tab(text: 'Watched'),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, List<Movie>>>(
        future: _watchlistFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final data = snap.data ?? {
            'plan_to_watch': <Movie>[],
            'watching': <Movie>[],
            'watched': <Movie>[],
          };

          return TabBarView(
            controller: _tabController,
            children: [
              _buildGrid(data['plan_to_watch']!, 'plan_to_watch'),
              _buildGrid(data['watching']!, 'watching'),
              _buildGrid(data['watched']!, 'watched'),
            ],
          );
        },
      ),

    );
  }
}
