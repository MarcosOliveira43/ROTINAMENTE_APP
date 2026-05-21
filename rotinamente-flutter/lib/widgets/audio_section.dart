import 'package:flutter/material.dart';

class AudioSection extends StatelessWidget {
  final bool isRecording;
  final bool isPlaying;
  final VoidCallback onToggleRecording;
  final VoidCallback onTogglePlayback;

  const AudioSection({
    super.key,
    required this.isRecording,
    required this.isPlaying,
    required this.onToggleRecording,
    required this.onTogglePlayback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                isRecording ? Icons.mic : Icons.mic_none,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                isRecording ? 'Gravando...' : 'Pronto para gravar',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isPlaying
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
                    onPressed: onToggleRecording,
                    icon: Icon(
                      isRecording ? Icons.stop : Icons.fiber_manual_record,
                    ),
                    label: Text(isRecording ? 'Parar' : 'Gravar'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(140, 52),
                      backgroundColor: isRecording
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  OutlinedButton.icon(
                    onPressed: onTogglePlayback,
                    icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                    label: Text(isPlaying ? 'Parar' : 'Reproduzir'),
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
