import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newu/components/duration_control_row.dart';
import 'package:newu/components/rounded_action_button.dart';
import 'package:newu/components/selectable_chip.dart';
import 'package:newu/providers/theme_provider.dart';
import 'package:newu/screens/breathing_session_screen.dart';

class SetPaceScreen extends ConsumerStatefulWidget {
  const SetPaceScreen({super.key});

  @override
  ConsumerState<SetPaceScreen> createState() => _SetPaceScreenState();
}

class _SetPaceScreenState extends ConsumerState<SetPaceScreen> {
  int _selectedDuration = 4;
  int _selectedRoundIndex = 1;
  bool _isAdvancedExpanded = false;
  bool _soundEnabled = true;

  int _breatheIn = 4;
  int _holdIn = 4;
  int _breatheOut = 4;
  int _holdOut = 4;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

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
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
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
                  ),
                ),

                Text(
                  "Set your breathing pace",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF630068),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Customise your breathing session. You\ncan always change this later.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: isDarkMode
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(
                                  "Breath duration",
                                  theme,
                                  isDarkMode,
                                ),
                                _buildSectionSubtitle(
                                  "Seconds per phase",
                                  theme,
                                  isDarkMode,
                                ),
                                const SizedBox(height: 12),
                                SingleChildScrollView(
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      _buildDurationChip(3, isDarkMode),
                                      _buildDurationChip(4, isDarkMode),
                                      _buildDurationChip(5, isDarkMode),
                                      _buildDurationChip(6, isDarkMode),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                _buildSectionTitle("Rounds", theme, isDarkMode),
                                _buildSectionSubtitle(
                                  "Full box breathing cycles",
                                  theme,
                                  isDarkMode,
                                ),
                                const SizedBox(height: 12),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      _buildRoundChip(0, "2 quick", isDarkMode),
                                      _buildRoundChip(1, "4 calm", isDarkMode),
                                      _buildRoundChip(2, "6 deep", isDarkMode),
                                      _buildRoundChip(3, "8 zen", isDarkMode),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                Theme(
                                  data: Theme.of(
                                    context,
                                  ).copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    initiallyExpanded: _isAdvancedExpanded,
                                    tilePadding: EdgeInsets.zero,
                                    childrenPadding: EdgeInsets.zero,
                                    title: _buildSectionTitle(
                                      "Advanced timing",
                                      theme,
                                      isDarkMode,
                                    ),
                                    subtitle: _buildSectionSubtitle(
                                      "Set different durations for each phase",
                                      theme,
                                      isDarkMode,
                                    ),
                                    trailing: Icon(
                                      _isAdvancedExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.grey,
                                    ),
                                    onExpansionChanged: (expanded) {
                                      setState(() {
                                        _isAdvancedExpanded = expanded;
                                        if (!expanded) {
                                          _breatheIn = _selectedDuration;
                                          _holdIn = _selectedDuration;
                                          _breatheOut = _selectedDuration;
                                          _holdOut = _selectedDuration;
                                        }
                                      });
                                    },
                                    children: [
                                      const SizedBox(height: 16),
                                      DurationControlRow(
                                        label: "Breathe in",
                                        value: _breatheIn,
                                        onDecrease: () => setState(
                                          () => _breatheIn = (_breatheIn - 1)
                                              .clamp(2, 10),
                                        ),
                                        onIncrease: () => setState(
                                          () => _breatheIn = (_breatheIn + 1)
                                              .clamp(2, 10),
                                        ),
                                        textColor: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      DurationControlRow(
                                        label: "Hold in",
                                        value: _holdIn,
                                        onDecrease: () => setState(
                                          () => _holdIn = (_holdIn - 1).clamp(
                                            2,
                                            10,
                                          ),
                                        ),
                                        onIncrease: () => setState(
                                          () => _holdIn = (_holdIn + 1).clamp(
                                            2,
                                            10,
                                          ),
                                        ),
                                        textColor: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      DurationControlRow(
                                        label: "Breathe out",
                                        value: _breatheOut,
                                        onDecrease: () => setState(
                                          () => _breatheOut = (_breatheOut - 1)
                                              .clamp(2, 10),
                                        ),
                                        onIncrease: () => setState(
                                          () => _breatheOut = (_breatheOut + 1)
                                              .clamp(2, 10),
                                        ),
                                        textColor: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      DurationControlRow(
                                        label: "Hold out",
                                        value: _holdOut,
                                        onDecrease: () => setState(
                                          () => _holdOut = (_holdOut - 1).clamp(
                                            2,
                                            10,
                                          ),
                                        ),
                                        onIncrease: () => setState(
                                          () => _holdOut = (_holdOut + 1).clamp(
                                            2,
                                            10,
                                          ),
                                        ),
                                        textColor: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildSectionTitle(
                                          "Sound",
                                          theme,
                                          isDarkMode,
                                        ),
                                        _buildSectionSubtitle(
                                          "Gentle chime between phases",
                                          theme,
                                          isDarkMode,
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      value: _soundEnabled,
                                      activeThumbColor: Colors.white,
                                      activeTrackColor: const Color(0xFF630068),
                                      onChanged: (val) {
                                        setState(() {
                                          _soundEnabled = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: RoundedActionButton(
                            text: "Start breathing",
                            iconPath: 'assets/breathing.svg',
                            isLeading: false,
                            backgroundColor: const Color(0xFF630068),
                            foregroundColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BreathingSessionScreen(
                                    breatheInDuration: _breatheIn,
                                    holdInDuration: _holdIn,
                                    breatheOutDuration: _breatheOut,
                                    holdOutDuration: _holdOut,
                                    totalRounds: _getRoundCount(
                                      _selectedRoundIndex,
                                    ),
                                    soundEnabled: _soundEnabled,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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

  Widget _buildSectionTitle(String title, ThemeData theme, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildSectionSubtitle(
    String subtitle,
    ThemeData theme,
    bool isDarkMode,
  ) {
    return Text(
      subtitle,
      style: TextStyle(
        fontSize: 14,
        color: isDarkMode ? Colors.white60 : Colors.grey[600],
      ),
    );
  }

  Widget _buildDurationChip(int duration, bool isDarkMode) {
    final isSelected = _selectedDuration == duration;
    return SelectableChip(
      label: "${duration}s",
      isSelected: isSelected,
      isCircular: false,
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF5F5F5),
      selectedBackgroundColor: isDarkMode
          ? Color(0xFFF57C00).withOpacity(0.2)
          : const Color(0xFFFFF3E0),
      baseTextColor: isDarkMode ? Colors.white70 : Colors.grey,
      onTap: () {
        setState(() {
          _selectedDuration = duration;
          _breatheIn = duration;
          _holdIn = duration;
          _breatheOut = duration;
          _holdOut = duration;
        });
      },
    );
  }

  Widget _buildRoundChip(int index, String label, bool isDarkMode) {
    final isSelected = _selectedRoundIndex == index;
    return SelectableChip(
      label: label,
      isSelected: isSelected,
      isCircular: false,
      backgroundColor: isDarkMode ? Color(0xFF141414) : Color(0xFFF5F5F5),
      selectedBackgroundColor: isDarkMode
          ? Color(0xFFF57C00).withOpacity(0.2)
          : Color(0xFFFFF3E0),
      baseTextColor: isDarkMode ? Colors.white70 : Colors.grey,
      onTap: () => setState(() => _selectedRoundIndex = index),
    );
  }

  int _getRoundCount(int index) {
    switch (index) {
      case 0:
        return 2;
      case 1:
        return 4;
      case 2:
        return 6;
      case 3:
        return 8;
      default:
        return 4;
    }
  }
}
