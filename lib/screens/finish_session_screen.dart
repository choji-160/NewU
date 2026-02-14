import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:newu/components/rounded_action_button.dart';
import 'package:newu/providers/theme_provider.dart';
import 'package:newu/screens/breathing_session_screen.dart';

class FinishSessionScreen extends ConsumerWidget {
  final int breatheInDuration;
  final int holdInDuration;
  final int breatheOutDuration;
  final int holdOutDuration;
  final int totalRounds;
  final bool soundEnabled;

  const FinishSessionScreen({
    super.key,
    required this.breatheInDuration,
    required this.holdInDuration,
    required this.breatheOutDuration,
    required this.holdOutDuration,
    required this.totalRounds,
    required this.soundEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF630068);
    final subTextColor = isDarkMode ? Colors.white70 : Colors.grey[600];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: isDarkMode ? Alignment.topCenter : Alignment.topRight,
                  end: isDarkMode
                      ? Alignment.bottomCenter
                      : Alignment.bottomLeft,
                  colors: isDarkMode
                      ? [
                          const Color(0xFF1A1128),
                          const Color(0xFF2D1B4E),
                          const Color(0xFF3A2260),
                        ]
                      : [
                          const Color.fromRGBO(99, 0, 104, 0.08),
                          const Color.fromRGBO(255, 138, 0, 0.08),
                        ],
                  stops: isDarkMode ? [0.0, 0.4, 1.0] : [0.3121, 0.6944],
                ),
              ),
              child: SvgPicture.asset(
                isDarkMode
                    ? 'assets/darkmode/background.svg'
                    : 'assets/lighmode/background.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.08),
                          ),
                          child: IconButton(
                            onPressed: () {
                              ref.read(themeProvider.notifier).toggle();
                            },
                            icon: SvgPicture.asset(
                              isDarkMode
                                  ? 'assets/darkmode/sun.svg'
                                  : 'assets/lighmode/moon.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: Lottie.asset('assets/completion.json'),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              "You did it! 🎉",
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "Great rounds of calm, just like that.\nYour mind thanks you.",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: subTextColor,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 12),

                            RoundedActionButton(
                              text: "Start again",
                              iconPath: 'assets/breathing.svg',
                              isLeading: false,
                              backgroundColor: const Color(0xFF630068),
                              foregroundColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BreathingSessionScreen(
                                          breatheInDuration: breatheInDuration,
                                          holdInDuration: holdInDuration,
                                          breatheOutDuration:
                                              breatheOutDuration,
                                          holdOutDuration: holdOutDuration,
                                          totalRounds: totalRounds,
                                          soundEnabled: soundEnabled,
                                        ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: textColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 32,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    color: isDarkMode
                                        ? Colors.white24
                                        : Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                "Back to set up",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ),

                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
