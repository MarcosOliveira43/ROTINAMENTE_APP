import 'package:flutter/material.dart';

class TimerSection extends StatelessWidget {
  final double progress;
  final String formattedTime;
  final bool isRunning;
  final int selectedMinutes;
  final ValueChanged<int?> onSelectedMinutesChanged;
  final VoidCallback onStart;
  final VoidCallback onReset;
  final VoidCallback onComplete;

  const TimerSection({
    super.key,
    required this.progress,
    required this.formattedTime,
    required this.isRunning,
    required this.selectedMinutes,
    required this.onSelectedMinutesChanged,
    required this.onStart,
    required this.onReset,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            children: [
              Column(
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
                    initialValue: selectedMinutes,
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
                    onChanged: isRunning ? null : onSelectedMinutesChanged,
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
                            formattedTime,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isRunning ? 'Em andamento' : 'Pronto para iniciar',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
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
                    onPressed: onStart,
                    child: Text(isRunning ? 'Contando' : 'Iniciar contador'),
                  ),
                  OutlinedButton(
                    onPressed: onReset,
                    child: const Text('Reiniciar'),
                  ),
                  FilledButton(
                    onPressed: onComplete,
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
}
