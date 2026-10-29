import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureChip(text: 'Your feature text here');
  }
}

class FeatureChip extends StatelessWidget {
  const FeatureChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.22)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
      ),
    );
  }
}
