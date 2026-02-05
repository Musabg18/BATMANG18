import 'package:flutter/material.dart';

import '../models/account.dart';
import '../services/player_service.dart';
import '../widgets/player_card.dart';
import 'player_profile_screen.dart';

class PlayersFeedScreen extends StatefulWidget {
  const PlayersFeedScreen({super.key, required this.account});

  final Account account;

  @override
  State<PlayersFeedScreen> createState() => _PlayersFeedScreenState();
}

class _PlayersFeedScreenState extends State<PlayersFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
      ),
      body: FutureBuilder(
        future: PlayerService.instance.fetchPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final players = snapshot.data ?? [];
          if (players.isEmpty) {
            return const Center(child: Text('No players yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final player = players[index];
              return FutureBuilder<double>(
                future:
                    PlayerService.instance.fetchOverallRating(player.id),
                builder: (context, ratingSnapshot) {
                  return PlayerCard(
                    profile: player,
                    overallRating: ratingSnapshot.data ?? 0,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlayerProfileScreen(
                            account: widget.account,
                            profileId: player.id,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: players.length,
          );
        },
      ),
    );
  }
}
