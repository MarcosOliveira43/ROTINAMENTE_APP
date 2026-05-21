import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/timer_section.dart';
import '../widgets/audio_section.dart';
import '../widgets/custom_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMinutes = 1;

  int get _startSeconds => _selectedMinutes * 60;
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _isRunning = false;
  bool _hasTaskCompleted = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _dialogVisible = false;

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _hasTaskCompleted = false;
      _dialogVisible = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        _timer = null;
        if (!_hasTaskCompleted) {
          setState(() => _isRunning = false);
          _showTimerEndedDialog();
        }
        return;
      }
      setState(() => _secondsRemaining -= 1);
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = _startSeconds;
      _isRunning = false;
      _dialogVisible = false;
    });
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _isPlaying = false;
      }
    });
  }

  void _togglePlayback() {
    if (_isRecording) return;
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String get _formattedTime {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _showDialogWrapper(String title, String subtitle) async {
    if (_dialogVisible || !mounted) return;
    setState(() => _dialogVisible = true);

    await showCustomDialog(context, title, subtitle);

    if (mounted) setState(() => _dialogVisible = false);
  }

  Future<void> _completeTask() async {
    _timer?.cancel();
    _timer = null;

    setState(() {
      _isRunning = false;
      _hasTaskCompleted = true;
      _dialogVisible = false;
    });

    await _showDialogWrapper('⭐ Você conseguiu!', 'Ótimo trabalho!');
    _resetTimer();
  }

  void _showTimerEndedDialog() {
    _showDialogWrapper('⏰ Tempo encerrado', 'Tarefa não concluída');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = 1 - (_secondsRemaining / _startSeconds);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 28.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rotina contínua',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Gerencie seu tempo e registre sua voz em um fluxo único.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                TimerSection(
                  progress: progress,
                  formattedTime: _formattedTime,
                  isRunning: _isRunning,
                  selectedMinutes: _selectedMinutes,
                  onSelectedMinutesChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedMinutes = value;
                      _secondsRemaining = _startSeconds;
                    });
                  },
                  onStart: _startTimer,
                  onReset: _resetTimer,
                  onComplete: _completeTask,
                ),
                const SizedBox(height: 32),
                AudioSection(
                  isRecording: _isRecording,
                  isPlaying: _isPlaying,
                  onToggleRecording: _toggleRecording,
                  onTogglePlayback: _togglePlayback,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
