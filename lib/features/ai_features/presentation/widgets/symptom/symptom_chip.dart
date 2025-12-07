import 'package:flutter/material.dart';

/// Widget to display a symptom chip
class SymptomChip extends StatelessWidget {
  final String symptom;
  final VoidCallback? onRemoved;

  const SymptomChip({
    super.key,
    required this.symptom,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(symptom),
      deleteIcon: onRemoved != null ? const Icon(Icons.cancel) : null,
      onDeleted: onRemoved,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
