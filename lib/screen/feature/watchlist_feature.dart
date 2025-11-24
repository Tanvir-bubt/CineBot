import 'package:flutter/material.dart';

class WatchlistFeature extends StatefulWidget {
  const WatchlistFeature({super.key});

  @override
  State<WatchlistFeature> createState() => _WatchlistFeatureState();
}

class _WatchlistFeatureState extends State<WatchlistFeature> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: ListView(
        children: const[],
      ),
    );
  }
}
