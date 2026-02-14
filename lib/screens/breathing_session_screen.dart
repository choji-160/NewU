import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newu/components/cycle_progress_bar.dart';
import 'package:newu/components/rounded_action_button.dart';
import 'package:newu/providers/theme_provider.dart';
import 'package:newu/screens/finish_session_screen.dart';

enum BreathingPhase {
  getReady,
  breatheIn,
  holdIn,
  breatheOut,
  holdOut,
  complete,
}

class BreathingSessionScreen extends ConsumerStatefulWidget {
  final int breatheInDuration;
  final int holdInDuration;
  final int breatheOutDuration;
  final int holdOutDuration;
  final int totalRounds;
  final bool soundEnabled;

  const BreathingSessionScreen({
    super.key,
    required this.breatheInDuration,
    required this.holdInDuration,
    required this.breatheOutDuration,
    required this.holdOutDuration,
    required this.totalRounds,
    required this.soundEnabled,
  });

  @override
  ConsumerState<BreathingSessionScreen> createState() =>
      _BreathingSessionScreenState();
}

class _BreathingSessionScreenState extends ConsumerState<BreathingSessionScreen>
    with TickerProviderStateMixin {
  late BreathingPhase _phase;
  int _currentRound = 1;
  int _secondsRemaining = 3;
  Timer? _timer;
  bool _isPaused = false;
  late AudioPlayer _audioPlayer;

  late AnimationController _bubbleController;
  late Animation<double> _bubbleAnimation;

  late AnimationController _progressController;

  String _statusMessage = "You're a natural";
  final List<String> _statusMessages = [
    "You're a natural",
    "So peaceful right now",
    "Look at you go",
    "Nothing to fix, just breathe",
  ];

  @override
  void initState() {
    super.initState();
    _statusMessage = (_statusMessages..shuffle()).first;
    _phase = BreathingPhase.getReady;
    _audioPlayer = AudioPlayer();

    _bubbleController = AnimationController(vsync: this);

    _bubbleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(_bubbleController);

    int cycleDuration =
        widget.breatheInDuration +
        widget.holdInDuration +
        widget.breatheOutDuration +
        widget.holdOutDuration;
    int totalDuration = (widget.totalRounds * cycleDuration);

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalDuration),
    );

    _startSession();
  }

  void _startSession() {
    _startPhaseTimer();
  }

  void _startPhaseTimer() {
    _setupPhaseAnimation();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      setState(() {
        if (_secondsRemaining > 1) {
          _secondsRemaining--;
        } else {
          _nextPhase();
        }
      });
    });
  }

  void _setupPhaseAnimation() {
    _bubbleController.duration = Duration(seconds: _secondsRemaining);

    switch (_phase) {
      case BreathingPhase.getReady:
        _bubbleAnimation = Tween<double>(
          begin: 1.0,
          end: 1.0,
        ).animate(_bubbleController);

        break;
      case BreathingPhase.breatheIn:
        _bubbleAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
          CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
        );
        _bubbleController.forward(from: 0);
        break;
      case BreathingPhase.holdIn:
        _bubbleAnimation = Tween<double>(
          begin: 0.5,
          end: 0.5,
        ).animate(_bubbleController);
        break;
      case BreathingPhase.breatheOut:
        _bubbleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOut),
        );
        _bubbleController.forward(from: 0);
        break;
      case BreathingPhase.holdOut:
        _bubbleAnimation = Tween<double>(
          begin: 1.0,
          end: 1.0,
        ).animate(_bubbleController);
        break;
      case BreathingPhase.complete:
        break;
    }
  }

  void _nextPhase() {
    _timer?.cancel();
    _bubbleController.stop();

    switch (_phase) {
      case BreathingPhase.getReady:
        _phase = BreathingPhase.breatheIn;
        _secondsRemaining = widget.breatheInDuration;
        _progressController.forward();
        _playSound();
        break;
      case BreathingPhase.breatheIn:
        _phase = BreathingPhase.holdIn;
        _secondsRemaining = widget.holdInDuration;
        _playSound();
        break;
      case BreathingPhase.holdIn:
        _phase = BreathingPhase.breatheOut;
        _secondsRemaining = widget.breatheOutDuration;
        _playSound();
        break;
      case BreathingPhase.breatheOut:
        _phase = BreathingPhase.holdOut;
        _secondsRemaining = widget.holdOutDuration;
        _playSound();
        break;
      case BreathingPhase.holdOut:
        if (_currentRound < widget.totalRounds) {
          _currentRound++;
          _phase = BreathingPhase.breatheIn;
          _secondsRemaining = widget.breatheInDuration;
          _playSound();
        } else {
          _phase = BreathingPhase.complete;
          _progressController.stop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => FinishSessionScreen(
                breatheInDuration: widget.breatheInDuration,
                holdInDuration: widget.holdInDuration,
                breatheOutDuration: widget.breatheOutDuration,
                holdOutDuration: widget.holdOutDuration,
                totalRounds: widget.totalRounds,
                soundEnabled: widget.soundEnabled,
              ),
            ),
          );
          return;
        }
        break;
      case BreathingPhase.complete:
        return;
    }

    _startPhaseTimer();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _bubbleController.stop();
        _progressController.stop();
      } else {
        if (_bubbleController.isAnimating) {
          _bubbleController.forward();
        }
        _progressController.forward();
      }
    });
  }

  Future<void> _playSound() async {
    if (widget.soundEnabled) {
      try {
        await _audioPlayer.play(AssetSource('chime.mp3'));
      } catch (e) {
        debugPrint("Error playing sound: $e");
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bubbleController.dispose();
    _progressController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: textColor),
                      ),
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
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                      maxHeight: double.infinity,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _statusMessage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: subTextColor,
                          ),
                        ),

                        const Spacer(),

                        AnimatedBuilder(
                          animation: _bubbleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _bubbleAnimation.value,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    center: const Alignment(-0.2, -0.3),
                                    radius: 0.8846,
                                    colors: isDarkMode
                                        ? [
                                            const Color.fromRGBO(
                                              201,
                                              124,
                                              245,
                                              0.4,
                                            ),
                                            const Color.fromRGBO(
                                              201,
                                              124,
                                              245,
                                              0.1,
                                            ),
                                          ]
                                        : [
                                            const Color.fromRGBO(
                                              123,
                                              45,
                                              142,
                                              0.2,
                                            ),
                                            const Color.fromRGBO(
                                              123,
                                              45,
                                              142,
                                              0.05,
                                            ),
                                          ],
                                    stops: const [0.0, 1.0],
                                  ),
                                  border: Border.all(
                                    color: isDarkMode
                                        ? const Color(0x40C97CF5)
                                        : const Color(0x1F7B2D8E),
                                    width: isDarkMode ? 1.0 : 0.88,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$_secondsRemaining",
                                    style: theme.textTheme.displayMedium
                                        ?.copyWith(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const Spacer(),

                        Text(
                          _getPhaseTitle(),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          _getPhaseSubtitle(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: subTextColor,
                          ),
                        ),

                        const SizedBox(height: 40),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              if (_phase != BreathingPhase.getReady) ...[
                                AnimatedBuilder(
                                  animation: _progressController,
                                  builder: (context, child) {
                                    return CycleProgressBar(
                                      currentStep:
                                          (_progressController.value * 1000)
                                              .toInt(),
                                      totalSteps: 1000,
                                      backgroundColor: isDarkMode
                                          ? Colors.white24
                                          : const Color(0xFFF3E5F5),
                                      gradientStartColor: isDarkMode
                                          ? const Color(0xFFF57C00)
                                          : const Color(0xFFF57C00),
                                      gradientEndColor: isDarkMode
                                          ? const Color(0xFF8A2BE2)
                                          : const Color(0xFF630068),
                                    );
                                  },
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Cycle $_currentRound of ${widget.totalRounds}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: subTextColor,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        RoundedActionButton(
                          text: _isPaused ? "Resume" : "Pause",
                          iconPath:
                              'assets/${isDarkMode ? "darkmode" : "lighmode"}/${_isPaused ? "resume.svg" : "pause.svg"}',
                          isLeading: true,
                          backgroundColor: isDarkMode
                              ? Color(0xFF823386)
                              : Color(0xFF630068).withOpacity(0.1),
                          foregroundColor: textColor,
                          onPressed: _togglePause,
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPhaseTitle() {
    switch (_phase) {
      case BreathingPhase.getReady:
        return "Get ready";
      case BreathingPhase.breatheIn:
        return "Breathe in";
      case BreathingPhase.holdIn:
        return "Hold softly";
      case BreathingPhase.breatheOut:
        return "Breathe out";
      case BreathingPhase.holdOut:
        return "Hold gently";
      case BreathingPhase.complete:
        return "Complete";
    }
  }

  String _getPhaseSubtitle() {
    switch (_phase) {
      case BreathingPhase.getReady:
        return "Get going on your breathing session";
      case BreathingPhase.breatheIn:
        return "nice and slow";
      case BreathingPhase.holdIn:
        return "hold softly";
      case BreathingPhase.breatheOut:
        return "relax and let go";
      case BreathingPhase.holdOut:
        return "wait for it";
      case BreathingPhase.complete:
        return "Well done";
    }
  }
}
