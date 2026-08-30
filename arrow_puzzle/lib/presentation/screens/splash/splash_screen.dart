import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/providers.dart';

/// Splash screen shown on app launch.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final progress = ref.read(progressProvider);
    if (progress.hasSeenOnboarding) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Arrow icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 56,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                  duration: 600.ms,
                )
                .then()
                .shimmer(duration: 800.ms),

            const SizedBox(height: 24),

            // Title
            const Text(
              'Arrow Puzzle',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

            const SizedBox(height: 8),

            Text(
              'Tap to clear the path',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
