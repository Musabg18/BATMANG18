import 'package:flutter/material.dart';

import '../models/player_profile.dart';
import '../models/rating.dart';
import '../services/player_service.dart';

class RatePlayerScreen extends StatefulWidget {
  const RatePlayerScreen({
    super.key,
    required this.profile,
    required this.scoutAccountId,
  });

  final PlayerProfile profile;
  final int scoutAccountId;

  @override
  State<RatePlayerScreen> createState() => _RatePlayerScreenState();
}

class _RatePlayerScreenState extends State<RatePlayerScreen> {
  int _skill = 3;
  int _speed = 3;
  int _physical = 3;
  final _commentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });
    final rating = Rating(
      id: 0,
      playerProfileId: widget.profile.id,
      scoutAccountId: widget.scoutAccountId,
      skill: _skill,
      speed: _speed,
      physical: _physical,
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
      createdAt: DateTime.now(),
    );
    await PlayerService.instance.saveRating(rating);
    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Player')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.profile.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _RatingRow(
              label: 'Skill',
              value: _skill,
              onChanged: (value) => setState(() => _skill = value),
            ),
            const SizedBox(height: 12),
            _RatingRow(
              label: 'Speed',
              value: _speed,
              onChanged: (value) => setState(() => _speed = value),
            ),
            const SizedBox(height: 12),
            _RatingRow(
              label: 'Physical',
              value: _physical,
              onChanged: (value) => setState(() => _physical = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Comment (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Evaluation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label)),
        Expanded(
          child: Row(
            children: List.generate(5, (index) {
              final starValue = index + 1;
              return IconButton(
                onPressed: () => onChanged(starValue),
                icon: Icon(
                  starValue <= value ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
