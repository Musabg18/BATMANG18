import 'package:flutter/material.dart';

import '../models/player_profile.dart';

class ContactPlayerScreen extends StatelessWidget {
  const ContactPlayerScreen({super.key, required this.profile});

  final PlayerProfile profile;

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Player')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Reach out through your preferred channel.'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showMessage(
                  context,
                  'Email intent prepared for ${profile.name}.',
                ),
                icon: const Icon(Icons.email_outlined),
                label: const Text('Email'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showMessage(
                  context,
                  'Phone call intent prepared for ${profile.name}.',
                ),
                icon: const Icon(Icons.call_outlined),
                label: const Text('Phone Call'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showMessage(
                  context,
                  'WhatsApp message prepared for ${profile.name}.',
                ),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('WhatsApp'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
