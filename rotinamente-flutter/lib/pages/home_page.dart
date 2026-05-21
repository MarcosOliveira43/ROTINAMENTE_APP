import 'dart:async';

import 'package:flutter/material.dart';

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

  Future<void> _showDialog(String title, String subtitle) async {
    if (_dialogVisible || !mounted) return;
    setState(() => _dialogVisible = true);

    await showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );

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

    await _showDialog('⭐ Você conseguiu!', 'Ótimo trabalho!');
    _resetTimer();
  }

  void _showTimerEndedDialog() {
    _showDialog('⏰ Tempo encerrado', 'Tarefa não concluída');
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
                _buildTimerSection(theme, progress),
                const SizedBox(height: 32),
                _buildAudioSection(theme),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimerSection(ThemeData theme, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Timer',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 45,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Duração do timer',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedMinutes,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: const [1, 2, 3, 5, 10, 15, 20, 30]
                    .map(
                      (minutes) => DropdownMenuItem(
                        value: minutes,
                        child: Text(
                          '$minutes minuto${minutes == 1 ? '' : 's'}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _isRunning
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedMinutes = value;
                          _secondsRemaining = _startSeconds;
                        });
                      },
              ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 190,
                    height: 190,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 16,
                      color: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 46,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formattedTime,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isRunning ? 'Em andamento' : 'Pronto para iniciar',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _startTimer,
                    child: Text(_isRunning ? 'Contando' : 'Iniciar contador'),
                  ),
                  OutlinedButton(
                    onPressed: _resetTimer,
                    child: const Text('Reiniciar'),
                  ),
                  FilledButton(
                    onPressed: _completeTask,
                    child: const Text('Tarefa Finalizada'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Gravador de áudio',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 180,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Icon(
                _isRecording ? Icons.mic : Icons.mic_none,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                _isRecording ? 'Gravando...' : 'Pronto para gravar',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isPlaying
                    ? 'Reproduzindo gravação'
                    : 'Pressione gravar para iniciar',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: _toggleRecording,
                    icon: Icon(
                      _isRecording ? Icons.stop : Icons.fiber_manual_record,
                    ),
                    label: Text(_isRecording ? 'Parar' : 'Gravar'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(140, 52),
                      backgroundColor: _isRecording
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  OutlinedButton.icon(
                    onPressed: _togglePlayback,
                    icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                    label: Text(_isPlaying ? 'Parar' : 'Reproduzir'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(140, 52),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
