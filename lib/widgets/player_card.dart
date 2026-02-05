import 'dart:io';

import 'package:flutter/material.dart';

import '../models/player_profile.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.profile,
    required this.overallRating,
    required this.onTap,
  });

  final PlayerProfile profile;
  final double overallRating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                backgroundImage:
                    profile.photoPath != null && profile.photoPath!.isNotEmpty
                        ? FileImage(File(profile.photoPath!))
                        : null,
                child: profile.photoPath == null || profile.photoPath!.isEmpty
                    ? const Icon(Icons.person, size: 28)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text('Age ${profile.age} • ${profile.position}'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    overallRating == 0
                        ? '--'
                        : overallRating.toStringAsFixed(1),
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Text('Overall'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
