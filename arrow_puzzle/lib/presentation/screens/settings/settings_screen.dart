import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/providers.dart';

/// Settings screen with toggles and actions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Audio section
          _SectionHeader(title: 'Audio'),
          _SettingsTile(
            icon: Icons.volume_up,
            title: 'Sound Effects',
            trailing: Switch(
              value: progress.soundEnabled,
              onChanged: (_) {
                ref.read(progressProvider.notifier).toggleSound();
              },
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            icon: Icons.music_note,
            title: 'Music',
            trailing: Switch(
              value: progress.musicEnabled,
              onChanged: (_) {
                ref.read(progressProvider.notifier).toggleMusic();
              },
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            icon: Icons.vibration,
            title: 'Vibration',
            trailing: Switch(
              value: progress.vibrationEnabled,
              onChanged: (_) {
                ref.read(progressProvider.notifier).toggleVibration();
              },
              activeColor: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          // Appearance section
          _SectionHeader(title: 'Appearance'),
          _SettingsTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: progress.darkModeEnabled,
              onChanged: (_) {
                ref.read(progressProvider.notifier).toggleDarkMode();
              },
              activeColor: AppColors.primary,
            ),
          ),

          const SizedBox(height: 16),

          // Data section
          _SectionHeader(title: 'Data'),
          _SettingsTile(
            icon: Icons.restore,
            title: 'Reset All Progress',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showResetDialog(context, ref),
          ),

          const SizedBox(height: 16),

          // About section
          _SectionHeader(title: 'About'),
          _SettingsTile(
            icon: Icons.star_outline,
            title: 'Rate This App',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Replace with actual store URL
            },
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              // TODO: Replace with actual URL
              final uri = Uri.parse('https://example.com/privacy');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Version',
            trailing: const Text(
              '1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'This will delete all your progress including completed levels, '
          'stars, and daily challenge data. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(progressProvider.notifier).resetAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress reset')),
              );
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
