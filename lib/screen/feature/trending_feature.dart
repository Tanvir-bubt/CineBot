import 'package:flutter/material.dart';

class TrendingFeature extends StatefulWidget {
  const TrendingFeature({super.key});

  @override
  State<TrendingFeature> createState() => _TrendingFeatureState();
}

class _TrendingFeatureState extends State<TrendingFeature> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
      ),
      body: ListView(
        children: const[],
      ),
    );
  }
}
