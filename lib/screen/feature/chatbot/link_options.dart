import 'package:cinebot/services/hive_service.dart';
import 'package:flutter/material.dart';

class LinkOptions {
  static void show(BuildContext context, String movieName) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add "$movieName" to:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildOptionButton(context, 'Watch Later', movieName),
            _buildOptionButton(context, 'Watching', movieName),
            _buildOptionButton(context, 'Watched', movieName),
          ],
        ),
      ),
    );
  }

  static Widget _buildOptionButton(BuildContext context, String label, String movieName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.of(context).pop();
          try {
            int f = switch (label.toLowerCase()) {
              'watch later' => 0,
              'watching' => 1,
              'watched' => 2,
              _ => 0, // default fallback
            };

            await HvService.addOrUpdateMovie(movieName, f);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added "$movieName" to "$label"')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add: $e')),
            );
          }
        },
        child: Text(label),
      ),
    );
  }
}
