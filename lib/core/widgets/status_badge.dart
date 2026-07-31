import 'package:flutter/material.dart';

/// Small colored pill for a content `status` value (draft/published/archived).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color background, Color foreground) = switch (status) {
      'published' => (scheme.primaryContainer, scheme.onPrimaryContainer),
      'archived' => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      _ => (scheme.secondaryContainer, scheme.onSecondaryContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: foreground),
      ),
    );
  }
}
