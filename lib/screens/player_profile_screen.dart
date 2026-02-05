import 'dart:io';

import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/player_profile.dart';
import '../services/auth_service.dart';
import '../services/player_service.dart';
import 'contact_player_screen.dart';
import 'rate_player_screen.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({
    super.key,
    required this.account,
    this.profileId,
  });

  final Account account;
  final int? profileId;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  PlayerProfile? _profile;
  bool _isEditing = false;
  bool _isLoading = true;
  String? _error;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _positionController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _photoController = TextEditingController();
  final _videoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _positionController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _photoController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final auth = AuthService.instance;
      PlayerProfile? profile;
      if (widget.profileId != null) {
        final players = await PlayerService.instance.fetchPlayers();
        profile = players.firstWhere((p) => p.id == widget.profileId);
      } else {
        profile = await auth.fetchProfileForAccount(widget.account.id);
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _profile = profile;
        _isLoading = false;
        if (profile != null) {
          _nameController.text = profile.name;
          _ageController.text = profile.age.toString();
          _positionController.text = profile.position;
          _heightController.text = profile.height ?? '';
          _weightController.text = profile.weight ?? '';
          _photoController.text = profile.photoPath ?? '';
          _videoController.text = profile.videoPath ?? '';
        }
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_profile == null) {
      return;
    }
    final updated = _profile!.copyWith(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? _profile!.age,
      position: _positionController.text.trim(),
      height: _heightController.text.trim().isEmpty
          ? null
          : _heightController.text.trim(),
      weight: _weightController.text.trim().isEmpty
          ? null
          : _weightController.text.trim(),
      photoPath: _photoController.text.trim().isEmpty
          ? null
          : _photoController.text.trim(),
      videoPath: _videoController.text.trim().isEmpty
          ? null
          : _videoController.text.trim(),
    );
    await AuthService.instance.updateProfile(updated);
    setState(() {
      _profile = updated;
      _isEditing = false;
    });
  }

  bool get _isOwnProfile {
    return widget.account.role == 'player' && widget.profileId == null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Text(_error ?? 'Profile not available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Profile'),
        actions: _isOwnProfile
            ? [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  child: Text(_isEditing ? 'Cancel' : 'Edit'),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 56,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                backgroundImage:
                    _profile!.photoPath != null && _profile!.photoPath!.isNotEmpty
                        ? FileImage(File(_profile!.photoPath!))
                        : null,
                child:
                    _profile!.photoPath == null || _profile!.photoPath!.isEmpty
                        ? const Icon(Icons.person, size: 56)
                        : null,
              ),
            ),
            const SizedBox(height: 16),
            if (_isEditing) ...[
              _buildTextField('Name', _nameController),
              const SizedBox(height: 12),
              _buildTextField('Age', _ageController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField('Position', _positionController),
              const SizedBox(height: 12),
              _buildTextField('Height (optional)', _heightController),
              const SizedBox(height: 12),
              _buildTextField('Weight (optional)', _weightController),
              const SizedBox(height: 12),
              _buildTextField('Photo path (optional)', _photoController),
              const SizedBox(height: 12),
              _buildTextField('Video path (optional)', _videoController),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save Profile'),
                ),
              ),
            ] else ...[
              Text(
                _profile!.name,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Age ${_profile!.age} • ${_profile!.position}'),
              const SizedBox(height: 8),
              if (_profile!.height != null || _profile!.weight != null)
                Text(
                  'Height ${_profile!.height ?? '--'} • Weight ${_profile!.weight ?? '--'}',
                ),
              const SizedBox(height: 16),
              FutureBuilder<double>(
                future: PlayerService.instance.fetchOverallRating(_profile!.id),
                builder: (context, snapshot) {
                  final rating = snapshot.data ?? 0;
                  return Row(
                    children: [
                      Text(
                        rating == 0 ? '--' : rating.toStringAsFixed(1),
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Text('Overall Rating'),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              if (_profile!.videoPath != null && _profile!.videoPath!.isNotEmpty)
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Video preview: ${_profile!.videoPath!}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Text('No video preview yet.')),
                ),
            ],
            if (!_isEditing && widget.account.role == 'scout') ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RatePlayerScreen(
                          profile: _profile!,
                          scoutAccountId: widget.account.id,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.star_rate),
                  label: const Text('Rate Player'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContactPlayerScreen(
                          profile: _profile!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.mail_outline),
                  label: const Text('Contact Player'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
