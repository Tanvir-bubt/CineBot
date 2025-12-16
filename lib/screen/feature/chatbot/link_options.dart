import 'package:flutter/material.dart';
import 'package:cinebot/services/apis.dart';

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
            await Apis.addToHive(movieName, label);
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
