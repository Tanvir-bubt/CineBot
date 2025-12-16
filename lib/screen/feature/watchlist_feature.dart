import 'package:flutter/material.dart';
import 'package:cinebot/services/movie_service.dart'; // import your Api class
import 'package:cinebot/services/apis.dart'; // import your Api class

class WatchlistFeature extends StatefulWidget {
  const WatchlistFeature({super.key});

  @override
  State<WatchlistFeature> createState() => _WatchlistFeatureState();
}

class _WatchlistFeatureState extends State<WatchlistFeature>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Watch Later', 'Watching', 'Watched'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) => _buildGrid(tab)).toList(),
      ),
    );
  }

  Widget _buildGrid(String flag) {
    final movieNames = Apis.getFromHive(flag); // fetch stored movie names

    if (movieNames.isEmpty) {
      return const Center(child: Text('No movies added'));
    }

    return FutureBuilder<List<Map<String, String>>>(
      future: Future.wait(movieNames.map((name) => MovieService.getMovieInfo(name))),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final movieInfos = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.6, // slightly taller for poster + text
            ),
            itemCount: movieInfos.length,
            itemBuilder: (context, index) {
              final info = movieInfos[index];
              final name = movieNames[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: info['image']!.isNotEmpty
                        ? Image.network(
                      info['image']!,
                      fit: BoxFit.contain,
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Center(child: Text('No Image')),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    info['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
