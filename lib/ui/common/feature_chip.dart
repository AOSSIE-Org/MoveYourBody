import 'package:flutter/material.dart';

class FeatureChip extends StatelessWidget {
  const FeatureChip({
    super.key,
    required this.text,
    this.selected = false,
    this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.primary.withValues(alpha: 0.22),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
